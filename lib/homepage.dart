import 'package:flutter/material.dart';
import 'tax_calculator.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Tax Calculator'),
      ),
      body: TaxCalculator(),
    );
  }
}
