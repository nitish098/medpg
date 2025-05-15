import 'package:flutter/material.dart';
import 'package:medpg/presentation/login/login_page.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_provider.dart';
import '../models/leader_board.dart';
import 'bottom_nav.dart';
import 'goals_card.dart';
import 'recommanded_goals.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
        Text('${entry.rank}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE5EAF1),
          child: Text(entry.initials,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(entry.displayName, overflow: TextOverflow.ellipsis),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(entry.score.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('${entry.percentile}th percentile',
                style: const TextStyle(fontSize: 12)),
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
    final authProvider = Provider.of<UserProvider>(context).userData;
    final name = authProvider?.displayName ?? "User";
    final examName = authProvider?.targetExam ?? "exam";
    final initialName =
        name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    //  final response = await authProvider.fetchLeaderboard();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: _buildAppBar(initialName),
      body: _buildBody(name, examName),
      bottomNavigationBar: const BuildBottamNavigation(),
      floatingActionButton: Row(
        children: [
          // FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => const LeaderboardScreen()));
          //   },
          // ),
          FloatingActionButton(
            onPressed: () {
              // Provider.of<UserProvider>(context).logOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(String initialName) {
    return AppBar(
      backgroundColor: const Color(0xFF0074BD),
      elevation: 0,
      toolbarHeight: 90,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Image.asset(
                'assets/medico_logo.png',
                width: 32,
                height: 32,
                // If you don't have the image, use Icon instead
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.medical_services,
                  color: Color(0xFF0074BD),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'themedico.app',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        const SizedBox(width: 16),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF3D93D0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              initialName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildBody(String displayName, String targetedExam) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome section
            Text(
              'Welcome, $displayName',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preparing for $targetedExam',
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),

            // Stats grid
            _buildStatsGrid(),
            const SizedBox(height: 24),

            // Set Smarter Goals card
            const BuildGoalsCard(),
            const SizedBox(height: 24),

            // const BuildRecommendedGoals(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.emoji_events),
                          SizedBox(width: 8),
                          Text('Leaderboard',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildDropdown(
                            value: selectedCategory,
                            options: categoryLabels,
                            onSelect: (val) =>
                                setState(() => selectedCategory = val),
                          ),
                          const SizedBox(width: 8),
                          _buildDropdown(
                            value: selectedPeriod,
                            options: periodLabels,
                            onSelect: (val) =>
                                setState(() => selectedPeriod = val),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 300,
                        child: ListView.separated(
                          itemCount: leaderboard.length,
                          itemBuilder: (_, index) =>
                              _buildLeaderboardTile(leaderboard[index]),
                          separatorBuilder: (_, __) =>
                              const Divider(height: 16),
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
            // const LeaderboardScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Questions Stats
        _buildStatCard(
          title: 'Questions',
          value: '--',
          indicator:
              const BuildPercentageIndicator(percentage: 00, increase: true),
        ),
        // Accuracy Stats
        _buildStatCard(
          title: 'Accuracy',
          value: '--%',
        ),
        // Sessions Stats
        _buildStatCard(
          title: 'Sessions',
          value: '--',
          indicator:
              const BuildPercentageIndicator(percentage: 00, increase: true),
        ),
        // Strong Subject Stats
        _buildStatCard(
          title: 'Strong Subject',
          value: '--',
          subvalue: '--%',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    String? subvalue,
    Widget? indicator,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (indicator != null) indicator,
            ],
          ),
          if (subvalue != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subvalue,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
