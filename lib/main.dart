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
import 'package:flutter_starter/residents/presentation/pages/residents_page.dart';
import 'package:flutter_starter/residents/presentation/pages/new_resident_page.dart';
import 'package:flutter_starter/appointments/presentation/pages/appointments_page.dart';
import 'package:flutter_starter/sessions/presentation/pages/sessions_page.dart';
import 'package:flutter_starter/feedbacks/presentation/pages/feedbacks_page.dart';
import 'package:flutter_starter/feedbacks/presentation/pages/new_feedback_page.dart';
import 'package:flutter_starter/core/theme/app_theme.dart';

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
        // New routes
        GoRoute(
          path: AppRouter.residentsPath,
          name: AppRouteName.residents,
          builder: (context, state) => const ResidentsPage(),
        ),
        GoRoute(
          path: AppRouter.newResidentPath,
          name: AppRouteName.newResident,
          builder: (context, state) => const NewResidentPage(),
        ),
        GoRoute(
          path: AppRouter.appointmentsPath,
          name: AppRouteName.appointments,
          builder: (context, state) => const AppointmentsPage(),
        ),
        GoRoute(
          path: AppRouter.sessionsPath,
          name: AppRouteName.sessions,
          builder: (context, state) => const SessionsPage(),
        ),
        GoRoute(
          path: AppRouter.feedbacksPath,
          name: AppRouteName.feedbacks,
          builder: (context, state) => const FeedbacksPage(),
        ),
        GoRoute(
          path: AppRouter.newFeedbackPath,
          name: AppRouteName.newFeedback,
          builder: (context, state) => const NewFeedbackPage(),
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
      theme: AppTheme.lightTheme,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
