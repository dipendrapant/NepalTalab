import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TaxBracket {
  final double minIncome;
  final double maxIncome;
  final double taxRate;

  TaxBracket({
    required this.minIncome,
    required this.maxIncome,
    required this.taxRate,
  });
}

class TaxCalculator extends StatefulWidget {
  @override
  _TaxCalculatorState createState() => _TaxCalculatorState();
}

class _TaxCalculatorState extends State<TaxCalculator> {
  final TextEditingController incomeController = TextEditingController();
  String selectedPeriod = 'Yearly';
  double taxAmount = 0.0;

  final List<TaxBracket> taxBrackets = [
    TaxBracket(minIncome: 0, maxIncome: 400000, taxRate: 0.01),
    TaxBracket(minIncome: 400001, maxIncome: 600000, taxRate: 0.10),
    TaxBracket(minIncome: 600001, maxIncome: 1000000, taxRate: 0.20),
    TaxBracket(minIncome: 1000001, maxIncome: double.infinity, taxRate: 0.30),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter Gross Income',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: incomeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 20),
          DropdownButton<String>(
            value: selectedPeriod,
            onChanged: (String? value) {
              setState(() {
                selectedPeriod = value!;
              });
            },
            items: <String>['Yearly', 'Monthly'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              calculateTax();
            },
            child: Text('Calculate Tax'),
          ),
          SizedBox(height: 20),
          Text(
            'Tax Amount: $taxAmount',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Container(
            height: 300,
            child: buildChart(),
          ),
        ],
      ),
    );
  }

  void calculateTax() {
    double income = double.parse(incomeController.text);
    double annualIncome = selectedPeriod == 'Yearly' ? income : income * 12;

    double tax = 0;
    double remainingIncome = annualIncome;

    for (var bracket in taxBrackets) {
      if (remainingIncome <= 0) {
        break;
      }
      double taxableIncome = 0;
      if (remainingIncome > bracket.maxIncome) {
        taxableIncome = bracket.maxIncome - bracket.minIncome;
      } else {
        taxableIncome = remainingIncome - bracket.minIncome;
      }
      tax += taxableIncome * bracket.taxRate;
      remainingIncome -= taxableIncome;
    }

    setState(() {
      taxAmount = tax;
    });
  }

  Widget buildChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: taxAmount,
            color: Colors.blue,
            title: '\$${taxAmount.toStringAsFixed(2)}',
            radius: 100,
          ),
          PieChartSectionData(
            value: incomeController.text.isNotEmpty
                ? double.parse(incomeController.text) - taxAmount
                : 0,
            color: Colors.grey,
            title: 'Non-taxable',
            radius: 100,
          ),
        ],
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
