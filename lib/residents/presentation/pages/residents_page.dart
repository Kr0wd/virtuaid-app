import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/core/network/dio_service.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/resident_bloc.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/resident_event.dart';
import 'package:flutter_starter/dashboard/presentation/bloc/resident_state.dart';
import 'package:flutter_starter/residents/data/repositories/resident_repository_impl.dart';
import 'package:flutter_starter/routes.dart';

class ResidentsPage extends StatelessWidget {
  const ResidentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove appBar as it's already provided by MainShellPage
      body: const ResidentsContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.newResidentPath),
        tooltip: 'Add New Resident',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

class ResidentsContent extends StatelessWidget {
  const ResidentsContent({super.key});

  @override
  Widget build(BuildContext context) {
    ResidentBloc? bloc;
    try {
      bloc = context.read<ResidentBloc>();
    } catch (_) {}

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
          ResidentLoaded(:final data) => _buildResidentsList(
            context,
            data.results,
          ),
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
                  'Error loading residents',
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

  Widget _buildResidentsList(BuildContext context, List residents) {
    if (residents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No residents found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Add your first resident to get started'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push(AppRouter.newResidentPath),
              icon: const Icon(Icons.add),
              label: const Text('Add Resident'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ResidentBloc>().add(
          const ResidentEvent.refreshResidents(),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: residents.length,
        itemBuilder: (context, index) {
          final resident = residents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              leading: Hero(
                tag: 'resident-avatar-${resident.name}',
                child: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  radius: 28,
                  child: const Icon(Icons.person, color: Colors.blue, size: 32),
                ),
              ),
              title: Text(
                resident.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Date of Birth: ${resident.dateOfBirth}'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to resident details
              },
            ),
          );
        },
      ),
    );
  }
}
