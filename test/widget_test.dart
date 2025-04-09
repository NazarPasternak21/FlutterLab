import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/screens/register_screen.dart';
import 'package:my_project/services/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  group('LoginScreen Tests', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    testWidgets('повинно перейти на RegisterScreen, коли натискається "Зареєструйся"', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => appState,
            child: LoginScreen(),
          ),
        ),
      );

      await tester.tap(find.text('Ще не маєш акаунта? Зареєструйся'));
      await tester.pumpAndSettle();

      expect(find.byType(RegisterScreen), findsOneWidget);
    });
  });
}
