#!/usr/bin/env bash

echo "Hello dev tool"
echo $(uname)
INSTALL_CMD="sudo apt install -y"
NIX_ID="linux"
case $(uname) in
  *Linux)
    ;;
  *BSD)
    NIX_ID="bsd"
    INSTALL_CMD="sudo pkg install -y"
    ;;
  *)
    echo "!!! Sorry Unsupported. !!! "
    exit 1
    ;;
esac

function ensure_cmd {
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
    $INSTALL_CMD "$pkg"
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

# archiver
ensure_cmd zip
ensure_cmd unzip

# network
ensure_cmd curl
ensure_cmd git
ensure_cmd gh
ensure_cmd avahi-browse avahi-utils

# building
ensure_cmd clang
if [ $NIX_ID = "bsd" ]; then
  ensure_cmd make gmake
  ensure_cmd ninja
else
  ensure_cmd make build-essential
  ensure_cmd ninja ninja-build
fi
ensure_cmd cmake

# editor
ensure_cmd vim
ensure_cmd emacs

#other
ensure_cmd locate plocate
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

