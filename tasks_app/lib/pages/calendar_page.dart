import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Calendar Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
