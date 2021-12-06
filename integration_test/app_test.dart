import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("test homescreen", (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    final findHomeScreen = find.byKey(const Key("HomeScreen"));

    
  });
}
