import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/string_extensions.dart';
import '../bloc/sessions_bloc.dart';
import 'session_details_page.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SessionsBloc(context.read())..add(const FetchSessions()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Therapy Sessions')),
        body: _SessionsList(),
      ),
    );
  }
}

class _SessionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsBloc, SessionsState>(
      builder: (context, state) {
        if (state is SessionsInitial || state is SessionsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SessionsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<SessionsBloc>().add(const FetchSessions());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is! SessionsLoaded) {
          return const Center(child: Text('Something went wrong'));
        }

        final sessions = state.sessionResponse.results;

        if (sessions.isEmpty) {
          return const Center(child: Text('No sessions found'));
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<SessionsBloc>().add(const FetchSessions());
          },
          child: ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final scheduledDate = DateTime.parse(session.scheduledDate);
              final formattedDate = DateFormat(
                'MMMM d, yyyy',
              ).format(scheduledDate);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(
                    'Session with ${session.residentDetails.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Date: $formattedDate',
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 8),
                          Text('Status: '),
                          const SizedBox(width: 4),
                          _buildStatusChip(session.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        Icons.apartment,
                        'Care Home: ${session.residentDetails.careHome.name}',
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  trailing:
                      state is SessionUpdateLoading &&
                              state.updatingSessionId == session.id
                          ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Icon(Icons.chevron_right),
                  onTap: () {
                    // Navigate to session details using go_router
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => SessionDetailsPage(session: session),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    IconData statusIcon;

    switch (status) {
      case 'scheduled':
        chipColor = Colors.blue;
        statusIcon = Icons.schedule;
      case 'in_progress':
        chipColor = Colors.orange;
        statusIcon = Icons.play_circle_fill;
      case 'completed':
        chipColor = Colors.green;
        statusIcon = Icons.check_circle;
      case 'cancelled':
        chipColor = Colors.red;
        statusIcon = Icons.cancel;
      default:
        chipColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Chip(
      label: Text(
        status.replaceAll('_', ' ').capitalize(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      avatar: Icon(statusIcon, color: Colors.white, size: 16),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }
}
