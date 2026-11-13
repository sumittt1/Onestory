import 'package:flutter_test/flutter_test.dart';
import 'package:onestory/main.dart';

void main() {
  testWidgets('OneStory app loads splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OneStoryApp());
    await tester.pump();

    expect(find.text('OneStory'), findsOneWidget);
  });
}
