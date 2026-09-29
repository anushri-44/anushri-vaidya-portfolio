class Project {
  final String id;
  final String slug;
  final String title;
  final String description;
  final List<String> technologies;
  final String? projectUrl;
  final String? caseStudyUrl;
  final bool featured;
  final int order;

  const Project({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.technologies,
    this.projectUrl,
    this.caseStudyUrl,
    required this.featured,
    required this.order,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      technologies: List<String>.from(
        json['technologies'] ?? const [],
      ),
      projectUrl: json['project_url']?.toString(),
      caseStudyUrl: json['case_study_url']?.toString(),
      featured: json['featured'] == true,
      order: (json['order'] as num?)?.toInt() ?? 999,
    );
  }
}