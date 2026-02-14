import 'package:flutter_test/flutter_test.dart';

import 'package:codis/app.dart';

void main() {
  testWidgets('Cipher app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('کدیس'), findsOneWidget);
  });
}
