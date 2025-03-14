import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myproject/main.dart'; 

void main() {
  testWidgets('Password Generator App test', (WidgetTester tester) async {
    await tester.pumpWidget(const PasswordGeneratorApp());

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();  

    expect(find.text('Оберіть хоча б одну опцію!'), findsNothing);
    expect(find.byType(SelectableText), findsOneWidget); 

    await tester.tap(find.byIcon(Icons.copy));
    await tester.pump(); 

    expect(find.text('Пароль скопійовано!'), findsOneWidget);
  });
}
