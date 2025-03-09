import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/authentication/bloc/authentication_bloc.dart';

class GoogleSignInButton extends StatelessWidget {
  final bool isLoading;

  const GoogleSignInButton({super.key, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.g_mobiledata, size: 24.0, color: Colors.red),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      onPressed:
          isLoading
              ? null
              : () {
                context.read<AuthenticationBloc>().add(GoogleSignIn());
              },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        side: const BorderSide(color: Colors.grey),
      ),
    );
  }
}
