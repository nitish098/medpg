import 'package:flutter/material.dart';

import 'widgets/build_feature_widget.dart';

class BuildFeatureSection extends StatelessWidget {
  const BuildFeatureSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFE6F0F9),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading
          Text(
            'Smarter Preparation\nfor Medical Exams',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          ),
          SizedBox(height: 20),

          // Description text
          Text(
            'Your personalized learning platform for NEET-PG, INI-CET, and FMGE exam preparation with adaptive learning, performance analytics, and spaced repetition.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF4B5563),
              height: 1.5,
            ),
          ),
          SizedBox(height: 32),

          // Feature 1: Adaptive MCQ Practice
          BuildFeatureItem(icon: Icons.book, iconColor: Color(0xFF0074BD), title: 'Adaptive MCQ Practice', description: 'Personalized questions based on your learning needs'),
          SizedBox(height: 24),

          // Feature 2: AI-Enhanced Learning
          BuildFeatureItem(icon: Icons.psychology, iconColor: Color(0xFF0074BD), title: 'AI-Enhanced Learning', description: 'Detailed explanations and progress insights'),
          SizedBox(height: 24),

          BuildFeatureItem(icon: Icons.track_changes, iconColor: Color(0xFF0074BD), title: 'Performance Tracking', description: 'Monitor your improvement and identify weak areas'),
          SizedBox(height: 24),

          BuildFeatureItem(icon: Icons.timelapse, iconColor: Color(0xFF0074BD), title: 'Efficient Study Schedule', description: 'Optimize your preparation with spaced repetition.'),

          SizedBox(
            height: 20,
          ),
          Text(
            '"the medico.app helped me ipmrove my rank percentile by 35 points in just 3 months of focused practise."',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '- Dr. Priya S., NEET PG 2024',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}