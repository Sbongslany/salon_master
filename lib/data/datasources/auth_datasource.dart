import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon_master/data/models/auth_response_model.dart';
import 'package:salon_master/data/models/user_model.dart';

import '../../core/constants.dart';

abstract class AuthDataSource {
  Future<AuthResponseModel> login(String email, String password);
  Future<AuthResponseModel> register(UserModel user);
}

class AuthDataSourceImpl implements AuthDataSource {
  final String baseUrl = AppConstants.apiBaseUrl;

  @override
  Future<AuthResponseModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null || data is! Map<String, dynamic>) {
        throw Exception('Invalid response format from login API');
      }
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }

  @override
  Future<AuthResponseModel> register(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'password': user.password, // Use the password from UserModel
        'role': user.role,
        'address': user.address,
        'coordinates': {'lat': user.coordinates.lat, 'lng': user.coordinates.lng},
        'phoneNumber': user.phoneNumber,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
    }
  }
}