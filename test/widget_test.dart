import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_project/widgets/app_state.dart';
import 'package:my_project/screens/profile_screen.dart';
import 'package:my_project/screens/login_screen.dart';
import 'package:my_project/widgets/custom_button.dart';

void main() {
  testWidgets('Test ProfileScreen and Logout Button', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const MaterialApp( 
          home: ProfileScreen(),
          routes: {
            '/': (context) => LoginScreen(),
          },
        ),
      ),
    );

    expect(find.text('Профіль користувача'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    expect(find.byType(CustomButton), findsNWidgets(2)); 

    await tester.tap(find.text('Вийти'));
    await tester.pumpAndSettle();

    expect(find.text('Вхід'), findsOneWidget);
  });
}
