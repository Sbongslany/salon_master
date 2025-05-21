import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String password; // Added password field
  final String role;
  final String address;
  final CoordinatesModel coordinates;
  final String phoneNumber;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.address,
    required this.coordinates,
    required this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '', // Handle password from API if returned
      role: json['role'] as String? ?? '',
      address: json['address'] as String? ?? '',
      coordinates: CoordinatesModel.fromJson(json['coordinates'] ?? {'lat': 0.0, 'lng': 0.0}),
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password, // Include password in registration payload
      'role': role,
      'address': address,
      'coordinates': coordinates.toJson(),
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [id, name, email, password, role, address, coordinates, phoneNumber];
}

class CoordinatesModel extends Equatable {
  final double lat;
  final double lng;

  const CoordinatesModel({required this.lat, required this.lng});

  factory CoordinatesModel.fromJson(Map<String, dynamic> json) {
    return CoordinatesModel(
      lat: (json['lat'] as num? ?? 0.0).toDouble(),
      lng: (json['lng'] as num? ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }

  @override
  List<Object?> get props => [lat, lng];
}