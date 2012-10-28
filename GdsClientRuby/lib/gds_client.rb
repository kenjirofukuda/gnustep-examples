#!/usr/bin/env ruby

#-------------------------------------------------------------------------------
# GdsFeel's input client
#
# $Id: gds_client.rb,v 1.10 2009/06/09 00:51:00 kenjiro Exp $
#
# @modified 2009/06/09
# @version  3
# @auther   gdsfeel.com
#-------------------------------------------------------------------------------
require 'socket'
require 'readline'
#require 'gds'
require File.join(File.expand_path(File.dirname(__FILE__)), 'gds')

# @see http://www.ruby-lang.org/ja/man/html/readline.html
stty_save = `stty -g`.chomp
trap("INT") { system "stty", stty_save; exit }

include Gds

def send_buff(input)
 input + Gds::TO_SERVER_END
end

def handle_recv_buff(buff)
  eos_pos = buff.index(Gds::FROM_SERVER_END)
  reply = buff[0,eos_pos]
  reply.each_line(Gds::SERVER_NL) { |line| puts line }
end

def handle_input_classic(input)
  sock = nil
  begin
    sock = TCPSocket.open(Gds::SERVER_ADDR, PORT)
    sock.write(send_buff(input))
    buff = sock.recv(Gds::BUFFER_SIZE)
    handle_recv_buff(buff)
  rescue
    p $!
  ensure
    if ! sock.nil?
      sock.close
      sock = nil
    end
  end
end

def entry_point
  puts "!!! Welcome to GDSII Service !!!"
  if Gds::server_alive?
    if $session.nil?
      Gds::input_loop { |input| handle_input_classic(input) }
    else
      $session.run
    end
  else
    STDERR.puts "*** WARNING *** GdsServer down."
    STDERR.puts "                to start 'GdsServer start.' on Squeak "
  end
  puts "!!! Good Bye !!!"
end


if ARGV.size == 0
  $session = Gds::IoSession.new
else
  # classic version debug
  $session = nil
end
entry_point

# vim: ts=2 sw=2 expandtab
