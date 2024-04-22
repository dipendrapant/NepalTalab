import 'package:flutter/material.dart';
import 'package:tax_calculator/utils/colors.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            child: Image.asset(
              "assets/logo.png",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Text(
            'Income Tax Calculator Nepal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.appMainColor,
            ),
          ),
        ],
      ),
    );
  }
}
