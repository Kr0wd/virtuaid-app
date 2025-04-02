import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/residents/data/repositories/resident_repository_impl.dart';
import 'package:flutter_starter/residents/data/repositories/resident_repository.dart';

import '../../core/network/dio_service.dart';
import '../bloc/authentication_bloc.dart';
import 'auth_service.dart';

class AuthDependencies extends StatelessWidget {
  final Widget child;
  final DioService dioService;

  const AuthDependencies({
    super.key,
    required this.child,
    required this.dioService,
  });

  @override
  Widget build(BuildContext context) {
    final tokenService = dioService.tokenService;
    final authService = AuthService(dioService.dioInstance, tokenService);

    return MultiRepositoryProvider(
      providers: [
        // Provide DioService
        RepositoryProvider<DioService>.value(value: dioService),

        // Provide ResidentRepository
        RepositoryProvider<ResidentRepository>(
          create: (context) => ResidentRepositoryImpl(dioService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) {
              final authBloc = AuthenticationBloc(authService)
                ..add(AuthenticationStatusChecked());
              dioService.setAuthBloc(authBloc);
              return authBloc;
            },
          ),
        ],
        child: child,
      ),
    );
  }
}
