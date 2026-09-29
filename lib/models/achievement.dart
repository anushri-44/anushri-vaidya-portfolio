class Achievement {
  final String id;
  final String icon;
  final String title;
  final String subtitle;
  final String description;
  final int order;

  Achievement({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.order,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] ?? '',
      icon: json['icon'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}