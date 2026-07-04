import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BalanceAmountText extends StatelessWidget {
  final double balance;

  const BalanceAmountText({required this.balance, super.key});

  @override
  Widget build(BuildContext context) {
    final isPositive = balance >= 0;
    final label = isPositive ? 'Recibe' : 'Paga';
    final amount = balance.abs().toStringAsFixed(2);

    return Text(
      '$label \$$amount',
      style: isPositive ? AppTextStyles.balancePositive : AppTextStyles.balanceNegative,
    );
  }
}