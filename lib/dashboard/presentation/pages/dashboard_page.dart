import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:flutter_starter/residents/data/models/resident_response.dart';
import 'package:flutter_starter/residents/data/repositories/resident_repository_impl.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/resident_bloc.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/resident_event.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/resident_state.dart';
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
              ResidentBloc(ResidentRepositoryImpl(dioService))
                ..add(const ResidentEvent.fetchResidents()),
      child: const DashboardContent(),
    );
  }
}

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Create the bloc provider if it doesn't exist in the ancestor widgets
    ResidentBloc? bloc;
    try {
      bloc = context.read<ResidentBloc>();
    } catch (_) {
      // Bloc not found in widget tree
    }
    if (bloc == null) {
      final dioService = RepositoryProvider.of<DioService>(context);
      return BlocProvider(
        create:
            (context) =>
                ResidentBloc(ResidentRepositoryImpl(dioService))
                  ..add(const ResidentEvent.fetchResidents()),
        child: _buildContent(context),
      );
    }
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<ResidentBloc, ResidentState>(
      builder: (context, state) {
        return switch (state) {
          ResidentInitial() => const Center(child: CircularProgressIndicator()),
          ResidentLoading() => const Center(child: CircularProgressIndicator()),
          ResidentLoaded(:final data) => _buildDashboardContent(context, data),
          ResidentError(:final message) => _buildErrorContent(context, message),
        };
      },
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ResidentBloc>().add(
          const ResidentEvent.refreshResidents(),
        );
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
                    context.read<ResidentBloc>().add(
                      const ResidentEvent.fetchResidents(),
                    );
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

  Widget _buildDashboardContent(BuildContext context, ResidentResponse data) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ResidentBloc>().add(
          const ResidentEvent.refreshResidents(),
        );
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
            // Make insight cards responsive using a Wrap
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                Flexible(
                  child: _buildInsightCard(
                    title: 'Residents',
                    value: data.count.toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                Flexible(
                  child: _buildInsightCard(
                    title: 'Active Care Plans',
                    value: '${data.results.length}',
                    icon: Icons.healing,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Residents section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Residents',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => context.push(AppRouter.residentsPath),
                  icon: const Icon(Icons.visibility),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Residents list - show only a preview (limited number)
            data.results.isEmpty
                ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'No residents found. Add your first resident.',
                      ),
                    ),
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.results.length > 3 ? 3 : data.results.length,
                  itemBuilder: (context, index) {
                    final resident = data.results[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: const Icon(Icons.person, color: Colors.blue),
                        ),
                        title: Text(
                          resident.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('DOB: ${resident.dateOfBirth}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // Navigate to resident details page - to be implemented
                        },
                      ),
                    );
                  },
                ),

            // Remove the redundant "View all residents" button
            const SizedBox(height: 24),

            const Text(
              'Quick Access',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Replace GridView.count with a responsive LayoutBuilder
            LayoutBuilder(
              builder: (context, constraints) {
                // Calculate number of columns based on available width
                // For smaller screens use fewer columns
                final double availableWidth = constraints.maxWidth;
                final int crossAxisCount = availableWidth < 400 ? 2 : 3;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    // Adjust aspect ratio to avoid overflow with larger text
                    childAspectRatio: availableWidth < 400 ? 1.2 : 1.1,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final items = [
                      {
                        'title': 'Sessions',
                        'icon': Icons.calendar_today,
                        'color': Colors.indigo,
                        'onTap': () => context.push(AppRouter.sessionsPath),
                      },
                      {
                        'title': 'Appointments',
                        'icon': Icons.schedule,
                        'color': Colors.orange,
                        'onTap': () => context.push(AppRouter.appointmentsPath),
                      },
                      {
                        'title': 'Feedbacks',
                        'icon': Icons.feedback,
                        'color': Colors.purple,
                        'onTap': () => context.push(AppRouter.feedbacksPath),
                      },
                    ];
                    final item = items[index];
                    return _buildQuickAccessTile(
                      context,
                      item['title'] as String,
                      item['icon'] as IconData,
                      item['color'] as Color,
                      item['onTap'] as VoidCallback,
                    );
                  },
                );
              },
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
