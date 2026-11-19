import 'package:flutter/material.dart';
import 'package:secondflutter/storage/database_helper.dart';

import 'model/electricity_bill.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final db = await DatabaseHelper.database;

  // Create a bill object
  ElectricityBill bill = ElectricityBill(
    consumerNumber: '1234567890',
    consumerName: 'Ramesh',
    billMonth: 'November 2026',
    unitsConsumed: 245,
    billAmount: 1850.50,
    dueDate: '2026-11-30',
  );

  // Insert the bill into SQLite
  int id = await DatabaseHelper.insertBill(bill);

  print('Bill inserted successfully!');
  print('Generated ID: $id');

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electricity Bills',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int selectedIndex = 0;

  final List<Widget> pages = [
    const BillsPage(),
    const AddBillPage(),
    const SummaryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electricity Bills'),
      ),

      body: pages[selectedIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,

        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Bills',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle),
            label: 'Add Bill',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Summary',
          ),
        ],
      ),
    );
  }
}

// Bills Screen
class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Bills will appear here',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Add Bill Screen
class AddBillPage extends StatelessWidget {
  const AddBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Add Bill Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

// Summary Screen
class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Summary Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}