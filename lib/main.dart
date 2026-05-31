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
      title: 'Isle Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Microsoft YaHei',
        scaffoldBackgroundColor: IsleColors.page,
        colorScheme: ColorScheme.fromSeed(
          seedColor: IsleColors.primary,
          brightness: Brightness.light,
        ),
      ),
      home: const IsleMusicShell(),
    );
  }
}

class IsleColors {
  static const page = Color(0xFFF5F8F8);
  static const surface = Color(0xFFFFFFFF);
  static const glass = Color(0xCCFFFFFF);
  static const primary = Color(0xFF18B6A7);
  static const primaryDark = Color(0xFF0E8F84);
  static const text = Color(0xFF162222);
  static const muted = Color(0xFF728080);
  static const border = Color(0xFFE3ECEB);
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
    title: '海风来信',
    artist: 'Isle Band',
    album: '青屿日记',
    duration: '03:42',
    color: Color(0xFF8FD6CC),
    liked: true,
  ),
  DemoSong(
    title: '薄荷午后',
    artist: 'Mellow Room',
    album: 'Clear Day',
    duration: '04:16',
    color: Color(0xFFC5E6D7),
  ),
  DemoSong(
    title: '岛屿电台',
    artist: 'North Tide',
    album: 'Wave Signal',
    duration: '03:28',
    color: Color(0xFF9EC7DF),
  ),
  DemoSong(
    title: '晴色漫游',
    artist: 'Blue Hour',
    album: 'Light Walk',
    duration: '03:55',
    color: Color(0xFFE8D9A6),
  ),
  DemoSong(
    title: '远处的灯',
    artist: 'Soft Echo',
    album: 'Night Window',
    duration: '04:02',
    color: Color(0xFFD8C4E8),
    liked: true,
  ),
];

class IsleMusicShell extends StatefulWidget {
  const IsleMusicShell({super.key});

  @override
  State<IsleMusicShell> createState() => _IsleMusicShellState();
}

class _IsleMusicShellState extends State<IsleMusicShell> {
  int selectedIndex = 0;
  int currentSongIndex = 0;
  bool isPlaying = true;

  DemoSong get currentSong => demoSongs[currentSongIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
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
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7FBFA), Color(0xFFEFF7F5), Color(0xFFF8FAFA)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -120,
            right: -80,
            child: _SoftGlow(color: IsleColors.primary.withValues(alpha: 0.18)),
          ),
          Positioned(
            bottom: -160,
            left: 240,
            child: _SoftGlow(
              color: const Color(0xFF9EC7DF).withValues(alpha: 0.16),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftGlow extends StatelessWidget {
  const _SoftGlow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 360,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 80)],
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
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: IsleColors.glass,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: IsleColors.border),
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
      width: 184,
      child: _GlassPanel(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: IsleColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.waves_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '青屿音乐',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: IsleColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Isle Music',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: IsleColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            for (var i = 0; i < items.length; i++)
              _NavItem(
                icon: items[i].$1,
                label: items[i].$2,
                selected: i == selectedIndex,
                onTap: () => onChanged(i),
              ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: IsleColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: IsleColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: IsleColors.primaryDark,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '今日权益待领取',
                      style: TextStyle(
                        color: IsleColors.primaryDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
        color: selected
            ? IsleColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
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
                  color: selected ? IsleColors.primaryDark : IsleColors.muted,
                  size: 21,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? IsleColors.primaryDark : IsleColors.text,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
              color: IsleColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: IsleColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.search_rounded, color: IsleColors.muted, size: 22),
                SizedBox(width: 10),
                Text(
                  '搜索歌曲、歌手、歌单',
                  style: TextStyle(color: IsleColors.muted, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _TopAction(
          icon: Icons.card_giftcard_rounded,
          label: '签到',
          highlighted: true,
        ),
        const SizedBox(width: 12),
        _TopAction(icon: Icons.person_rounded, label: '未登录'),
      ],
    );
  }
}

class _TopAction extends StatelessWidget {
  const _TopAction({
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: highlighted ? IsleColors.primary : IsleColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted ? IsleColors.primary : IsleColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: highlighted ? Colors.white : IsleColors.muted,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: highlighted ? Colors.white : IsleColors.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.onPlay});

  final ValueChanged<int> onPlay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(flex: 2, child: _HeroListenCard(onPlay: () => onPlay(0))),
            const SizedBox(width: 16),
            const Expanded(child: _CheckinCard()),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Row(
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
                        const Divider(height: 1, color: IsleColors.border),
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

class _HeroListenCard extends StatelessWidget {
  const _HeroListenCard({required this.onPlay});

  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: IsleColors.primary,
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF18B6A7), Color(0xFF5ECBC2)],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '继续听',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '海风来信',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Isle Band · 青屿日记',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.78),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: onPlay,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: IsleColors.primaryDark,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('播放'),
          ),
        ],
      ),
    );
  }
}

class _CheckinCard extends StatelessWidget {
  const _CheckinCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: IsleColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IsleColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.verified_rounded, color: IsleColors.primaryDark),
              SizedBox(width: 8),
              Text(
                '每日权益',
                style: TextStyle(
                  color: IsleColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '登录后可领取今日畅听权益。',
            style: TextStyle(color: IsleColors.muted),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: IsleColors.primaryDark,
                side: const BorderSide(color: IsleColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('去登录'),
            ),
          ),
        ],
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
        color: IsleColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: IsleColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: IsleColors.text,
                  fontSize: 18,
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
      height: 64,
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: Text(
              '${index + 1}'.padLeft(2, '0'),
              style: const TextStyle(color: IsleColors.muted),
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
                    color: IsleColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  song.artist,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: IsleColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              song.album,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: IsleColors.muted),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              song.duration,
              style: const TextStyle(color: IsleColors.muted),
            ),
          ),
          IconButton(
            tooltip: song.liked ? '取消收藏' : '收藏',
            onPressed: () {},
            icon: Icon(
              song.liked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: song.liked ? IsleColors.primary : IsleColors.muted,
            ),
          ),
          IconButton(
            tooltip: '播放',
            onPressed: onPlay,
            icon: const Icon(
              Icons.play_circle_fill_rounded,
              color: IsleColors.primary,
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
          color: Color(0xFFC5E6D7),
        ),
        SizedBox(height: 12),
        _PlaylistCard(
          title: '夜晚放松',
          subtitle: '16 首歌曲',
          color: Color(0xFF9EC7DF),
        ),
        SizedBox(height: 12),
        _PlaylistCard(
          title: '通勤路上',
          subtitle: '34 首歌曲',
          color: Color(0xFFD8C4E8),
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
        color: IsleColors.page,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: IsleColors.border),
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
                    color: IsleColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: IsleColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: IsleColors.muted),
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
              width: 168,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: IsleColors.text,
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
                      color: IsleColors.muted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '上一首',
              onPressed: onPrevious,
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            FilledButton(
              onPressed: onTogglePlay,
              style: FilledButton.styleFrom(
                backgroundColor: IsleColors.primary,
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
              icon: const Icon(Icons.skip_next_rounded),
            ),
            const SizedBox(width: 20),
            const Text('01:18', style: TextStyle(color: IsleColors.muted)),
            const SizedBox(width: 10),
            const Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(999)),
                child: LinearProgressIndicator(
                  value: 0.38,
                  minHeight: 5,
                  color: IsleColors.primary,
                  backgroundColor: Color(0xFFE3ECEB),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              song.duration,
              style: const TextStyle(color: IsleColors.muted),
            ),
            const SizedBox(width: 18),
            IconButton(
              tooltip: '音量',
              onPressed: () {},
              icon: const Icon(Icons.volume_up_rounded),
            ),
            IconButton(
              tooltip: '播放队列',
              onPressed: () {},
              icon: const Icon(Icons.queue_music_rounded),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.75), color],
        ),
      ),
      child: Icon(
        Icons.music_note_rounded,
        color: Colors.white.withValues(alpha: 0.9),
        size: size * 0.46,
      ),
    );
  }
}
