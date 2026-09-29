
class Skill {
  final String id;
  final String category;
  final String icon;
  final List<String> skills;
  final int order;

  const Skill({
    required this.id,
    required this.category,
    required this.icon,
    required this.skills,
    required this.order,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      skills: List<String>.from(
        json['skills'] ?? const [],
      ),
      order: (json['order'] as num?)?.toInt() ?? 999,
    );
  }
}