import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:salon_master/data/models/user_model.dart';
import 'package:salon_master/presentation/blocs/auth/auth_bloc.dart';

import '../../core/constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  CoordinatesModel _coordinates = const CoordinatesModel(lat: 0, lng: 0);
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchAddress(String address) async {
    try {
      final autocompleteUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json'
            '?input=$address'
            '&components=country:za'
            '&key=${AppConstants.googleApiKey}',
      );
      final autocompleteResponse = await http.get(autocompleteUrl);
      if (autocompleteResponse.statusCode != 200) {
        throw Exception('Failed to fetch autocomplete suggestions: ${autocompleteResponse.statusCode}');
      }

      final autocompleteJson = jsonDecode(autocompleteResponse.body);
      if (autocompleteJson['status'] != 'OK') {
        throw Exception('Autocomplete API error: ${autocompleteJson['status']}');
      }

      final predictions = autocompleteJson['predictions'] as List<dynamic>;
      if (predictions.isEmpty) {
        throw Exception('No address suggestions found');
      }

      final placeId = predictions.first['place_id'] as String;

      final detailsUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
            '?place_id=$placeId'
            '&fields=geometry'
            '&key=${AppConstants.googleApiKey}',
      );
      final detailsResponse = await http.get(detailsUrl);
      if (detailsResponse.statusCode != 200) {
        throw Exception('Failed to fetch place details: ${detailsResponse.statusCode}');
      }

      final detailsJson = jsonDecode(detailsResponse.body);
      if (detailsJson['status'] != 'OK') {
        throw Exception('Place Details API error: ${detailsJson['status']}');
      }

      final location = detailsJson['result']['geometry']['location'];
      final lat = location['lat'] as double;
      final lng = location['lng'] as double;

      final placemarks = await placemarkFromCoordinates(lat, lng);
      setState(() {
        _addressController.text = placemarks.isNotEmpty ? placemarks.first.street ?? address : address;
        _coordinates = CoordinatesModel(lat: lat, lng: lng);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching address: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Instagram logo placeholder
                 Text(
                  '$AppConstants.appName',
                  style: TextStyle(
                    fontFamily: 'Billabong',
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF405DE6),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        onChanged: (value) => _searchAddress(value),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_nameController.text.isEmpty || _emailController.text.isEmpty ||
                                _passwordController.text.isEmpty || _addressController.text.isEmpty ||
                                _phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all fields')),
                              );
                              return;
                            }
                            final user = UserModel(
                              id: DateTime.now().toString(),
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              role: 'client',
                              address: _addressController.text,
                              coordinates: _coordinates,
                              phoneNumber: _phoneController.text,
                            );
                            context.read<AuthBloc>().add(RegisterEvent(user));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF405DE6),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Have an account? ", style: TextStyle(color: Colors.black54)),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: const Text(
                        'Log in',
                        style: TextStyle(color: Color(0xFF405DE6), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}