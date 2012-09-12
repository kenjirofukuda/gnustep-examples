#!/usr/bin/env ruby

#-------------------------------------------------------------------------------
# GdsFeel's input client
#
# $Id: gds.rb,v 1.11 2009/06/09 00:51:00 kenjiro Exp $
#
# @modified 2009/06/09
# @version  3
# @auther   gdsfeel.com
#-------------------------------------------------------------------------------
require 'socket'
require 'readline'

module Gds

  PORT            = 9999
  BUFFER_SIZE     = 2000
  HEADER_SIZE     = 20
  TO_SERVER_END   = 10.chr
  FROM_SERVER_END = 0.chr
  SERVER_NL       = 13.chr
  PROMPT          = "? "
  SERVER_ADDR     = 'localhost'
  HEADER_PACK_FORMAT = "c3xN4"

  PHASE_ENTER     = 1
  PHASE_RUNLOOP   = 0
  PHASE_EXIT      = 2

  TYPE_NORMAL         = 0
  TYPE_PROMPT         = 1
  TYPE_PROMPT_REPLY   = 2
  TYPE_CODE_COMPLETE  = 3

  $complete_words = []
  
  class IoRecord
    attr_reader   :kind, :base64
    attr_accessor :phase, :desc, :nconsume, :nsplit, :session, :session_id

    def initialize
      @phase    = PHASE_RUNLOOP
      @kind     = TYPE_NORMAL
      @desc     = STDOUT.fileno
      @session_id  = 1
      @nsplit   = 1
      @nconsume = 1
      @fragment_size = 0
      @base64   = ""
      @session = nil
    end

    def inspect_bytes(bytes)
      unless bytes.size == BUFFER_SIZE
        raise ArgumentError, "illigal size: #{bytes.size}"
      end
      array = bytes.unpack(HEADER_PACK_FORMAT)
      @phase    = array[0]
      @kind     = array[1]
      @desc     = array[2]
      # padding array[3]
      @nsplit   = array[4]
      @nconsume  = array[5]
      @fragment_size = array[6]
      if @fragment_size > 0
        @base64 = bytes[20..(20 + @fragment_size)]
      else
        @base64 = ''
      end
    end

    def count_rest
      @nsplit - @nconsume
    end

    def base64=(encoded)
      unless encoded.size <= fragment_unit
        raise ArgumentError, "overflow size: #{encoded.size}"
      end
      @base64 = encoded
      @fragment_size = @base64.size
    end

    def has_more?
      count_rest > 0
    end

    def fragment_unit
      BUFFER_SIZE - HEADER_SIZE
    end

    def to_mime(text)
      [ text ].pack("m")
    end

    def make_base64_array(text)
      return [""].dup if text == ""
      encoded = to_mime(text)
      records = []
      @nsplit = encoded.size / fragment_unit
      for i in (0..@nsplit - 1)
        si = i * fragment_unit
        ei = si + fragment_unit - 1
        records.push(encoded[si..ei])
      end
      rest = encoded.size % fragment_unit
      if rest != 0
        @nsplit += 1
        records.push(encoded[-rest .. -1])
      end
      records
    end

    def header_consumed(consume, size)
      head = [@phase, @kind, @desc, @session_id, @nsplit, consume, size]
      head.pack(HEADER_PACK_FORMAT)
    end

    def header
      header_consumed(@nconsume, @fragment_size)
    end

    def bytes
      header + @base64 + (0.chr * padding_size)
    end

    def padding_size
      fragment_unit - @fragment_size
    end

    def up_session_id
      @session_id += 1
      self
    end

    def type_set_by(session)
      @kind = session.in_textinput ? TYPE_PROMPT_REPLY : TYPE_NORMAL
    end

  end # -- IoRecord

  class IoRequest < IoRecord
    attr_reader :base64_fragments
    attr_reader :message

    def initialize
      super()
      @message = ''
      @base64_fragments = []
    end

    def message=(text)
      @message = text
      @base64_fragments = make_base64_array(text)
    end

    def records
      recs = base64_fragments.collect {|fragment|
        rec = self.clone
        rec.base64 = fragment
        rec
      }
      recs.each_with_index {|rec, zero_index|
        rec.nsplit = recs.size
        rec.nconsume = zero_index + 1
        rec.type_set_by(@session)
      }
      recs
    end

    def send(sock, text)
      self.message = text
      self.records.each {|rec|
        bytes = rec.bytes
        sock.write(bytes)
      }
    end

  end # -- IoRequest

  class IoReply < IoRecord

    def initialize()
      super()
      @elements = []
    end

    def records(&get_bytes_proc)
      bytes = get_bytes_proc.call
      inspect_bytes(bytes)
      result = [self]
      count_rest.times {
        bytes = get_bytes_proc.call
        cloned = self.clone
        cloned.inspect_bytes(bytes)
        result.push(cloned)
      }
      result
    end

    def message(&get_bytes_proc)
      recs = records(&get_bytes_proc)
      all_base64 = recs.collect {|each| each.base64}.join
      (all_base64.unpack("m"))[0]
    end

    def recv(sock)
      reply = message {sock.recv(BUFFER_SIZE)}
      if @kind == Gds::TYPE_PROMPT
        @session.prompt = (reply.split(SERVER_NL))[0]
        return
      end
      if @kind == Gds::TYPE_CODE_COMPLETE
        $complete_words = reply.split(SERVER_NL)
        return
      end
      reply.each_line(SERVER_NL) { |line| puts line }
      @session.reset_prompt
    end
  end # -- IoReply

  class IoSession < IoRecord
    attr_accessor :in_textinput
    attr_reader   :prompt
    def initialize()
      super()
      @request = IoRequest.new
      @request.session = self
      @reply = IoReply.new
      @reply.session = self
      @records = []
      @sock = nil
      @prompt = nil
      @in_textinput = false
    end

    def add(record)
      records.push(record)
    end

    def enter_session
      # @see http://www.ruby-lang.org/ja/man/html/readline.html
      Readline.completion_case_fold = true
      Readline.completion_proc = proc {|word|
        $complete_words.grep(/\A#{Regexp.quote word}/)
      }
      @request.phase = PHASE_ENTER
      basic_out("enter_session")
    end

    def turn_runloop
      @request.phase = PHASE_RUNLOOP
    end

    def exit_session
      @request.phase = PHASE_EXIT
      basic_out("exit_session")
    end

    def out(text)
      @request.desc = STDOUT.fileno
      basic_out(text)
    end

    def err(text)
      @request.desc = STDERR.fileno
      basic_out(text)
    end

    def basic_out(text)
      process_line(text)
    end

    def process_line(text)
      sock_do { |sock|
        @request.send(sock, text)
        if @request.phase != PHASE_EXIT
          @reply.recv(sock)
        end
      }
      up_session_id
    end

    def up_session_id
      @session_id += 1
      @request.session_id = @session_id
    end

    def sock_do(&block)
      sock = nil
      begin
        sock = TCPSocket.open(SERVER_ADDR, PORT)
        block.call(sock)
      rescue
        p $!
      ensure
        if ! sock.nil?
          sock.close
          sock = nil
        end
      end
    end

    def prompt
      if @prompt.nil?
        PROMPT
      else
        @prompt
      end
    end

    def prompt=(text)
      @prompt = text
      @in_textinput = ! @prompt.nil?
    end

    def reset_prompt
      self.prompt = nil
    end

    def input_loop(&block)
      while (true)
        input = Readline.readline(prompt, true)
        if input.nil? then break end
        input = input.chomp
        if input.strip == "exit" then break end
        block.call(input)
      end
    end

    def run
      self.enter_session
      self.turn_runloop
      self.input_loop { |text|
        process_line(text)
      }
      self.exit_session
    end


  end # -- IoSession

  # export global methods for classic

  def server_alive?
    result = true
    begin
      sock = TCPSocket.open(SERVER_ADDR, PORT)
    rescue => ex
      result = false
    ensure
      if ! sock.nil?
        sock.close
        sock = nil
      end
    end
    result
  end

  def input_loop(&block)
    while (true)
      input = Readline.readline(PROMPT, true)
      if input.nil? then break end
      input = input.chomp
      if input.strip == "exit" then break end
      block.call(input)
    end
  end

end # module

if __FILE__ == $0
  require 'test/unit'
  include Gds

  class IoRecordTest < Test::Unit::TestCase # :nodoc
    def setup
      @record = IoRecord.new
    end

    def test_phase
      assert_equal PHASE_RUNLOOP, @record.phase
    end

    def test_kind
      assert_equal TYPE_NORMAL, @record.kind
    end

    def test_desc
      assert_equal STDOUT.fileno, @record.desc
    end

    def test_has_more?
      assert_equal false, @record.has_more?
    end

    def test_count_rest
      assert_equal 0, @record.count_rest
    end

    def test_base64=
      assert_raise(ArgumentError) {@record.base64 = "0" * (BUFFER_SIZE + 1)}
    end

    def test_header
      assert_equal HEADER_SIZE, @record.header.size
    end

    def test_bytes
      assert_equal BUFFER_SIZE, @record.bytes.size
    end

    def test_make_base_64_array
      record = IoRecord.new
      result = record.make_base64_array("this is a log statement" * 100)
      assert result.size > 0
      assert result.all? { |base64| base64.size <= record.fragment_unit}
    end
  end

  class IoRequestTest < Test::Unit::TestCase # :nodoc
    def setup
      @request = IoRequest.new
    end

    def test_base64_fragments
      @request.message = '3 4 RESHAPE IOTA 12'
      assert_equal(true, @request.base64_fragments.size > 0)
      assert_kind_of String, @request.base64_fragments[0]

      @request.message = ''
      assert_equal(true, @request.base64_fragments.size > 0)
    end

    def test_records
      #@request.message = '3 4 RESHAPE IOTA 12' * 1000
      @request.message = '3 4 RESHAPE IOTA 12'
      assert @request.records.size > 0
      assert_kind_of IoRequest, @request.records[0]
      bytes_array = @request.records.collect {|each| each.bytes}
      assert bytes_array.all? { |each|
        (! each.nil?) && each.size == BUFFER_SIZE
      }
    end
  end

  class IoReplyTest < Test::Unit::TestCase # :nodoc
    def setup
      @reply = IoReply.new
      @request = IoRequest.new
      @request.message = '3 4 RESHAPE IOTA 12' * 1000
      @bytes_array = @request.records.collect {|each| each.bytes}
      @index = 0
    end

    def test_inspect_bytes
      bytes = @bytes_array[0]
      @reply.inspect_bytes(bytes)
      assert @reply.has_more?
      assert_equal((@bytes_array.size - 1), @reply.count_rest)
    end

    def test_records
      @index = 0
      result = @reply.records(&sample_proc)
      assert_equal(@bytes_array.size, result.size)
    end

    def test_message
      @index = 0
      result = @reply.message(&sample_proc)
      #p result
      assert_equal(@request.message, result)
    end

    private

    def sample_proc
      Proc.new {
        bytes = @bytes_array[@index]
        @index += 1
        bytes
      }
    end
  end

end

# vim: ts=2 sw=2 expandtab
