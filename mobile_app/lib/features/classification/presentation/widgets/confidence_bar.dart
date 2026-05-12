import 'package:flutter/material.dart';

class ConfidenceBar extends StatelessWidget {
  final String modelName;
  final String label;
  final double confidence;
  final bool isBest;

  const ConfidenceBar({
    super.key,
    required this.modelName,
    required this.label,
    required this.confidence,
    this.isBest = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDefective = label.toLowerCase() == 'defective';
    final color = isDefective ? Colors.red : Colors.green;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isBest ? color : Colors.grey.shade300,
          width: isBest ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: isBest ? color.withOpacity(0.05) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    modelName,
                    style: TextStyle(
                      fontWeight:
                          isBest ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  if (isBest) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'TERBAIK',
                        style: TextStyle(
                            color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ],
              ),
              Text(
                '${confidence.toStringAsFixed(1)}%',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}