
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const greeting = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const heading = TextStyle(
    fontSize: 24,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
  );

  static const cardTitle = TextStyle(
    fontSize: 17,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const label = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    fontWeight: FontWeight.w400,
  );

  static const amountLarge = TextStyle(
    fontSize: 28,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w800,
  );

  static const balancePositive = TextStyle(
    fontSize: 16,
    color: AppColors.positive,
    fontWeight: FontWeight.w700,
  );

  static const balanceNegative = TextStyle(
    fontSize: 16,
    color: AppColors.negative,
    fontWeight: FontWeight.w700,
  );
}