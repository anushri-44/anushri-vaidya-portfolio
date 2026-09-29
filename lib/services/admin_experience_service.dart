import 'dart:convert';

import '../core/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/experience.dart';
import 'auth_service.dart';

class AdminExperienceService {
  
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

  Future<List<Experience>> fetchExperience() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/experience'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Experience.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load experience: ${response.statusCode}',
    );
  }

  Future<Experience> createExperience({
    required String role,
    required String company,
    required String location,
    required String startDate,
    required String endDate,
    required String description,
    required List<String> bullets,
    required List<String> technologies,
    required int order,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/experience'),
      headers: _headers,
      body: jsonEncode({
        'role': role,
        'company': company,
        'location': location,
        'start_date': startDate,
        'end_date': endDate,
        'description': description,
        'bullets': bullets,
        'technologies': technologies,
        'order': order,
      }),
    );

    if (response.statusCode == 201) {
      return Experience.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create experience: ${response.statusCode}',
    );
  }

  Future<Experience> updateExperience({
    required String id,
    String? role,
    String? company,
    String? location,
    String? startDate,
    String? endDate,
    String? description,
    List<String>? bullets,
    List<String>? technologies,
    int? order,
  }) async {
    final body = <String, dynamic>{};

    if (role != null) body['role'] = role;
    if (company != null) body['company'] = company;
    if (location != null) body['location'] = location;
    if (startDate != null) body['start_date'] = startDate;
    if (endDate != null) body['end_date'] = endDate;
    if (description != null) body['description'] = description;
    if (bullets != null) body['bullets'] = bullets;
    if (technologies != null) {
      body['technologies'] = technologies;
    }
    if (order != null) body['order'] = order;

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/experience/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Experience.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to update experience: ${response.statusCode}',
    );
  }

  Future<void> deleteExperience(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/experience/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete experience: ${response.statusCode}',
      );
    }
  }
}