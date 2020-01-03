#!/bin/sh

set -x

wget https://download.qt.io/official_releases/qt/5.12/5.12.6/submodules/qtbase-everywhere-src-5.12.6.tar.xz

tar xf qtbase-everywhere-src-5.12.6.tar.xz

mkdir build
ls

cd build && ../qtbase-everywhere-src-5.12.6/configure -opensource -confirm-license -prefix /opt/qtlt512st -static -release -v -reduce-relocations -optimize-size -make libs -nomake tools -nomake examples -no-dbus -no-opengl -qpa xcb -qt-zlib -qt-libjpeg -qt-libpng -xcb -qt-xcb -qt-freetype -qt-pcre -qt-harfbuzz -no-sql-ibase -no-sql-psql -no-sql-mysql -no-sql-odbc -no-sql-tds

