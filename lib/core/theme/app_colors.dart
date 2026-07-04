import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primario — morado vino
  static const primary = Color(0xFF4A1D4E);
  static const primaryDark = Color(0xFF3A1640);
  static const primaryLight = Color(0xFF8B5FA8);

  // Fondo degradado
  static const gradientStart = Color(0xFFE8D9F3);
  static const gradientMid = Color(0xFFF3D6E8);
  static const gradientEnd = Color(0xFFFBD9C4);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientStart, gradientMid, gradientEnd],
  );

  // Superficies
  static const surface = Colors.white;
  static const surfaceMuted = Color(0xFFF3EEF7); // fondo de inputs/chips inactivos

  // Texto
  static const textPrimary = Color(0xFF241B2E);
  static const textSecondary = Color(0xFF7A7285);
  static const textHint = Color(0xFFADA5B8);

  // Balance
  static const positive = Color(0xFF2E9E5B); // recibe / verde
  static const negative = Color(0xFFE0533D); // paga / rojo

  // Donut chart
  static const chartPurpleDark = Color(0xFF4A1D4E);
  static const chartLilac = Color(0xFFB79FD6);
  static const chartMustard = Color(0xFFE0C158);
  static const chartGreen = Color(0xFF4FAE72);
  static const chartPeach = Color(0xFFF0A868);

  static const chartPalette = [
    chartPurpleDark,
    chartLilac,
    chartMustard,
    chartGreen,
    chartPeach,
  ];

  // Avatares (fondo pastel para iniciales/fotos)
  static const avatarBg1 = Color(0xFFF6D9E8);
  static const avatarBg2 = Color(0xFFDCE0F7);
  static const avatarBg3 = Color(0xFFE8DCF7);
  static const avatarBg4 = Color(0xFFF7E4D9);
}