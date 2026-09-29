import 'dart:convert';

import 'package:my_portfolio/core/config/api_config.dart';

import '../models/admin_login.dart';

import '../models/message.dart';

import '../models/achievement.dart';

import '../models/skill.dart';

import '../models/education.dart';

import '../models/experience.dart';

import 'package:http/http.dart' as http;

import '../models/project.dart';

class PortfolioApiService {
  
  static Future<List<Project>> fetchProjects() async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/api/projects');

    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load projects. '
        'Status code: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw Exception('Invalid projects response from API.');
    }

    return decoded
        .map(
          (item) => Project.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  

static Future<List<Skill>> fetchSkills() async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/api/skills');

  final response = await http.get(
    uri,
    headers: {
      'Accept': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load skills. '
      'Status code: ${response.statusCode}',
    );
  }

  final decoded = jsonDecode(response.body);

  if (decoded is! List) {
    throw Exception('Invalid skills response from API.');
  }

  return decoded
      .map(
        (item) => Skill.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
}

static Future<List<Experience>> fetchExperience() async {
  final uri = Uri.parse('${ApiConfig.baseUrl}/api/experience');

  final response = await http.get(
    uri,
    headers: {
      'Accept': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    throw Exception(
      'Failed to load experience. '
      'Status code: ${response.statusCode}',
    );
  }

  final decoded = jsonDecode(response.body);

  if (decoded is! List) {
    throw Exception(
      'Invalid experience response from API.',
    );
  }

  return decoded
      .map(
        (item) => Experience.fromJson(
          item as Map<String, dynamic>,
        ),
      )
      .toList();
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
  } else {
    throw Exception(
      'Failed to load education: ${response.statusCode}',
    );
  }
}

Future<List<Achievement>> fetchAchievements() async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/api/achievements'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => Achievement.fromJson(json))
        .toList();
  }

  throw Exception(
    'Failed to load achievements: ${response.statusCode}',
  );
}

Future<Message> sendMessage({
  required String name,
  required String email,
  required String message,
}) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/messages'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'name': name,
      'email': email,
      'message': message,
    }),
  );

  if (response.statusCode == 200) {
    return Message.fromJson(
      jsonDecode(response.body),
    );
  }

  throw Exception(
    'Failed to send message: ${response.statusCode}',
  );
}

Future<AdminLoginResponse> adminLogin({
  required String username,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse('${ApiConfig.baseUrl}/api/auth/login'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'username': username,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    return AdminLoginResponse.fromJson(
      jsonDecode(response.body),
    );
  }

  if (response.statusCode == 401) {
    throw Exception('Invalid username or password');
  }

  throw Exception(
    'Login failed: ${response.statusCode}',
  );
}

}