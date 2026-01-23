class RewardMission {
  const RewardMission({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.total,
    required this.rewardAmount,
  });

  final String title;
  final String subtitle;
  final int progress;
  final int total;
  final double rewardAmount;
}
