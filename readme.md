
qt lite 编译最精简的 gui 库

占内存要小
占磁盘空间要小
只包含 core gui widgets 三个包
不包含GL相关插件与链接依赖
不包含glib/gtk相关插件与链接依赖
支持中文输入法

基于 qtbase-everywhere包构建

### 结果

linux 64
hello world button:
12M 程序文件，未strip
启动程序占用12M内存，放大窗口后占用在25M左右。

libQt5Core.a: 9.6M
libQt5Gui.a: 9.8M
libQt5Widgets.a: 9.1M
libQt5Dbus.a: 1.8M

去掉系统库和C/C++标准库，只有6个库链接依赖
libxcb.so libxkbcommon.so libXau.so libXdump.so libxcb-xkb.so libfreetype.so

### 注意
没有编译libfontconfig，不能自动搜索字体。而开启libfontconfig则，启动搜索字体变慢3-5秒，内存涨10M
字体问题，需要链接一个.ttc/.ttf到 prefix/lib/fonts/目录下

(已测试) https://github.com/telegramdesktop/fcitx
放在qt 5.12源码树的 plugins/platforminputcontext/目录，在platforminputcontext.pro中添加与ibus一样的SUBDIR项，重新编译即可。

(x这个是动态链接版本) 输入法问题，使用该静态qt库编译fcitx-qt5的libfcitxplatforminputcontext为静态库，然后链接到最终程序中
编译https://github.com/telegramdesktop/fcitx 需要qt dbus模块，所以上面编译的库包含这个模块。

(未测试)输入法整合到qt，https://git.mel.vin/telegram_desktop/upstream/commit/efa62ece723d36f6b28ecb0f1bf1ba84b57900f0?view=parallel


