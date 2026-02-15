import 'package:flutter/material.dart';

class LoanCalculatorScreen extends StatefulWidget {
  const LoanCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  double loanAmount = 50000;
  double interestRate = 5.5;
  int loanTerm = 10;

  @override
  Widget build(BuildContext context) {
    final monthlyPayment = (loanAmount * (interestRate / 1200) * pow(1 + interestRate / 1200, loanTerm * 12)) / (pow(1 + interestRate / 1200, loanTerm * 12) - 1);

    return Scaffold(
      appBar: AppBar(title: Text('Loan Calculator')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Loan Amount', style: TextStyle(fontSize: 16)),
                    Text('\$${loanAmount.toInt()}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Slider(value: loanAmount, min: 10000, max: 500000, onChanged: (v) => setState(() => loanAmount = v)),
                    SizedBox(height: 20),
                    Text('Interest Rate', style: TextStyle(fontSize: 16)),
                    Text('${interestRate.toStringAsFixed(1)}%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Slider(value: interestRate, min: 1, max: 20, onChanged: (v) => setState(() => interestRate = v)),
                    SizedBox(height: 20),
                    Text('Loan Term (Years)', style: TextStyle(fontSize: 16)),
                    Text('$loanTerm', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    Slider(value: loanTerm.toDouble(), min: 1, max: 30, onChanged: (v) => setState(() => loanTerm = v.toInt())),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Monthly Payment', style: TextStyle(fontSize: 18)),
                    Text('\$${monthlyPayment.toStringAsFixed(2)}', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double pow(double x, int y) {
    double result = 1;
    for (int i = 0; i < y; i++) result *= x;
    return result;
  }
}
