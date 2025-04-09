import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:untitled/screens/login_screen.dart';
import 'package:untitled/screens/register_screen.dart';
import 'package:untitled/services/local_auth_repository.dart';
import 'package:untitled/services/app_state.dart';
import 'package:provider/provider.dart';

class MockAuthRepo extends Mock implements LocalAuthRepository {}

void main() {
  group('LoginScreen Tests', () {
    late MockAuthRepo mockAuthRepo;
    late AppState appState;

    setUp(() {
      mockAuthRepo = MockAuthRepo();
      appState = AppState();
    });

    testWidgets('should navigate to RegisterScreen when "Зареєструйся" is pressed', (WidgetTester tester) async {
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
