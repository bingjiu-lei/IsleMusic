import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const IsleMusicApp());
}

class IsleMusicApp extends StatelessWidget {
  const IsleMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SunnyTune Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
        scaffoldBackgroundColor: SunTuneColors.page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: SunTuneColors.primary,
          brightness: Brightness.light,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: SunTuneColors.primaryStrong,
            textStyle: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
      home: const SunTuneShell(),
    );
  }
}

class SunTuneColors {
  static const page = Color(0xFFF4F8F9);
  static const pageSoft = Color(0xFFEAF4F6);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFF8FBFB);
  static const glass = Color(0xEAFBFEFE);
  static const primary = Color(0xFF4AAFB8);
  static const primaryStrong = Color(0xFF247F8B);
  static const primarySoft = Color(0xFFE4F4F6);
  static const sky = Color(0xFF9ECFE0);
  static const sun = Color(0xFFF4C96A);
  static const text = Color(0xFF172426);
  static const muted = Color(0xFF6D7D80);
  static const faint = Color(0xFF9AA9AB);
  static const border = Color(0xFFDDE9EA);
}

class DemoSong {
  const DemoSong({
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.color,
    this.liked = false,
  });

  final String title;
  final String artist;
  final String album;
  final String duration;
  final Color color;
  final bool liked;
}

const demoSongs = [
  DemoSong(
    title: '晴窗来信',
    artist: 'North Tide',
    album: '晴听日记',
    duration: '03:42',
    color: Color(0xFFA7D8D6),
    liked: true,
  ),
  DemoSong(
    title: '薄荷午后',
    artist: 'Mellow Room',
    album: 'Clear Day',
    duration: '04:16',
    color: Color(0xFFBFDCCF),
  ),
  DemoSong(
    title: '岛屿电台',
    artist: 'Blue Hour',
    album: 'Wave Signal',
    duration: '03:28',
    color: Color(0xFFAACDE1),
  ),
  DemoSong(
    title: '晴色漫游',
    artist: 'Soft Echo',
    album: 'Light Walk',
    duration: '03:55',
    color: Color(0xFFEAD492),
  ),
  DemoSong(
    title: '远处的灯',
    artist: 'Night Window',
    album: 'Quiet Road',
    duration: '04:02',
    color: Color(0xFFCABFE2),
    liked: true,
  ),
];

class SunTuneShell extends StatefulWidget {
  const SunTuneShell({super.key});

  @override
  State<SunTuneShell> createState() => _SunTuneShellState();
}

class _SunTuneShellState extends State<SunTuneShell> {
  int selectedIndex = 0;
  int currentSongIndex = 0;
  bool isPlaying = true;

  DemoSong get currentSong => demoSongs[currentSongIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              SunTuneColors.page,
              SunTuneColors.pageSoft,
              Color(0xFFFAFCFC),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _Sidebar(
                        selectedIndex: selectedIndex,
                        onChanged: (index) {
                          setState(() => selectedIndex = index);
                        },
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          children: [
                            const _TopBar(),
                            const SizedBox(height: 18),
                            Expanded(
                              child: _HomeContent(
                                onPlay: (index) {
                                  setState(() {
                                    currentSongIndex = index;
                                    isPlaying = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _PlayerBar(
                  song: currentSong,
                  isPlaying: isPlaying,
                  onTogglePlay: () {
                    setState(() => isPlaying = !isPlaying);
                  },
                  onPrevious: () {
                    setState(() {
                      currentSongIndex =
                          (currentSongIndex - 1 + demoSongs.length) %
                          demoSongs.length;
                    });
                  },
                  onNext: () {
                    setState(() {
                      currentSongIndex =
                          (currentSongIndex + 1) % demoSongs.length;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    const borderRadius = 12.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: SunTuneColors.glass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: SunTuneColors.border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.onChanged});

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  static const items = [
    (Icons.home_rounded, '首页'),
    (Icons.search_rounded, '搜索'),
    (Icons.library_music_rounded, '我的音乐'),
    (Icons.settings_rounded, '设置'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: _GlassPanel(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: SunTuneColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '晴听音乐',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SunTuneColors.text,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        'SunnyTune Music',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SunTuneColors.muted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            for (var i = 0; i < items.length; i++)
              _NavItem(
                icon: items[i].$1,
                label: items[i].$2,
                selected: i == selectedIndex,
                onTap: () => onChanged(i),
              ),
            const Spacer(),
            const _EntitlementHint(),
          ],
        ),
      ),
    );
  }
}

class _EntitlementHint extends StatelessWidget {
  const _EntitlementHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SunTuneColors.primarySoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFC9E7EA)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.radio_button_unchecked_rounded,
            color: SunTuneColors.primaryStrong,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              '登录后领取今日权益',
              style: TextStyle(
                color: SunTuneColors.primaryStrong,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? SunTuneColors.primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected
                      ? SunTuneColors.primaryStrong
                      : SunTuneColors.muted,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? SunTuneColors.primaryStrong
                        : SunTuneColors.text,
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: SunTuneColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: SunTuneColors.border),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: SunTuneColors.muted,
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  '搜索歌曲、歌手、歌单',
                  style: TextStyle(color: SunTuneColors.muted, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        const _StatusPill(),
        const SizedBox(width: 12),
        _PrimaryLoginButton(onPressed: () {}),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: SunTuneColors.primarySoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC9E7EA)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            color: SunTuneColors.primaryStrong,
            size: 19,
          ),
          SizedBox(width: 8),
          Text(
            '权益待领取',
            style: TextStyle(
              color: SunTuneColors.primaryStrong,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryLoginButton extends StatelessWidget {
  const _PrimaryLoginButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: SunTuneColors.primaryStrong,
        foregroundColor: Colors.white,
        minimumSize: const Size(106, 48),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.person_rounded, size: 20),
      label: const Text('登录', style: TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.onPlay});

  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: _SectionPanel(
            title: '最近播放',
            actionText: '查看全部',
            child: ListView.separated(
              itemCount: demoSongs.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: SunTuneColors.border),
              itemBuilder: (context, index) {
                final song = demoSongs[index];
                return _SongRow(
                  song: song,
                  index: index,
                  onPlay: () => onPlay(index),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        const Expanded(
          flex: 2,
          child: Column(
            children: [
              _CheckinCard(),
              SizedBox(height: 16),
              Expanded(
                child: _SectionPanel(
                  title: '我的歌单',
                  actionText: '新建',
                  child: _PlaylistPreview(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CheckinCard extends StatelessWidget {
  const _CheckinCard();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Container(
          height: 150,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: SunTuneColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: SunTuneColors.border),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CheckinTitleRow(),
                    const SizedBox(height: 9),
                    const Text(
                      '登录后可领取今日权益。',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: SunTuneColors.muted,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('去登录'),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    const _CheckinIcon(),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '每日权益',
                            style: TextStyle(
                              color: SunTuneColors.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            '登录后可领取今日畅听权益。',
                            style: TextStyle(
                              color: SunTuneColors.muted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('去登录')),
                  ],
                ),
        );
      },
    );
  }
}

class _CheckinTitleRow extends StatelessWidget {
  const _CheckinTitleRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _CheckinIcon(size: 34, iconSize: 20),
        SizedBox(width: 10),
        Text(
          '每日权益',
          style: TextStyle(
            color: SunTuneColors.text,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CheckinIcon extends StatelessWidget {
  const _CheckinIcon({this.size = 50, this.iconSize = 26});

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: SunTuneColors.primarySoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.verified_rounded,
        color: SunTuneColors.primaryStrong,
        size: iconSize,
      ),
    );
  }
}

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.title,
    required this.actionText,
    required this.child,
  });

  final String title;
  final String actionText;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SunTuneColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SunTuneColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: SunTuneColors.text,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: Text(actionText)),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SongRow extends StatelessWidget {
  const _SongRow({
    required this.song,
    required this.index,
    required this.onPlay,
  });

  final DemoSong song;
  final int index;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 66,
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '${index + 1}'.padLeft(2, '0'),
              style: const TextStyle(color: SunTuneColors.faint),
            ),
          ),
          _CoverBox(color: song.color, size: 42),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SunTuneColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SunTuneColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              song.album,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: SunTuneColors.muted),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              song.duration,
              style: const TextStyle(color: SunTuneColors.muted),
            ),
          ),
          IconButton(
            tooltip: song.liked ? '取消收藏' : '收藏',
            onPressed: () {},
            icon: Icon(
              song.liked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: song.liked
                  ? SunTuneColors.primaryStrong
                  : SunTuneColors.muted,
            ),
          ),
          IconButton(
            tooltip: '播放',
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_arrow_rounded,
              color: SunTuneColors.primaryStrong,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaylistPreview extends StatelessWidget {
  const _PlaylistPreview();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        _PlaylistCard(
          title: '常听收藏',
          subtitle: '28 首歌曲',
          color: Color(0xFFBFDCCF),
        ),
        SizedBox(height: 12),
        _PlaylistCard(
          title: '夜晚放松',
          subtitle: '16 首歌曲',
          color: Color(0xFFAACDE1),
        ),
        SizedBox(height: 12),
        _PlaylistCard(
          title: '通勤路上',
          subtitle: '34 首歌曲',
          color: Color(0xFFCABFE2),
        ),
      ],
    );
  }
}

class _PlaylistCard extends StatelessWidget {
  const _PlaylistCard({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: SunTuneColors.surfaceSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: SunTuneColors.border),
      ),
      child: Row(
        children: [
          _CoverBox(color: color, size: 50),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: SunTuneColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: SunTuneColors.muted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: SunTuneColors.muted),
        ],
      ),
    );
  }
}

class _PlayerBar extends StatelessWidget {
  const _PlayerBar({
    required this.song,
    required this.isPlaying,
    required this.onTogglePlay,
    required this.onPrevious,
    required this.onNext,
  });

  final DemoSong song;
  final bool isPlaying;
  final VoidCallback onTogglePlay;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 86,
      child: _GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Row(
          children: [
            _CoverBox(color: song.color, size: 56),
            const SizedBox(width: 12),
            SizedBox(
              width: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: SunTuneColors.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song.artist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: SunTuneColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '上一首',
              onPressed: onPrevious,
              icon: const Icon(
                Icons.skip_previous_rounded,
                color: SunTuneColors.muted,
              ),
            ),
            FilledButton(
              onPressed: onTogglePlay,
              style: FilledButton.styleFrom(
                backgroundColor: SunTuneColors.primaryStrong,
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(14),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 28,
              ),
            ),
            IconButton(
              tooltip: '下一首',
              onPressed: onNext,
              icon: const Icon(
                Icons.skip_next_rounded,
                color: SunTuneColors.muted,
              ),
            ),
            const SizedBox(width: 20),
            const Text('01:18', style: TextStyle(color: SunTuneColors.muted)),
            const SizedBox(width: 10),
            const Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(999)),
                child: LinearProgressIndicator(
                  value: 0.38,
                  minHeight: 5,
                  color: SunTuneColors.primaryStrong,
                  backgroundColor: Color(0xFFDCE8EA),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              song.duration,
              style: const TextStyle(color: SunTuneColors.muted),
            ),
            const SizedBox(width: 18),
            IconButton(
              tooltip: '音量',
              onPressed: () {},
              icon: const Icon(
                Icons.volume_up_rounded,
                color: SunTuneColors.muted,
              ),
            ),
            IconButton(
              tooltip: '播放队列',
              onPressed: () {},
              icon: const Icon(
                Icons.queue_music_rounded,
                color: SunTuneColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverBox extends StatelessWidget {
  const _CoverBox({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: Colors.white.withValues(alpha: 0.92),
        size: size * 0.46,
      ),
    );
  }
}
