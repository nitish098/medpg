import 'package:flutter/material.dart';

class RecommendedTopic {
  final IconData icondata;
  final String title;
  final String subtiitle;

  RecommendedTopic(
    this.icondata,
    this.title,
    this.subtiitle,
  );
}

List<RecommendedTopic> getRecommendedTiles = [
  RecommendedTopic(Icons.biotech, "Microbiology", "Immunology"),
  RecommendedTopic(Icons.layers, "Anatomy", "Embroyology"),
  RecommendedTopic(Icons.favorite, 'Physiology', 'Respiratory System'),
  RecommendedTopic(
      Icons.coronavirus, 'Dermatology', 'Veneral Sexually Transmitted...'),
];

class RecommendedTiles extends StatelessWidget {
  final RecommendedTopic topic;
  const RecommendedTiles({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(
                topic.icondata,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    topic.subtiitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                 
                ],
              ),
            ),
             TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    child: const Text("Practise"),
                  )
          ],
        ),
      ),
    );
  }
}
