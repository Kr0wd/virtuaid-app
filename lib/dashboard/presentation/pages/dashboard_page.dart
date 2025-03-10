import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:flutter_starter/dashboard/data/models/associates_response.dart';
import 'package:flutter_starter/dashboard/data/repositories/associates_repository_impl.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_bloc.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_event.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_state.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get DioService from RepositoryProvider
    final dioService = RepositoryProvider.of<DioService>(context);

    return BlocProvider(
      create:
          (context) => AssociatesBloc(
            // Use the repository implementation
            AssociatesRepositoryImpl(dioService),
          )..add(const FetchAssociates()),
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          if (authState is Authenticated) {
            final user = authState.auth.user;

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
                                    onPressed:
                                        () => Navigator.of(context).pop(),
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
              body: const DashboardContent(),
            );
          }

          return const Scaffold(
            body: Center(child: Text('Please log in to view your dashboard')),
          );
        },
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssociatesBloc, AssociatesState>(
      builder: (context, state) {
        if (state is AssociatesInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AssociatesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AssociatesLoaded) {
          return _buildDashboardContent(context, state.data);
        } else if (state is AssociatesError) {
          return _buildErrorContent(context, state.message);
        } else {
          return const Center(child: Text('Unknown state'));
        }
      },
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AssociatesBloc>().add(const RefreshAssociates());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 16),
                Text(
                  'Error loading dashboard data',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AssociatesBloc>().add(const FetchAssociates());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, AssociatesResponse data) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AssociatesBloc>().add(const RefreshAssociates());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Care Home Insights',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInsightCard(
              title: 'Residents',
              value: data.count.toString(),
              icon: Icons.people,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildInsightCard(
              title: 'Active Care Plans',
              value: '${data.results.length}',
              icon: Icons.healing,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Activity',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    data.results.isEmpty
                        ? const Center(
                          child: Text(
                            'No recent activity to display',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        )
                        : const Text(
                          'Latest resident updates would appear here',
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
