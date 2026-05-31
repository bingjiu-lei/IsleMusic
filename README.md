# Isle Music

青屿音乐，一个干净、现代、轻量的 Windows 音乐播放器。

## 当前定位

- 第一阶段只做 Windows 桌面端。
- UI 走浅色、蓝绿色强调、小圆角、局部轻玻璃质感。
- 功能先围绕搜索、播放、收藏、歌单、最近播放、签到权益。
- 当前代码是产品骨架和假数据界面，暂未接入真实音乐接口。

## 开发命令

```bash
flutter analyze
flutter test
flutter run -d windows
flutter build windows
```

## 本机 Windows 构建依赖

Windows 桌面构建需要安装 Visual Studio，并勾选 `Desktop development with C++` 工作负载。

当前机器的 Flutter 环境可以通过 `flutter analyze` 和 `flutter test`，但 `flutter build windows` 会因为缺少 Visual Studio C++ 工具链失败。
