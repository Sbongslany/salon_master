import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:salon_master/presentation/blocs/auth/auth_bloc.dart';

import '../../core/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              // Instagram logo placeholder
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontFamily: 'Billabong', // Use a font similar to Instagram if available
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
                        labelText: 'Phone number, email or username',
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
                    const SizedBox(height: 20),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is AuthSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Login successful: ${state.authResponse.user.name}')),
                          );
                          context.go('/home');
                        } else if (state is AuthFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const CircularProgressIndicator(color: Color(0xFF405DE6));
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please enter both email and password')),
                                );
                                return;
                              }
                              context.read<AuthBloc>().add(
                                LoginEvent(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF405DE6),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: Colors.black54)),
                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Color(0xFF405DE6), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'OR',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.facebook, color: Color(0xFF405DE6)),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Placeholder for Facebook login
                    },
                    child: const Text(
                      'Log in with Facebook',
                      style: TextStyle(color: Color(0xFF405DE6), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Forgot password?',
                style: TextStyle(color: Color(0xFF405DE6)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}