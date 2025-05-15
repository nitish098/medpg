import 'package:flutter/material.dart';
import 'package:medpg/presentation/home/leader_bord_screen.dart';
import 'package:medpg/presentation/login/login_page.dart';
import 'package:medpg/presentation/models/recommended.dart';
import 'package:provider/provider.dart';

import '../../view_model/user_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double? questionsGrowth;
  double? accuracyGrowth;
  double? sessionsGrowth;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadGrowthData();
  }
  Future<void> _loadGrowthData() async {
    final auth = Provider.of<UserProvider>(context, listen: false);
    final growth = await auth.progressGrowth();
    if (growth != null) {
      setState(() {
        questionsGrowth = growth['questionsGrowth']?.toDouble();
        accuracyGrowth = growth['accuracyGrowth']?.toDouble();
        sessionsGrowth = growth['sessionsGrowth']?.toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context).userData;
    final name = authProvider?.displayName ?? "User";
    final examName = authProvider?.targetExam ?? "exam";
     final initialName = name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    //  final response = await authProvider.fetchLeaderboard();
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: _buildAppBar(initialName),
      body: _buildBody(name, examName),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LeaderboardScreen()));
            },
          ),
          FloatingActionButton(
            onPressed: () {
              // Provider.of<UserProvider>(context).logOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
            
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
        const Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 26,
            ),
            // Positioned(
            //   top: 10,
            //   right: 0,
            //   child: Container(
            //     padding: const EdgeInsets.all(4),
            //     decoration: const BoxDecoration(
            //       color: Colors.red,
            //       shape: BoxShape.circle,
            //     ),
            //     child: const Text(
            //       '15',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 10,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        const SizedBox(width: 16),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF3D93D0),
            borderRadius: BorderRadius.circular(20),
          ),
          child:  Center(
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
            // _buildStatsGrid(),
            const SizedBox(height: 24),

            // Set Smarter Goals card
            _buildGoalsCard(),
            const SizedBox(height: 24),
            _buildRecommendedGoals()
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(String question, String accuracy, String session) {
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
          value: question,
          indicator: _buildPercentageIndicator(00, true),
        ),
        // Accuracy Stats
        _buildStatCard(
          title: 'Accuracy',
          value: accuracy,
        ),
        // Sessions Stats
        _buildStatCard(
          title: 'Sessions',
          value: session,
          indicator: _buildPercentageIndicator(00, true),
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

  Widget _buildPercentageIndicator(int percentage, bool increase) {
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

  Widget _buildRecommendedGoals() {
    return Column(
      children:
          getRecommendedTiles.map((e) => RecommendedTiles(topic: e)).toList(),
    );
  }

  // Widget _buildRecommendedTiles() {
  Widget _buildGoalsCard() {
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.track_changes,
                    color: Colors.red,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Set Smarter Goals',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Let AI help you set and track achievable study goals based on your learning patterns.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0074BD),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Set AI Goals',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF0074BD),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Mocks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Revise',
          ),
        ],
      ),
    );
  }
}
