#!/bin/bash

set -x

#sudo apt install -y libxcb1-dev libxcb-xkb-dev libx11-xcb-dev libxcb-cursor-dev libxcb-render0-dev
# https://qtlite.com/

QTPFXDIR=/opt/qtlt512st
QTSRCDIR=qtbase-everywhere-src-5.12.6

mkbuild=1

if [ "$mkbuild" == "1" ]; then

    wget https://download.qt.io/official_releases/qt/5.12/5.12.6/submodules/$QTSRCDIR.tar.xz

    tar xf $QTSRCDIR.tar.xz

    # integeration fcitx input method for static build
    git clone https://github.com/telegramdesktop/fcitx $QTSRCDIR/src/plugins/platforminputcontexts/fcitx
    echo "SUBDIRS += fcitx" >> $QTSRCDIR/src/plugins/platforminputcontexts/platforminputcontexts.pro

    mkdir build
    ls

    cd build

    ../$QTSRCDIR/configure  -prefix $QTPFXDIR \
             -opensource -confirm-license -static -release -v \
             -reduce-relocations -ltcg -optimize-size -make libs \
             -nomake tools -nomake examples -nomake tests \
             -dbus -no-opengl -qpa xcb -qt-zlib -qt-libjpeg -qt-libpng \
             -xcb -qt-xcb -qt-freetype -qt-pcre -qt-harfbuzz \
             -no-feature-fontconfig -no-feature-im -no-feature-libinput -no-feature-libinput-axis-api \
             -no-feature-sql -no-sql-sqlite -no-sql-ibase -no-sql-psql -no-sql-mysql -no-sql-odbc -no-sql-tds \
             -feature-abstractbutton -no-feature-accessibility -no-feature-accessibility-atspi-bridge \
             -feature-action -feature-xrender -no-feature-cxx11_future \
             -feature-c++11 -no-feature-c++14 -no-feature-c++1z -feature-c11 -feature-c99 \
             -no-feature-glib -no-feature-gtk3 -no-feature-icu -no-feature-linuxfb -no-feature-directfb \
             -no-feature-tslib -no-feature-vnc -no-feature-system-doubleconversion \
             -no-feature-cups -no-feature-syslog -no-feature-syntaxhighlighter \
             -no-feature-egl -no-feature-egl_x11 -no-feature-eglfs -no-feature-eglfs_brcm \
             -no-feature-eglfs_egldevice -no-feature-eglfs_gbm -no-feature-eglfs_mali \
             -no-feature-eglfs_openwfd -no-feature-eglfs_rcar -no-feature-eglfs_viv \
             -no-feature-eglfs_viv_wl -no-feature-eglfs_vsp2 -no-feature-eglfs_x11 \
             -no-feature-xcb-egl-plugin -no-feature-xcb-glx -no-feature-xcb-glx-plugin \
             -no-feature-listwidget -no-feature-tablewidget -no-feature-treewidget \
             -no-feature-mdiarea -no-feature-whatsthis  -no-feature-wizard -no-feature-dial \
             -no-feature-textbrowser -no-feature-texthtmlparser -no-feature-textodfwriter \
             -no-feature-texture_format_astc_experimental -no-feature-big_codecs \
             -no-feature-colordialog -no-feature-fontdialog  -no-feature-calendarwidget \
             -no-feature-printdialog  -no-feature-printpreviewdialog -no-feature-printpreviewwidget \
             -no-feature-tuiotouch -no-feature-datawidgetmapper -no-feature-progressdialog \
             -no-feature-vulkan -no-feature-xcb-xlib -no-feature-xcb-sm -no-feature-xlib \
             -no-feature-splashscreen -no-feature-lcdnumber -no-feature-itemmodeltester \
             -no-feature-concurrent -no-feature-xml -no-feature-testlib -no-feature-libudev \
             -no-feature-sessionmanager -no-feature-evdev -no-feature-bearermanagement \
             -no-feature-style-fusion -no-feature-style-windowsvista -no-feature-animation \
             -no-feature-gestures -no-feature-effects -no-feature-graphicseffect -no-feature-graphicsview \
             -no-feature-openssl -no-feature-openssl-linked -no-feature-ftp -no-feature-http \
             -no-feature-networkdiskcache -no-feature-networkinterface -no-feature-networkproxy \
             -no-feature-commandlineparser -no-feature-integrityfb -no-feature-integrityhid \
             -no-feature-multiprocess -no-feature-process -no-feature-processenvironment \
             -no-feature-statemachine -no-feature-kms  -no-feature-network \
             -no-feature-library -no-feature-sharedmemory \
             -no-feature-timezone -no-feature-dirmodel -no-feature-filesystemmodel

# qdbus depends this
# -no-feature-xmlstream -no-feature-xmlstreamreader -no-feature-xmlstreamwriter
# fcitx plugin depends this
    # -no-feature-inotify -no-feature-filesystemwatcher -no-feature-filesystemiterator


    sudo make install_mkspecs
    make -C src/ sub-3rdparty-pcre2-install_subtargets
    make -C src/ sub-3rdparty-freetype-install_subtargets
    make -C src/ sub-3rdparty-harfbuzzng-install_subtargets
    make -C src/platformsupport/services/ install
    make -C src/platformsupport/themes/ install
    make -C src/platformsupport/edid/ install
    make -C src/platformsupport/fontdatabases/ install
    for mod in 'corelib gui widgets plugins'; do
        sudo make -C src/$mod install
    done
    sudo make install

    cd ..
fi

mkdir -p $QTPFXDIR/lib/fonts
ls $QTPFXDIR -lh

cp -a ./qt-lite-512-st.sh $QTPFXDIR/
cp -a ./readme.md $QTPFXDIR/
env |grep -v APIKEY > $QTPFXDIR/env.txt
strip -sv $QTPFXDIR/lib/*.a
CURDIR=$PWD
PFXBNAME=$(basename $QTPFXDIR)
cd /opt/ && tar Jcfp $CURDIR/$PFXBNAME.tar.xz $PFXBNAME && cd -
ls -lh

curl -T "$PFXBNAME.tar.xz" -ukitech:$BINTRAY_APIKEY \
     "https://api.bintray.com/content/kitech/os/qtpkg/v1/$PFXBNAME.tar.xz?publish=1&override=1"
curl -X POST -ukitech:$BINTRAY_APIKEY \
     "https://api.bintray.com/content/kitech/os/qtpkg/v1/publish"

echo "https://dl.bintray.com/kitech/os/$BINTRAY_APIKEY.tar.xz"

