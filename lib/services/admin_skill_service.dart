import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_portfolio/core/config/api_config.dart';

import '../models/skill.dart';
import 'auth_service.dart';

class AdminSkillService {
 
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

  Future<List<Skill>> fetchSkills() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/skills'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Skill.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load skills: ${response.statusCode}',
    );
  }

  Future<Skill> createSkill({
    required String category,
    required String icon,
    required List<String> skills,
    required int order,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/skills'),
      headers: _headers,
      body: jsonEncode({
        'category': category,
        'icon': icon,
        'skills': skills,
        'order': order,
      }),
    );

    if (response.statusCode == 201) {
      return Skill.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create skill: ${response.statusCode}',
    );
  }

  Future<Skill> updateSkill({
    required String id,
    String? category,
    String? icon,
    List<String>? skills,
    int? order,
  }) async {
    final body = <String, dynamic>{};

    if (category != null) {
      body['category'] = category;
    }

    if (icon != null) {
      body['icon'] = icon;
    }

    if (skills != null) {
      body['skills'] = skills;
    }

    if (order != null) {
      body['order'] = order;
    }

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/skills/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Skill.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to update skill: ${response.statusCode}',
    );
  }

  Future<void> deleteSkill(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/skills/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete skill: ${response.statusCode}',
      );
    }
  }
}