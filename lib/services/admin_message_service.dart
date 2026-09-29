import 'dart:convert';

import '../core/config/api_config.dart';
import 'package:http/http.dart' as http;

import '../models/message.dart';
import 'auth_service.dart';

class AdminMessageService {
  
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

  Future<List<Message>> fetchMessages() async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/api/messages'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Message.fromJson(json))
          .toList();
    }

    if (response.statusCode == 401) {
      throw Exception('Admin session expired. Please log in again.');
    }

    throw Exception(
      'Failed to load messages: ${response.statusCode}',
    );
  }

  Future<void> deleteMessage(String id) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/api/messages/$id'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return;
    }

    if (response.statusCode == 401) {
      throw Exception('Admin session expired. Please log in again.');
    }

    throw Exception(
      'Failed to delete message: ${response.statusCode}',
    );
  }
}