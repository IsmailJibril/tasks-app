import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tasks_app/main.dart';

void main() {
  testWidgets('Home page renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const TasksApp());

    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('No tasks yet.\nTap + to add your first task!'),
        findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
