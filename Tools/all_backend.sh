#!/bin/bash

# cd {libs-back}

./configure --enable-graphics=xlib --with-name=xlib 
make
sudo -E make install
make distclean

./configure --enable-graphics=art --with-name=art 
make
sudo -E make install
make distclean

./configure --enable-graphics=cairo --with-name=cairo 
make
sudo -E make install
make distclean
