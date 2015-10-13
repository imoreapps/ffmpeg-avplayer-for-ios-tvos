A tiny but powerful video player framework for iOS. The SDK can play the most audio and video formats (Includes network audio and video streams), no convert hassles, no VLC and SDL dependent.

AVPlayer SDK is written for iOS developers who want to add powerful video player to their app using a couple lines of code. Behind the scenes Video Player relies on the iOS OpenGL ES 2.0 framework and the open source LGPL licensed FFmpeg library.

Note: If you need more customized protocols (such as Samba etc), please feel free to contact us for more details.

[![](https://dl.dropboxusercontent.com/u/87201024/avplayer/1.png)](https://dl.dropboxusercontent.com/u/87201024/avplayer/1.png)
[![](https://dl.dropboxusercontent.com/u/87201024/avplayer/2.png)](https://dl.dropboxusercontent.com/u/87201024/avplayer/2.png)
[![](https://dl.dropboxusercontent.com/u/87201024/avplayer/3.png)](https://dl.dropboxusercontent.com/u/87201024/avplayer/3.png)
[![](https://dl.dropboxusercontent.com/u/87201024/avplayer/6.png)](https://dl.dropboxusercontent.com/u/87201024/avplayer/6.png)
[![](https://dl.dropboxusercontent.com/u/87201024/avplayer/4.png)](https://dl.dropboxusercontent.com/u/87201024/avplayer/4.png)
[![](https://dl.dropboxusercontent.com/u/87201024/avplayer/5.png)](https://dl.dropboxusercontent.com/u/87201024/avplayer/5.png)

###Note

Now AVPlayer framework is able to play high resolution videos by using hardware accelerator feature embedded in iPhone/iPad even for MKV or AVI in H264, but this feature requires iOS 8 or later.

###Compile Requirements

 - ARC
 - XCode 7.1 & iOS SDK 9.0

###Deploy Requirements

 - ARMv7, ARMv7s, ARM64 and x86-64 architectures
 - Deploy target iOS 9.0

###Features

 - ARC support.
 - Bitcode support.
 - armv7, armv7s, arm64 and x86-64 support.
 - file, ftp, samba, http, https, rtsp and rtmp protocols support.
 - Hardware decoder support for H264 format. (iOS 8 or later)
 - Rich options of ffmpeg library support.
 - Disable audio or video stream.
 - Parse audio and video duration, frame size infos.
 - Grab video thumbnails.
 - Real-time bit & frame rate and network buffering progress calculation.
 - Query current playback time info.
 - Playback speed control.
 - Brightness, contrast and saturation control.
 - Background audio, video playback support.
 - Full screen mode support.
 - System volume control.
 - Play from a specified time position.
 - Play, pause, resume, stop, fast forward, fast backward, seek position actions support.
 - Audio session interruption handler support
 - Delegate support, you can get notification when state, playback progress, buffering progress changed and enter/exit full screen mode.
 - Save, Restore playback progress support (Objective-c block style).
 - Multiple audio, subtitle streams support.
 - SRT, ASS, SSA, SMI external subtitle formats support.
 - Embedded subtitle formats support.
 - Custom subtitle font.

###Dolby License

DO NOT use dolby tech in your iOS app unless you have a dolby license.
Dolby Digital(AC3), Dolby Digital Plus(E-AC3) and Dolby TrueHD(MLP).

###Contact us

 - Twitter: @imoreapps
 - Sina Weibo: @imoreapps
 - Email: imoreapps@gmail.com
