import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Codis/app.dart';

void main() {
  testWidgets('Cipher app loads', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: App(),
      ),
    );
    expect(find.text('کدیس'), findsOneWidget);
  });
}
