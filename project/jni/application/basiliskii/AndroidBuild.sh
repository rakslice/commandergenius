#!/bin/sh


LOCAL_PATH=`dirname $0`
LOCAL_PATH=`cd $LOCAL_PATH && pwd`

ln -sf libsdl-1.2.so $LOCAL_PATH/../../../obj/local/$1/libSDL.so
ln -sf libsdl-1.2.so $LOCAL_PATH/../../../obj/local/$1/libpthread.so
ln -sf libsdl_image.so $LOCAL_PATH/../../../obj/local/$1/libSDL_image.so
ln -sf libsdl_ttf.so $LOCAL_PATH/../../../obj/local/$1/libSDL_ttf.so

# extra stuff to stuff in libs
LIBS_FOR_GUICHAN="-L$LOCAL_PATH/../../../obj/local/$1 -lguichan"

JOBS=4

if [ \! -f basiliskii/src/Unix/configure ] ; then
	sh -c "cd basiliskii/src/Unix && NO_CONFIGURE=1 ./autogen.sh"
fi

if [ \! -f basiliskii/src/Unix/Makefile ] ; then
	env CFLAGS="-Ofast -DANDROID=1" \
	env CXXFLAGS=" -std=c++11 -DANDROID=1" \
	env LIBS="-lc -lm $LIBS_FOR_GUICHAN" \
	../setEnvironment-$1.sh sh -c "set; cd basiliskii/src/Unix && env no_dev_ptmx=1 ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no ac_cv_sys_file_offset_bits=no \
		./configure --build=x86_64-unknown-linux-gnu --host=$2 --enable-sdl-video --enable-sdl-audio --without-gtk --without-esd --without-x" || exit 1
fi

make -C basiliskii/src/Unix -j$JOBS && mv -f basiliskii/src/Unix/BasiliskII libapplication-$1.so

