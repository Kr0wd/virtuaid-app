import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/string_extensions.dart';
import '../../../residents/data/models/resident_model.dart';
import '../../../residents/data/repositories/resident_repository.dart';
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
        body: const _SessionsContent(),
      ),
    );
  }
}

class _SessionsContent extends StatefulWidget {
  const _SessionsContent();

  @override
  State<_SessionsContent> createState() => _SessionsContentState();
}

class _SessionsContentState extends State<_SessionsContent> {
  ResidentModel? selectedResident;
  List<ResidentModel> residents = [];
  bool isLoadingResidents = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadResidents();
  }

  Future<void> _loadResidents() async {
    setState(() {
      isLoadingResidents = true;
    });

    try {
      final residentRepository = context.read<ResidentRepository>();
      final residentResponse = await residentRepository.getResidents();

      setState(() {
        residents = residentResponse.results;
        isLoadingResidents = false;
      });
    } catch (e) {
      setState(() {
        isLoadingResidents = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load residents: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<ResidentModel> get filteredResidents {
    if (searchQuery.isEmpty) return residents;
    return residents
        .where(
          (resident) =>
              resident.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildResidentSelector(),
        Expanded(child: _SessionsList(selectedResident: selectedResident)),
      ],
    );
  }

  Widget _buildResidentSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search residents...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),
          isLoadingResidents
              ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              )
              : SizedBox(height: 50, child: _buildResidentList()),
        ],
      ),
    );
  }

  Widget _buildResidentList() {
    if (filteredResidents.isEmpty) {
      return const Center(child: Text('No residents found'));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        // Add "All Residents" option
        ChoiceChip(
          label: const Text('All Residents'),
          selected: selectedResident == null,
          onSelected: (_) {
            setState(() {
              selectedResident = null;
            });
          },
        ),
        const SizedBox(width: 8),
        ...filteredResidents.map((resident) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(resident.name),
              selected:
                  selectedResident?.id == resident.id && resident.id != null,
              onSelected: (_) {
                setState(() {
                  selectedResident = resident;
                });
              },
            ),
          );
        }).toList(),
      ],
    );
  }
}

class _SessionsList extends StatelessWidget {
  final ResidentModel? selectedResident;

  const _SessionsList({this.selectedResident});

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

        var sessions = state.sessionResponse.results;

        // Filter sessions by selected resident if any
        if (selectedResident != null && selectedResident!.id != null) {
          sessions =
              sessions
                  .where(
                    (session) =>
                        session.residentDetails.id == selectedResident!.id,
                  )
                  .toList();
        }

        if (sessions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  selectedResident == null
                      ? 'No sessions found'
                      : 'No sessions found for ${selectedResident!.name}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
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
