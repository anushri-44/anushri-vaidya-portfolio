class Experience {
  final String id;
  final String role;
  final String company;
  final String location;
  final String startDate;
  final String endDate;
  final String description;
  final List<String> bullets;
  final List<String> technologies;
  final int order;

  const Experience({
    required this.id,
    required this.role,
    required this.company,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.bullets,
    required this.technologies,
    required this.order,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      bullets: List<String>.from(
        json['bullets'] ?? const [],
      ),
      technologies: List<String>.from(
        json['technologies'] ?? const [],
      ),
      order: (json['order'] as num?)?.toInt() ?? 999,
    );
  }
}