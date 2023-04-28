#!/bin/bash

# Define the installation directory for the dependencies and libtiff
PREFIX=/home/rctodd/code/local

# Create a temporary build directory
BUILD_DIR=$(mktemp -d)

#=====================================================================
# Download, build, and install zlib
cd $BUILD_DIR
wget  https://zlib.net/zlib-1.2.13.tar.gz
tar xf zlib-1.2.13.tar.gz
cd zlib-1.2.13
./configure --prefix=$PREFIX
make -j$(nproc)
make install


#=====================================================================
# Download, build, and install libjpeg
cd $BUILD_DIR
wget https://www.ijg.org/files/jpegsrc.v9d.tar.gz
tar xf jpegsrc.v9d.tar.gz
cd jpeg-9d
./configure --prefix=$PREFIX
make -j$(nproc)
make install


#=====================================================================
# Download, build, and install libtiff
cd $BUILD_DIR
wget https://download.osgeo.org/libtiff/tiff-4.3.0.tar.gz
tar xf tiff-4.3.0.tar.gz
cd tiff-4.3.0
./configure --prefix=$PREFIX --with-zlib=$PREFIX --with-jpeg-include-dir=$PREFIX/include --with-jpeg-lib-dir=$PREFIX/lib LDFLAGS="-Wl,-rpath=$PREFIX/lib"
make -j$(nproc)
make install


#=====================================================================
# Download and build SQLite3
cd $BUILD_DIR
wget https://www.sqlite.org/2023/sqlite-autoconf-3410200.tar.gz
tar -xf sqlite-autoconf-3410200.tar.gz
cd sqlite-autoconf-3410200
./configure --prefix=$PREFIX --disable-readline LDFLAGS="-Wl,-rpath=$PREFIX/lib"
make -j$(nproc)
make install


#=====================================================================
# Download and extract OpenSSL source code
cd $BUILD_DIR
wget https://www.openssl.org/source/openssl-1.1.1k.tar.gz
tar -xvf openssl-1.1.1k.tar.gz
cd openssl-1.1.1k
./config --prefix=$PREFIX shared LDFLAGS="-Wl,-rpath=$PREFIX/lib"
make -j$(nproc)
make install_sw


#=====================================================================
# Download and build curl
cd $BUILD_DIR
wget https://curl.se/download/curl-8.0.1.tar.gz
tar -xf curl-8.0.1.tar.gz
cd curl-8.0.1
./configure --prefix=$PREFIX --with-ssl=$PREFIX LDFLAGS="-Wl,-rpath=$PREFIX/lib"
make -j$(nproc)
make install


#=====================================================================
# Download and build PROJ
cd $BUILD_DIR
wget https://download.osgeo.org/proj/proj-8.2.1.tar.gz
tar -xf proj-8.2.1.tar.gz
cd proj-8.2.1
mkdir build
cmake -B build/ -DCMAKE_PREFIX_PATH=$PREFIX -DSQLITE3_INCLUDE_DIR=$PREFIX/include -DSQLITE3_LIBRARY=$PREFIX/lib/libsqlite3.so -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=$PREFIX -DCURL_INCLUDE_DIR=$PREFIX/include -DCURL_LIBRARY=$PREFIX/lib/libcurl.so -DTIFF_INCLUDE_DIR=$PREFIX/include -DTIFF_LIBRARY_RELEASE=$PREFIX/lib/libtiff.so
cd build
make -j$(nproc)
make install


#=====================================================================
# Download and build libgeotiff
cd $BUILD_DIR
wget https://github.com/OSGeo/libgeotiff/releases/download/1.7.1/libgeotiff-1.7.1.tar.gz
tar -xf libgeotiff-1.7.1.tar.gz
cd libgeotiff-1.7.1
./configure --prefix=$PREFIX --with-libtiff=$PREFIX --with-proj=$PREFIX LDFLAGS="-Wl,-rpath=$PREFIX/lib"
make -j$(nproc)
make install

#=====================================================================
# Delete temp build directory
rm -rf $BUILD_DIR

