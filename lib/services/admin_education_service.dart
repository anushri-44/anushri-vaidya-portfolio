import 'dart:convert';

import '../core/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/education.dart';
import 'auth_service.dart';

class AdminEducationService {
  
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

  Future<List<Education>> fetchEducation() async {
    final response = await http.get(
     Uri.parse('${ApiConfig.baseUrl}/api/education'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Education.fromJson(json))
          .toList();
    }

    throw Exception(
      'Failed to load education: ${response.statusCode}',
    );
  }

  Future<Education> createEducation({
    required String degree,
    required String institution,
    required String location,
    required String startDate,
    required String endDate,
    required String status,
    required String description,
    required int order,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/api/education'),
      headers: _headers,
      body: jsonEncode({
        'degree': degree,
        'institution': institution,
        'location': location,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
        'description': description,
        'order': order,
      }),
    );

    if (response.statusCode == 201) {
      return Education.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to create education: ${response.statusCode}',
    );
  }

  Future<Education> updateEducation({
    required String id,
    String? degree,
    String? institution,
    String? location,
    String? startDate,
    String? endDate,
    String? status,
    String? description,
    int? order,
  }) async {
    final body = <String, dynamic>{};

    if (degree != null) body['degree'] = degree;
    if (institution != null) {
      body['institution'] = institution;
    }
    if (location != null) body['location'] = location;
    if (startDate != null) {
      body['start_date'] = startDate;
    }
    if (endDate != null) {
      body['end_date'] = endDate;
    }
    if (status != null) body['status'] = status;
    if (description != null) {
      body['description'] = description;
    }
    if (order != null) body['order'] = order;

    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/api/education/$id'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return Education.fromJson(
        jsonDecode(response.body),
      );
    }

    throw Exception(
      'Failed to update education: ${response.statusCode}',
    );
  }

  Future<void> deleteEducation(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/education/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete education: ${response.statusCode}',
      );
    }
  }
}