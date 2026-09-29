class Education {
  final String id;
  final String degree;
  final String institution;
  final String location;
  final String startDate;
  final String endDate;
  final String status;
  final String description;
  final int order;

  Education({
    required this.id,
    required this.degree,
    required this.institution,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.order,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'] ?? '',
      degree: json['degree'] ?? '',
      institution: json['institution'] ?? '',
      location: json['location'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      order: json['order'] ?? 0,
    );
  }
}