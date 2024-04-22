import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tax_calculator/screens/home/components/appbar.dart';
import 'package:tax_calculator/screens/home/model/tax_bracket.dart';
import 'package:tax_calculator/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController incomeController = TextEditingController();
  String selectedPeriod = 'Yearly';
  String selectedNature = 'Unmarried';
  double taxAmount = 0.0;

  Map<String, List<TaxBracket>> taxBrackets = {
    'Unmarried': [
      TaxBracket(minIncome: 0, maxIncome: 500000, taxRate: 0.01),
      TaxBracket(minIncome: 500001, maxIncome: 700000, taxRate: 0.10),
      TaxBracket(minIncome: 700001, maxIncome: 1000000, taxRate: 0.20),
      TaxBracket(minIncome: 1000001, maxIncome: double.infinity, taxRate: 0.30),
    ],
    'Married': [
      TaxBracket(minIncome: 0, maxIncome: 600000, taxRate: 0.01),
      TaxBracket(minIncome: 600001, maxIncome: 800000, taxRate: 0.10),
      TaxBracket(minIncome: 800001, maxIncome: 1100000, taxRate: 0.20),
      TaxBracket(minIncome: 1100001, maxIncome: double.infinity, taxRate: 0.30),
    ],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      calculateTax();
    });
  }

  void calculateTax() {
    String incomeText = incomeController.text.trim();
    if (incomeText.isEmpty) {
      // Handle empty input
      return;
    }

    double income;
    try {
      income = double.parse(incomeText);
    } catch (e) {
      // Handle invalid input format
      return;
    }

    double annualIncome = income;

    if (selectedPeriod == 'Monthly') {
      annualIncome *= 12;
    } else if (selectedPeriod == 'Weekly') {
      annualIncome *= 52;
    }

    double tax = 0;
    double remainingIncome = annualIncome;

    List<TaxBracket> selectedBrackets = taxBrackets[selectedNature]!;

    for (var bracket in selectedBrackets) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // AppBar
              const CustomAppBar(),

              // Body Contents
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30.0, horizontal: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Calculate Tax',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainBlackColor,
                              ),
                            ),
                            const Text(
                              'Find out how much your salary is after tax',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: AppColors.midGrey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Enter Gross Salary",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: TextFormField(
                                        controller: incomeController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: AppColors.appMainColor
                                              .withOpacity(0.1),
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Colors.transparent,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(25),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Per",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: AppColors.appMainColor
                                            .withOpacity(0.1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 30),
                                        child: DropdownButton<String>(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          value: selectedPeriod,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedPeriod = value!;
                                              calculateTax();
                                            });
                                          },
                                          underline: Container(),
                                          items: <String>[
                                            'Yearly',
                                            'Monthly',
                                            'Weekly'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Nature",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: AppColors.appMainColor
                                            .withOpacity(0.1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 30),
                                        child: DropdownButton<String>(
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          value: selectedNature,
                                          onChanged: (String? value) {
                                            setState(() {
                                              selectedNature = value!;
                                              calculateTax();
                                            });
                                          },
                                          underline: Container(),
                                          items: <String>[
                                            'Unmarried',
                                            'Married',
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    calculateTax();
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppColors.appMainColor,
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0, horizontal: 40),
                                      child: Text(
                                        'Calculate Tax',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Tax Amount: ₹$taxAmount',
                              style: const TextStyle(
                                fontSize: 18,
                                color: AppColors.midGrey,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          height: 250,
                          width: 250,
                          'assets/banner.png',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 500,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.9), // Adjust opacity as needed
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Add shadow color
                                  spreadRadius: 3, // Add spread radius
                                  blurRadius: 5, // Add blur radius
                                  offset: const Offset(0, 3), // Add offset
                                ),
                              ],
                              border: Border.all(
                                  color: Colors.white, width: 2), // Add border
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Withholding:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const VerticalDivider(
                                  thickness: double.minPositive,
                                  width: double.infinity,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Gross Salary: ₹${incomeController.text}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Tax Amount: ₹${taxAmount.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Net Income: ₹${(double.tryParse(incomeController.text) ?? 0) - taxAmount}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'If you make ${incomeController.text} NPR a year in Nepal, you will be taxed ${taxAmount.toStringAsFixed(2)} NPR. That means your net pay will be ${(double.tryParse(incomeController.text) ?? 0) - taxAmount} NPR per year.',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 50),
                        Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: buildChart(),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Tax Amount',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  'Net Income',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      color: AppColors.appMainColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '© 2024 Nepal Tax Calculator. All rights reserved.',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: taxAmount,
            color: Colors.blue,
            title: '₹${taxAmount.toStringAsFixed(2)}',
            radius: 70,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          PieChartSectionData(
            value: incomeController.text.isNotEmpty
                ? double.parse(incomeController.text) - taxAmount
                : 0,
            color: Colors.green,
            title:
                '₹${(double.tryParse(incomeController.text) ?? 0) - taxAmount}',
            radius: 70,
            titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
        borderData: FlBorderData(
          show: false,
        ),
        sectionsSpace: 0,
        centerSpaceRadius: 50,
        // sectionsOptions: const PieChartSectionsOptions(
        //   showTitles: true,
        //   pieSpacer: 0,
        //   startDegreeOffset: 180,
        //   endDegreeOffset: 180,
        // ),
      ),
    );
  }
}
