class LeaderboardEntry {
  final int rank;
  final String displayName;
  final String initials;
  final int score;
  final int percentile;

  LeaderboardEntry({
    required this.rank,
    required this.displayName,
    required this.initials,
    required this.score,
    required this.percentile,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final name = json['displayName'] ?? json['username'] ?? 'User';
    final initials = name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    return LeaderboardEntry(
      rank: json['rank'],
      displayName: name,
      initials: initials,
      score: json['score'],
      percentile: json['percentile'],
    );
  }
}
