import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/authentication/bloc/authentication_bloc.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          final user = state.auth.user;

          return Scaffold(
            appBar: AppBar(title: const Text('Dashboard')),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      user.name.isNotEmpty ? user.name : user.username,
                    ),
                    accountEmail: Text(user.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage:
                          user.avatar != null
                              ? NetworkImage(user.avatar!)
                              : null,
                      child:
                          user.avatar == null
                              ? Text(
                                user.name.isNotEmpty
                                    ? user.name[0].toUpperCase()
                                    : user.username[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : null,
                    ),
                    arrowColor: Colors.transparent,
                    onDetailsPressed: null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/profile');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/settings');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Logout'),
                              content: const Text(
                                'Are you sure you want to log out?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    context.read<AuthenticationBloc>().add(
                                      LoggedOut(),
                                    );
                                  },
                                  child: const Text('Logout'),
                                ),
                              ],
                            ),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.dashboard_customize,
                    size: 80,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome back, ${user.name.isNotEmpty ? user.name : user.username}!',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your dashboard is ready',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.person),
                    label: const Text('View Profile'),
                    onPressed: () {
                      context.push('/profile');
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Please log in to view your dashboard')),
        );
      },
    );
  }
}
