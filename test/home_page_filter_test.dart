import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:first_flutter_project/home_page.dart'; // <-- заміни, якщо треба
import 'package:first_flutter_project/auth_service.dart'; // <-- заміни, якщо треба

void main() {
  setUp(() {
    AuthService.logout(); // щоб не було привітання/станів
  });

  testWidgets('HomePage: empty query shows all tours', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    // Тури з mock_tours.dart
    expect(find.text('Морський відпочинок All Inclusive'), findsOneWidget);
    expect(find.text('Європейський вікенд'), findsOneWidget);
    expect(find.text('Гірський релакс'), findsOneWidget);
  });

  testWidgets('HomePage: search is case-insensitive and matches country/city', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'польща');
    await tester.pumpAndSettle();

    expect(find.text('Європейський вікенд'), findsOneWidget);
    expect(find.text('Морський відпочинок All Inclusive'), findsNothing);
    expect(find.text('Гірський релакс'), findsNothing);
  });

  testWidgets('HomePage: shows "Нічого не знайдено" when no matches', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'qwertyzzz');
    await tester.pumpAndSettle();

    expect(find.text('Нічого не знайдено'), findsOneWidget);
  });
}
