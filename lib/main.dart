import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_starter/authentication/presentation/pages/login_page.dart';
import 'package:flutter_starter/authentication/presentation/pages/signup_page.dart';
import 'package:flutter_starter/authentication/presentation/pages/splash_page.dart';
import 'package:flutter_starter/authentication/services/auth_dependencies.dart';
import 'package:flutter_starter/authentication/utils/stream_to_listenable.dart';
import 'package:flutter_starter/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter_starter/profile/presentation/pages/profile_page.dart';
import 'package:flutter_starter/settings/presentation/pages/settings_page.dart';
import 'package:flutter_starter/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/core/network/dio_service.dart';

void main() {
  final dioService = DioService();
  runApp(AuthDependencies(dioService: dioService, child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthenticationBloc>();

    final GoRouter router = GoRouter(
      initialLocation: AppRouter.splashPath,
      routes: [
        GoRoute(
          path: AppRouter.splashPath,
          name: AppRouteName.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: AppRouter.loginPath,
          name: AppRouteName.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRouter.homePath,
          name: AppRouteName.home,
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: AppRouter.signupPath,
          name: AppRouteName.signup,
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: AppRouter.profilePath,
          name: AppRouteName.profile,
          builder: (context, state) => const ProfilePage(),
        ),
        GoRoute(
          path: AppRouter.settingsPath,
          name: AppRouteName.settings,
          builder: (context, state) => const SettingsPage(),
        ),
      ],
      refreshListenable: StreamToListenable([authBloc.stream]),
      redirect: (context, state) {
        final isAuthenticated = authBloc.state is Authenticated;
        final isUnauthenticated = authBloc.state is Unauthenticated;

        if (isAuthenticated && state.matchedLocation == AppRouter.splashPath) {
          return AppRouter.homePath;
        }

        if (isUnauthenticated &&
            state.matchedLocation != AppRouter.loginPath &&
            state.matchedLocation != AppRouter.signupPath) {
          return AppRouter.loginPath;
        }

        if (isAuthenticated &&
            (state.matchedLocation == AppRouter.loginPath ||
                state.matchedLocation == AppRouter.signupPath)) {
          return AppRouter.homePath;
        }

        return null;
      },
    );

    return MaterialApp.router(
      title: 'GoRouter and Bloc Authentication Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
