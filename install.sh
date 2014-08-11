#!/bin/sh

#  linphone-install.sh
#  Created by Tomas Michalek on 8/9/14.
#  Based upon README.macos from linphone documentation with fixes such as +no_pyton and such
#  for bunle creation follow README.macos from ./app directory.


# Install build time dependencies
sudo port install automake autoconf libtool intltool wget cunit cmake

# Install some linphone dependencies with macports
sudo port install antlr3 speex libvpx readline sqlite3 libsoup openldap
#sudo port install ffmpeg-devel -gpl2 +x264

# Install gtk. It is recommended to use the quartz backend for better integration.
sudo port install gtk2 +quartz +no_x11
sudo port install gtk-osx-application +no_python #-python27
sudo port install hicolor-icon-theme

mkdir linphone-devel
cd linphone-devel

PATHER=$(pwd)
INSTALL_PATH=$PATHER
echo "Installing linphone in workdirectory" $INSTALL_PATH


# Install libantlr3c (library used by belle-sip for parsing)
  git clone -b linphone git://git.linphone.org/antlr3.git
  cd antlr3/runtime/C
  ./autogen.sh && ./configure --disable-static --prefix=/opt/local && make
  sudo make install

  cd $INSTALL_PATH

# Install polarssl (encryption library used by belle-sip)
  git clone git://git.linphone.org/polarssl.git -b linphone
  cd polarssl && ./autogen.sh && ./configure --prefix=/opt/local && make
  sudo make install

  cd $INSTALL_PATH

# Install belle-sip (sip stack)
  git clone git://git.linphone.org/belle-sip.git
  cd belle-sip && ./autogen.sh && ./configure --prefix=/opt/local && make
  sudo make install

  cd $INSTALL_PATH

# Install srtp (optional) for call encryption
  git clone git://git.linphone.org/srtp.git
  cd srtp && autoconf && ./configure --prefix=/opt/local && make libsrtp.a
  sudo make install

  cd $INSTALL_PATH

# Install zrtpcpp (optional), for unbreakable call encryption
#   git clone https://github.com/wernerd/ZRTPCPP.git
#   cd ZRTPCPP
#   cmake -DCORE_LIB=true -DSDES=false CMAKE_INSTALL_NAME_DIR=/usr/local/lib/ -DCMAKE_C_FLAGS="-arch i386 -arch x86_64 -mmacosx-version-min=10.5" -DCMAKE_CXX_FLAGS="-arch i386 -arch x86_64 --stdlib=libstdc++ -std=c++11 -lstdc++ -mmacosx-version-min=10.5"  -DCMAKE_C_COMPILER=`xcrun --find clang` -DCMAKE_CXX_COMPILER=`xcrun --find clang` .
#   sudo make install
#   cd $INSTALL_PATH

# GTK Quartz Engine installation
  git clone https://github.com/jralls/gtk-quartz-engine.git
  cd gtk-quartz-engine
  autoreconf -i && ./configure --prefix=/opt/local CFLAGS="$CFLAGS -Wno-error" && make
  sudo make install

  cd $INSTALL_PATH

# Install Linphone from Git | --enable-zrtp
  git clone git://git.linphone.org/linphone.git --recursive app
  cd app
  ./autogen.sh
  PKG_CONFIG_PATH=/usr/local/lib/pkgconfig ./configure --prefix=/opt/local --with-readline=/opt/local --disable-x11 --with-srtp=/opt/local  --disable-strict --enable-relativeprefix && make
  sudo make install

# Install mediaStreamer x264
  git clone git://git.linphone.org/msx264.git --recursive
  cd msx264
  ./autogen.sh
  ./configure && make
  sudo make install 

echo 'Installation completed'
