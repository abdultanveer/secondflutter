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
class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {

  final _formKey = GlobalKey<FormState>();

  final consumerNumberController = TextEditingController();
  final consumerNameController = TextEditingController();
  final billMonthController = TextEditingController();
  final unitsController = TextEditingController();
  final amountController = TextEditingController();
  final dueDateController = TextEditingController();

  bool paid = false;

  @override
  void dispose() {

    consumerNumberController.dispose();
    consumerNameController.dispose();
    billMonthController.dispose();
    unitsController.dispose();
    amountController.dispose();
    dueDateController.dispose();

    super.dispose();
  }

  Future<void> saveBill() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ElectricityBill bill = ElectricityBill(
      consumerNumber: consumerNumberController.text,
      consumerName: consumerNameController.text,
      billMonth: billMonthController.text,
      unitsConsumed: int.parse(unitsController.text),
      billAmount: double.parse(amountController.text),
      dueDate: dueDateController.text,
      paid: paid,
    );

    int id = await DatabaseHelper.insertBill(bill);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bill saved successfully! ID: $id'),
      ),
    );

    _formKey.currentState!.reset();

    consumerNumberController.clear();
    consumerNameController.clear();
    billMonthController.clear();
    unitsController.clear();
    amountController.clear();
    dueDateController.clear();

    setState(() {
      paid = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),

      child: Form(
        key: _formKey,

        child: Column(
          children: [

            TextFormField(
              controller: consumerNumberController,
              decoration: const InputDecoration(
                labelText: 'Consumer Number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter consumer number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: consumerNameController,
              decoration: const InputDecoration(
                labelText: 'Consumer Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter consumer name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: billMonthController,
              decoration: const InputDecoration(
                labelText: 'Bill Month',
                hintText: 'November 2026',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter bill month';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: unitsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Units Consumed',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter units consumed';
                }

                if (int.tryParse(value) == null) {
                  return 'Enter a valid integer';
                }

                if (int.parse(value) < 0) {
                  return 'Units cannot be negative';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Bill Amount',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter bill amount';
                }

                if (double.tryParse(value) == null) {
                  return 'Enter a valid amount';
                }

                if (double.parse(value) < 0) {
                  return 'Amount cannot be negative';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: dueDateController,
              decoration: const InputDecoration(
                labelText: 'Due Date',
                hintText: 'YYYY-MM-DD',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter due date';
                }
                return null;
              },
            ),

            const SizedBox(height: 8),

            CheckboxListTile(
              title: const Text('Bill Paid'),
              value: paid,
              onChanged: (value) {
                setState(() {
                  paid = value ?? false;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveBill,
                child: const Text('Save Bill'),
              ),
            ),

          ],
        ),
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