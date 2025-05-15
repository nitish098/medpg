import 'package:flutter/material.dart';

import '../models/recommended.dart';

class BuildRecommendedGoals extends StatelessWidget {
  const BuildRecommendedGoals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          getRecommendedTiles.map((e) => RecommendedTiles(topic: e)).toList(),
    );
  }
}

class BuildPercentageIndicator extends StatelessWidget {
  const BuildPercentageIndicator({
    super.key,
    required this.percentage,
    required this.increase,
  });

  final int percentage;
  final bool increase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFD1FAE5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_upward,
            color: Color(0xFF059669),
            size: 14,
          ),
          const SizedBox(width: 2),
          Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF059669),
            ),
          ),
        ],
      ),
    );
  }
}
