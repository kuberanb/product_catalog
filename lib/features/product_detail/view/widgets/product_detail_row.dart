import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ProductDetailRow extends StatelessWidget {
  const ProductDetailRow({super.key, required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: AppColors.muted)),
        ),
        const SizedBox(width: 16),
        Expanded(child: Text(value, textAlign: TextAlign.end)),
      ],
    ),
  );
}
