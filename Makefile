.POSIX:
.PHONY: all clean windows appimage

all: windows appimage

balloon.love:
	rm -f balloon.love
	zip -9 -r balloon.love *.lua assets/ COPYING

appimage: balloon.love
	wget https://github.com/love2d/love/releases/download/11.4/love-11.4-x86_64.AppImage
	mkdir love-app-image
	chmod +x love-11.4-x86_64.AppImage
	cd love-app-image; ../love-11.4-x86_64.AppImage --appimage-extract
	cat love-app-image/squashfs-root/bin/love balloon.love > love-app-image/squashfs-root/bin/balloon
	chmod +x love-app-image/squashfs-root/bin/balloon
	cp balloon.desktop love-app-image/squashfs-root
	appimagetool love-app-image/squashfs-root balloon.AppImage
	rm -rf love-app-image love-11.4-x86_64.AppImage

windows: balloon.love
	rm -rf windows
	wget https://github.com/love2d/love/releases/download/11.4/love-11.4-win32.zip
	unzip love-11.4-win32.zip
	rm love-11.4-win32.zip
	cat love-11.4-win32/love.exe balloon.love > love-11.4-win32/balloon.exe
	mv love-11.4-win32 balloon
	chmod +x balloon/balloon.exe
	zip -9 -r balloon-windows.zip balloon
	rm -rf balloon

clean:
	rm -rf *.zip love-* *.love *.AppImage
