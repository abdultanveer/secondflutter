import 'package:flutter/material.dart';
import 'package:secondflutter/electric_bills_sqlite.dart';

import '../main.dart';
import '../model/electricity_bill.dart';

class BillDetailsPage extends StatelessWidget {

  final ElectricityBill bill;

  const BillDetailsPage({
    super.key,
    required this.bill,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Bill Details'),

        actions: [

          IconButton(
            icon: const Icon(Icons.edit),

            onPressed: () async {

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddBillPage(
                      bill: bill,
                    );
                  },
                ),
              );

              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }

            },

          ),

        ],

      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              bill.consumerName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text('Consumer Number: ${bill.consumerNumber}'),

            Text('Bill Month: ${bill.billMonth}'),

            Text('Units Consumed: ${bill.unitsConsumed}'),

            Text(
              'Bill Amount: ₹${bill.billAmount.toStringAsFixed(2)}',
            ),

            Text('Due Date: ${bill.dueDate}'),

            Text(
              'Payment Status: ${bill.paid ? "Paid" : "Unpaid"}',
            ),

          ],

        ),

      ),

    );

  }

}