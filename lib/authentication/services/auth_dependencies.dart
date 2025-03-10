import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      providers: [RepositoryProvider<DioService>.value(value: dioService)],
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
