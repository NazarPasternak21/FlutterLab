import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:my_project/widgets/app_state.dart';
import 'package:my_project/screens/profile_screen.dart';

void main() {
  testWidgets('ProfileScreen displays preferred temperature and reminder time', (WidgetTester tester) async {
    final appState = AppState();
    appState.setPreferredTemp(60.0);
    appState.setReminderTime(TimeOfDay(hour: 10, minute: 30));

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AppState>(
          create: (_) => appState,
          child: const ProfileScreen(), 
        ),
      ),
    );

    expect(find.text('Бажана температура напою'), findsOneWidget);
    expect(find.text('60.0°C'), findsOneWidget);

    expect(find.text('10:30 AM'), findsOneWidget);

    expect(find.text('Зберегти'), findsOneWidget);
    expect(find.text('Вийти'), findsOneWidget);
  });

  testWidgets('ProfileScreen allows changing the temperature', (WidgetTester tester) async {
    final appState = AppState();
    appState.setPreferredTemp(60.0);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<AppState>(
          create: (_) => appState,
          child: const ProfileScreen(),  
        ),
      ),
    );

    await tester.drag(find.byType(Slider), const Offset(50, 0));
    await tester.pump();

    expect(appState.preferredTemp, isNot(60.0));
  });
}
