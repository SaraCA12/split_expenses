import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/currency_formatter.dart';

class DonutSliceData {
  final String label;
  final double value;
  final Color color;

  const DonutSliceData({required this.label, required this.value, required this.color});
}

class CategoryDonutChart extends StatelessWidget {
  final String title;
  final double total;
  final List<DonutSliceData> slices;

  const CategoryDonutChart({
    required this.title,
    required this.total,
    required this.slices,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          if (slices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('Aún no hay datos', style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else ...[
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 55,
                      sections: slices.map((s) {
                        return PieChartSectionData(
                          value: s.value,
                          color: s.color,
                          showTitle: false,
                          radius: 32,
                        );
                      }).toList(),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                      Text(CurrencyFormatter.format(total),
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ...slices.map((s) {
              final percent = total == 0 ? 0 : (s.value / total * 100);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(width: 10, height: 10, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(s.label, style: TextStyle(color: AppColors.textPrimary))),
                    Text('${percent.toStringAsFixed(0)}%', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    Text(CurrencyFormatter.format(s.value), style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}