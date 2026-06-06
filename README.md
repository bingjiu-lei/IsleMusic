# SunnyTune Music

晴听音乐，一个干净、现代、轻量的 Windows 音乐播放器。

## 当前定位

- 第一阶段只做 Windows 桌面端。
- UI 走浅色、晴空蓝绿强调、小圆角、局部轻玻璃质感。
- 功能先围绕搜索、播放、收藏、歌单、最近播放、签到权益。
- 当前代码是产品骨架和假数据界面，暂未接入真实音乐接口。

## 开发命令

```bash
flutter analyze
flutter test
flutter run -d windows
flutter build windows
```

## Windows 构建依赖

Windows 桌面构建需要安装 Visual Studio Build Tools，并勾选 `Desktop development with C++` 工作负载。

需要包含：

- MSVC v143 C++ x64/x86 build tools
- C++ CMake tools for Windows
- Windows 10/11 SDK
