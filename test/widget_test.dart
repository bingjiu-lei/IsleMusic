import 'package:flutter_test/flutter_test.dart';
import 'package:isle_music/main.dart';

void main() {
  testWidgets('renders Isle Music desktop shell', (tester) async {
    await tester.pumpWidget(const IsleMusicApp());

    expect(find.text('青屿音乐'), findsOneWidget);
    expect(find.text('Isle Music'), findsOneWidget);
    expect(find.text('首页'), findsOneWidget);
    expect(find.text('搜索歌曲、歌手、歌单'), findsOneWidget);
    expect(find.text('最近播放'), findsOneWidget);
  });
}
