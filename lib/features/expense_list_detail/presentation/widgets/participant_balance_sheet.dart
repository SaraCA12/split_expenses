import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/balance_amount_text.dart';
import '../../domain/balance_calculator.dart';

void showParticipantBalanceSheet(BuildContext context, List<ParticipantBalance> balances) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Balance por participante',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...balances.map((b) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(backgroundColor: AppColors.avatarBg1, child: Text(b.participantName[0].toUpperCase())),
                    const SizedBox(width: 12),
                    Expanded(child: Text(b.participantName, style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
                    BalanceAmountText(balance: b.balance),
                  ],
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}