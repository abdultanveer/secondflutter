import 'package:flutter/material.dart';
import 'package:secondflutter/storage/database_helper.dart';

import 'model/electricity_bill.dart';

void main() {
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
class BillsPage extends StatefulWidget {

  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();

}

class _BillsPageState extends State<BillsPage> {

  late Future<List<ElectricityBill>> billsFuture;

  @override
  void initState() {
    super.initState();

    billsFuture = DatabaseHelper.getAllBills();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<ElectricityBill>>(
      future: billsFuture,

      builder: (context, snapshot) {

        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
            ),
          );
        }

        // No bills
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No bills found',
              style: TextStyle(fontSize: 20),
            ),
          );
        }

        // Bills available
        final bills = snapshot.data!;

        return ListView.builder(

          itemCount: bills.length,

          itemBuilder: (context, index) {

            final bill = bills[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),

              child: ListTile(

                leading: const CircleAvatar(
                  child: Icon(Icons.electric_bolt),
                ),

                title: Text(bill.consumerName),

                subtitle: Text(
                  '${bill.billMonth} • ${bill.unitsConsumed} units',
                ),

                trailing: Text(
                  '₹${bill.billAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                onTap: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected bill ID: ${bill.id}',
                      ),
                    ),
                  );

                },

              ),
            );

          },

        );

      },

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