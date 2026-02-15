import 'package:flutter/material.dart';

class TaxCalculatorScreen extends StatefulWidget {
  const TaxCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<TaxCalculatorScreen> createState() => _TaxCalculatorScreenState();
}

class _TaxCalculatorScreenState extends State<TaxCalculatorScreen> {
  double income = 50000;

  @override
  Widget build(BuildContext context) {
    final tax = income * 0.22;
    final netIncome = income - tax;

    return Scaffold(
      appBar: AppBar(title: Text('Tax Calculator')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Annual Income', style: TextStyle(fontSize: 16)),
                    Text('\$${income.toInt()}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Slider(value: income, min: 10000, max: 500000, onChanged: (v) => setState(() => income = v)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Estimated Tax', style: TextStyle(fontSize: 18)),
                    Text('\$${tax.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Net Income', style: TextStyle(fontSize: 18)),
                    Text('\$${netIncome.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
