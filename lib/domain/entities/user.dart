import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String role;
  final String address;
  final Coordinates coordinates;
  final String phoneNumber;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.coordinates,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [id, name, email, role, address, coordinates, phoneNumber];
}

class Coordinates extends Equatable {
  final double lat;
  final double lng;

  const Coordinates({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}