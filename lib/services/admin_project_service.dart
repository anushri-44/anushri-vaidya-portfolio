import 'dart:convert';

import '../core/config/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:my_portfolio/services/auth_service.dart';


import '../models/project.dart';

class AdminProjectService {
  
  Map<String, String> get _headers {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception('Admin session expired. Please log in again.');
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Project>> fetchProjects() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/projects'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Project.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load projects: ${response.statusCode}',
    );
  }

  Future<Project> createProject({
    required String slug,
    required String title,
    required String description,
    required List<String> technologies,
    String? projectUrl,
    String? caseStudyUrl,
    bool featured = false,
    int order = 1,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/projects'),
      headers: _headers,
      body: jsonEncode({
        'slug': slug,
        'title': title,
        'description': description,
        'technologies': technologies,
        'project_url': projectUrl,
        'case_study_url': caseStudyUrl,
        'featured': featured,
        'order': order,
      }),
    );

    if (response.statusCode == 201) {
      return Project.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create project: ${response.statusCode}',
    );
  }

  Future<Project> updateProject({
    required String id,
    String? slug,
    String? title,
    String? description,
    List<String>? technologies,
    String? projectUrl,
    String? caseStudyUrl,
    bool? featured,
    int? order,
  }) async {
    final body = <String, dynamic>{};

    if (slug != null) body['slug'] = slug;
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (technologies != null) {
      body['technologies'] = technologies;
    }
    if (projectUrl != null) body['project_url'] = projectUrl;
    if (caseStudyUrl != null) {
      body['case_study_url'] = caseStudyUrl;
    }
    if (featured != null) body['featured'] = featured;
    if (order != null) body['order'] = order;

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/projects/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Project.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to update project: ${response.statusCode}',
    );
  }

  Future<void> deleteProject(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/projects/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete project: ${response.statusCode}',
      );
    }
  }
}