import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/config/api_config.dart';
import '../models/achievement.dart';
import 'auth_service.dart';

class AdminAchievementService {
  Map<String, String> get _headers {
    final token = AuthService.accessToken;

    if (token == null || token.isEmpty) {
      throw Exception(
        'Admin session expired. Please log in again.',
      );
    }

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<Achievement>> fetchAchievements() async {
    final response = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/achievements',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map(
            (json) => Achievement.fromJson(json),
          )
          .toList();
    }

    throw Exception(
      'Failed to load achievements: ${response.statusCode}',
    );
  }

  Future<Achievement> createAchievement({
    required String icon,
    required String title,
    required String subtitle,
    required String description,
    required int order,
  }) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/achievements',
      ),
      headers: _headers,
      body: jsonEncode({
        'icon': icon,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'order': order,
      }),
    );

    if (response.statusCode == 201) {
      return Achievement.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create achievement: ${response.statusCode}',
    );
  }

  Future<Achievement> updateAchievement({
    required String id,
    String? icon,
    String? title,
    String? subtitle,
    String? description,
    int? order,
  }) async {
    final body = <String, dynamic>{};

    if (icon != null) body['icon'] = icon;
    if (title != null) body['title'] = title;
    if (subtitle != null) body['subtitle'] = subtitle;

    if (description != null) {
      body['description'] = description;
    }

    if (order != null) {
      body['order'] = order;
    }

    final response = await http.put(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/achievements/$id',
      ),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Achievement.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to update achievement: ${response.statusCode}',
    );
  }

  Future<void> deleteAchievement(String id) async {
    final response = await http.delete(
      Uri.parse(
        '${ApiConfig.baseUrl}/api/achievements/$id',
      ),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete achievement: ${response.statusCode}',
      );
    }
  }
}