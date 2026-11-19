import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'counter_model.dart';
//https://chatgpt.com/share/6afe9586-94b4-83e8-bb83-5e5491a5804e
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CounterModel(),
      child: const MaterialApp(
        home: CounterPage(),
      ),
    ),
  );
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Learning'),
      ),
      body:  Center(
        child: Text(
          '${context.watch<CounterModel>().counter}', //abdul
          style: const TextStyle(fontSize: 40),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('fab clicked');
          context.read<CounterModel>().increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}