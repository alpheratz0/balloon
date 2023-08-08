#!/bin/sh -e
#
# Copyright (C) 2023 alpheratz0 <alpheratz99@protonmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.

LOVE_APPIMAGE_URL="https://github.com/love2d/love/releases/download/11.4/love-11.4-x86_64.AppImage"
LOVE_APPIMAGE_SHA256="e5213d08a07c3d6b06ec6ac297fb316a211ad6624ebae6a0c171e32b5d53ba6f"
LOVE_WIN32_AR_URL="https://github.com/love2d/love/releases/download/11.4/love-11.4-win32.zip"
LOVE_WIN32_AR_SHA256="0d0c42159c6a65bc23a70239171916f0900a2f08f3918e51065e6f1255f5494a"

build_prepare()
{
	echo "Setting everything up..."
	mkdir build && cd build

	echo "    Getting love2d appimage..."
	wget $LOVE_APPIMAGE_URL -qO love.AppImage
	if ! test "$(sha256sum love.AppImage | cut -f1 -d\ )" = $LOVE_APPIMAGE_SHA256; then
		printf "build.sh: love.AppImage file verification failed\n" >/dev/stderr
		exit 1
	fi

	echo "    Getting love2d win32 archive..."
	wget $LOVE_WIN32_AR_URL -qO love-win32.zip
	if ! test "$(sha256sum love-win32.zip | cut -f1 -d\ )" = $LOVE_WIN32_AR_SHA256; then
		printf "build.sh: love-win32.zip file verification failed\n" >/dev/stderr
		exit 1
	fi

	chmod +x love.AppImage
	cd ..
}

build_appimage()
{
	test -d build || build_prepare
	zip -q -9 -r build/balloon.love ./*.lua ./assets/ COPYING
	cd build

	echo "Building for linux (appimage)..."
	mkdir balloon-appimage && cd balloon-appimage
	../love.AppImage --appimage-extract >/dev/null
	cd ..
	cat balloon-appimage/squashfs-root/bin/love balloon.love > balloon-appimage/squashfs-root/bin/balloon
	chmod +x balloon-appimage/squashfs-root/bin/balloon
	cp ../balloon.desktop balloon-appimage/squashfs-root
	appimagetool balloon-appimage/squashfs-root balloon.AppImage >/dev/null 2>&1
	mv balloon.AppImage ../releases
	rm -rf balloon-appimage
	cd ..
}

build_win32()
{
	test -d build || build_prepare
	zip -q -9 -r build/balloon.love ./*.lua ./assets/ COPYING
	cd build
	echo "Building for win32..."
	unzip -q -j -d balloon-win32 love-win32.zip
	cat balloon-win32/love.exe balloon.love > balloon-win32/balloon.exe
	chmod +x balloon-win32/balloon.exe
	zip -q -9 -r balloon-win32.zip balloon-win32
	mv balloon-win32.zip ../releases
	rm -rf balloon-win32
	cd ..
}

main()
{
	if test "$1" = "win32"; then
		build_win32
	elif test "$1" = "appimage"; then
		build_appimage
	elif test "$1" = "all"; then
		build_win32
		build_appimage
	elif test "$1" = "clean"; then
		rm -rf ./build ./releases/*
	else
		printf "usage: ./build.sh [win32|appimage|all|clean]\n" >/dev/stderr
		exit 1
	fi
}

main "$1"
