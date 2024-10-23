#!/usr/bin/env bash

echo "Hello dev tool"
echo $(uname)
INSTALL_CMD="sudo apt install -y"
case $(uname) in
  *Linux)
    ;;
  *BSD)
    INSTALL_CMD="sudo pkg install -y"
    ;;
  *)
    echo "!!! Sorry Unsupported. !!! "
    exit 1
    ;;
esac

function check_cmd {
  local cmd=$1
  local pkg=$2
  if [ -z "$pkg" ]; then
    pkg=$cmd
  fi
  echo "=========================="
  echo "    check for $cmd ...    "
  local reply=$(which $cmd)
  # echo "reply -> [$reply]"
  if [ -z "$reply" ]; then
    echo "$cmd not found"
    echo "$INSTALL_CMD $pkg"
  else
    echo "$cmd --> [${reply}]"
  fi
  echo "=========================="
}

function install_vimrc {
if [ ! -f ~/.vimrc ]; then
cat <<EOF_VIMRC >> ~/.vimrc
set number
syntax on
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
EOF_VIMRC
fi
}

check_cmd git
check_cmd gh
check_cmd clang
check_cmd vim
check_cmd emacs
check_cmd curl
check_cmd locate2 plocate
install_vimrc

cat <<EOF > /dev/null
Usage: uname [OPTION]...
Print certain system information.  With no OPTION, same as -s.

  -a, --all                print all information, in the following order,
                             except omit -p and -i if unknown:
  -s, --kernel-name        print the kernel name
  -n, --nodename           print the network node hostname
  -r, --kernel-release     print the kernel release
  -v, --kernel-version     print the kernel version
  -m, --machine            print the machine hardware name
  -p, --processor          print the processor type (non-portable)
  -i, --hardware-platform  print the hardware platform (non-portable)
  -o, --operating-system   print the operating system
      --help        display this help and exit
      --version     output version information and exit

GNU coreutils online help: <https://www.gnu.org/software/coreutils/>
Full documentation <https://www.gnu.org/software/coreutils/uname>
or available locally via: info '(coreutils) uname invocation'
EOF

