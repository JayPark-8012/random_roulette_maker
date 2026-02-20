import 'package:flutter_test/flutter_test.dart';
import 'package:random_roulette_maker/app.dart';

void main() {
  testWidgets('App smoke test - renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    // Splash 화면이 로드되는지 확인
    expect(find.text('랜덤 룰렛 메이커'), findsOneWidget);
  });
}
