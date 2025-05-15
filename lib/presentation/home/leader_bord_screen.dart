import 'package:flutter/material.dart';
import 'package:medpg/presentation/models/leader_board.dart';
import 'package:medpg/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderboardEntry> leaderboard = [];

  String selectedCategory = 'questions_answered';
  String selectedPeriod = 'weekly';

  final Map<String, String> categoryLabels = {
    'questions_answered': 'Questions',
    'accuracy': 'Accuracy',
    'streak': 'Streak',
    'study_time': 'Study Time',
    'mastery': 'Mastery',
  };

  final Map<String, String> periodLabels = {
    'weekly': 'Weekly',
    'monthly': 'Monthly',
    'all_time': 'All Time',
  };

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    final authProvider = Provider.of<UserProvider>(context, listen: false);
    final entries = await authProvider.fetchLeaderboard(
      category: selectedCategory,
      period: selectedPeriod,
    );
    setState(() => leaderboard = entries);
  }

  Widget _buildLeaderboardTile(LeaderboardEntry entry) {
    return Row(
      children: [
        Text('${entry.rank}', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE5EAF1),
          child: Text(entry.initials, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(entry.displayName, overflow: TextOverflow.ellipsis),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(entry.score.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${entry.percentile}th percentile', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required Map<String, String> options,
    required void Function(String) onSelect,
  }) {
    return PopupMenuButton<String>(
      onSelected: (val) {
        onSelect(val);
        _loadLeaderboard();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE4E7EB)),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(options[value]!),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (context) {
        return options.entries.map((entry) {
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                if (value == entry.key)
                  const Icon(Icons.check, color: Colors.blue, size: 18)
                else
                  const SizedBox(width: 18),
                const SizedBox(width: 8),
                Text(entry.value),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.emoji_events),
                    SizedBox(width: 8),
                    Text('Leaderboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildDropdown(
                      value: selectedCategory,
                      options: categoryLabels,
                      onSelect: (val) => setState(() => selectedCategory = val),
                    ),
                    const SizedBox(width: 8),
                    _buildDropdown(
                      value: selectedPeriod,
                      options: periodLabels,
                      onSelect: (val) => setState(() => selectedPeriod = val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.separated(
                    itemCount: leaderboard.length,
                    itemBuilder: (_, index) => _buildLeaderboardTile(leaderboard[index]),
                    separatorBuilder: (_, __) => const Divider(height: 16),
                  ),
                ),
                const Divider(),
                // const ListTile(
                //   dense: true,
                //   title: Text('Your rank: 396'),
                //   subtitle: Text('Percentile: 28'),
                //   trailing: Text('Your score: 38'),
                // ),
                // const SizedBox(height: 10),
                // TextButton.icon(
                //   onPressed: () {},
                //   icon: const Icon(Icons.bar_chart),
                //   label: const Text('View Full Leaderboard'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
