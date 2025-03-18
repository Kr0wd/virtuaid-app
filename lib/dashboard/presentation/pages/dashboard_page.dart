import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:flutter_starter/dashboard/data/models/associates_response.dart';
import 'package:flutter_starter/dashboard/data/repositories/associates_repository_impl.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_bloc.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_event.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/associates_state.dart';
import 'package:flutter_starter/routes.dart';
import 'package:go_router/go_router.dart';

// Keep this class for backward compatibility but make it use DashboardContent
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dioService = RepositoryProvider.of<DioService>(context);

    return BlocProvider(
      create:
          (context) =>
              AssociatesBloc(AssociatesRepositoryImpl(dioService))
                ..add(const FetchAssociates()),
      child: const DashboardContent(),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the bloc provider if it doesn't exist in the ancestor widgets
    // Fix: Replace nullOk parameter with safer approach
    AssociatesBloc? bloc;
    try {
      bloc = context.read<AssociatesBloc>();
    } catch (_) {
      // Bloc not found in widget tree
    }

    if (bloc == null) {
      final dioService = RepositoryProvider.of<DioService>(context);
      return BlocProvider(
        create:
            (context) =>
                AssociatesBloc(AssociatesRepositoryImpl(dioService))
                  ..add(const FetchAssociates()),
        child: _buildContent(context),
      );
    }

    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
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
            const Text(
              'Quick Access',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                _buildQuickAccessTile(
                  context,
                  'Sessions',
                  Icons.calendar_today,
                  Colors.indigo,
                  () => context.push(AppRouter.sessionsPath),
                ),
                _buildQuickAccessTile(
                  context,
                  'Appointments',
                  Icons.schedule,
                  Colors.orange,
                  () => context.push(AppRouter.appointmentsPath),
                ),
                _buildQuickAccessTile(
                  context,
                  'Feedbacks',
                  Icons.feedback,
                  Colors.purple,
                  () => context.push(AppRouter.feedbacksPath),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
