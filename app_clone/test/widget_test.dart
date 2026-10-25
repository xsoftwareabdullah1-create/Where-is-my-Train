import 'package:app_clone/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RailPulse branded splash screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('RailPulse'), findsOneWidget);
    expect(find.text('INDIAN RAILWAYS • TRAIN TRACKER'), findsOneWidget);
  });
}
