import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: Scaffold(
      body: CounterExample(),
    ),
  ));
}

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  // 1. Initialize the ValueNotifier
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    // 2. Always dispose to prevent memory leaks
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // 3. Listen to changes and rebuild only this Text widget
        child: ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, count, child) {
            return Text('Count: $count', style: const TextStyle(fontSize: 24));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // 4. Update the value directly without setState
        onPressed: () => _counter.value++,
        child: const Icon(Icons.add),
      ),
    );
  }
}