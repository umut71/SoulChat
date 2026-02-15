import 'package:flutter/material.dart';

class BudgetPlannerScreen extends StatelessWidget {
  const BudgetPlannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Budget Planner')),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Monthly Budget', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 8),
                  Text('\$3,500', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(children: [Text('Income', style: TextStyle(color: Colors.green)), Text('\$4,200', style: TextStyle(fontWeight: FontWeight.bold))]),
                      Column(children: [Text('Expenses', style: TextStyle(color: Colors.red)), Text('\$2,450', style: TextStyle(fontWeight: FontWeight.bold))]),
                      Column(children: [Text('Savings', style: TextStyle(color: Colors.blue)), Text('\$1,750', style: TextStyle(fontWeight: FontWeight.bold))]),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildBudgetCategory('Housing', 1200, 1500, Colors.blue),
                _buildBudgetCategory('Food', 500, 600, Colors.orange),
                _buildBudgetCategory('Transport', 350, 400, Colors.green),
                _buildBudgetCategory('Entertainment', 200, 300, Colors.purple),
                _buildBudgetCategory('Utilities', 200, 250, Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetCategory(String name, double spent, double budget, Color color) {
    final percentage = spent / budget;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('\$${spent.toInt()} / \$${budget.toInt()}'),
              ],
            ),
            SizedBox(height: 8),
            LinearProgressIndicator(value: percentage, backgroundColor: Colors.grey.shade200, color: color, minHeight: 8),
          ],
        ),
      ),
    );
  }
}
