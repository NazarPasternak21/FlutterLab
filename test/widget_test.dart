import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_project/screens/login_screen.dart'; 

void main() {
  testWidgets('LoginScreen shows form and validates input', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
        routes: {
          '/home': (context) => Scaffold(body: Text('Home Screen')), 
        },
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(2)); 
    expect(find.byType(ElevatedButton), findsOneWidget); 

    expect(find.text('Введіть email'), findsNothing);
    expect(find.text('Введіть пароль'), findsNothing);

    await tester.enterText(find.byType(TextFormField).first, ''); 
    await tester.enterText(find.byType(TextFormField).last, 'password123'); 

    await tester.tap(find.byType(ElevatedButton)); 
    await tester.pump();

    expect(find.text('Введіть email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); 

    expect(find.text('Home Screen'), findsOneWidget); 
  });
}
