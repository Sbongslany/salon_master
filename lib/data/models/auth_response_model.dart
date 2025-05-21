import 'package:equatable/equatable.dart';
import 'package:salon_master/data/models/user_model.dart';

class AuthResponseModel extends Equatable {
  final String token;
  final UserModel user;

  const AuthResponseModel({required this.token, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String? ?? ''; // Default to empty string if null
    if (token.isEmpty) {
      throw Exception('Token is missing or invalid in API response');
    }

    final userJson = json['user'];
    if (userJson == null || userJson is! Map<String, dynamic>) {
      throw Exception('User data is missing or invalid in API response');
    }
    final user = UserModel.fromJson(userJson);

    return AuthResponseModel(
      token: token,
      user: user,
    );
  }

  @override
  List<Object?> get props => [token, user];
}