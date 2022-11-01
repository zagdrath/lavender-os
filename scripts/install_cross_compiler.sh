#!/bin/sh

binutils_version=binutils-2.39
gcc_version=gcc-12.2.0

sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo

mkdir $HOME/src
cd $HOME/src

wget -nc http://ftp.gnu.org/gnu/binutils/binutils-$binutils_version.tar.gz
wget -nc https://ftp.gnu.org/gnu/gcc/$gcc_version/$gcc_version.tar.gz

tar -xf binutils-$binutils_version.tar.gz
tar -xf $gcc_version.tar.gz

export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

mkdir build-binutils
cd build-binutils
../binutils-$binutils_version/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
cd ..

# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH

mkdir build-gcc
cd build-gcc
../gcc-$gcc_version/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
cd ..

export PATH="$HOME/opt/cross/bin:$PATH"
echo 'PATH="$HOME/opt/cross/bin:$PATH"' >> $HOME/.bashrc