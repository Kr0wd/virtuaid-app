import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/string_extensions.dart';
import '../../data/models/session_model.dart';
import '../../data/repositories/session_repository.dart';
import '../bloc/sessions_bloc.dart';
import '../pages/video_analysis_page.dart';

class SessionDetailsPage extends StatefulWidget {
  final SessionModel session;

  const SessionDetailsPage({super.key, required this.session});

  @override
  State<SessionDetailsPage> createState() => _SessionDetailsPageState();
}

class _SessionDetailsPageState extends State<SessionDetailsPage> {
  final _notesController = TextEditingController();
  bool _isEditingNotes = false;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.session.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create a local BlocProvider for this page
    return BlocProvider(
      // Use the repository that's already provided at the app level
      create: (context) => SessionsBloc(context.read<SessionRepository>()),
      child: Builder(
        builder: (context) {
          // This context now has access to the local SessionsBloc
          return _buildContent(context);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    context.read<SessionsBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
        actions: [_buildStatusButton(context)],
      ),
      body: BlocConsumer<SessionsBloc, SessionsState>(
        listener: (context, state) {
          if (state is SessionUpdateSuccess) {
            // Find the updated session in the results
            final updatedSession = state.updatedSession;

            // Update the notes controller if notes were updated
            if (_notesController.text != updatedSession.notes) {
              _notesController.text = updatedSession.notes ?? '';
            }

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Session updated successfully')),
            );

            // Exit edit mode
            if (_isEditingNotes) {
              setState(() {
                _isEditingNotes = false;
              });
            }
          } else if (state is SessionUpdateError) {
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Use the original session model as the base
          SessionModel currentSession = widget.session;

          if (state is SessionUpdateSuccess) {
            // Use the updated session from the success state
            currentSession = state.updatedSession;
          } else if (state is SessionUpdateLoading &&
              state.updatingSessionId == widget.session.id) {
            // Show loading indicator for the specific session
            return const Center(child: CircularProgressIndicator());
          }

          final scheduledDate = DateTime.parse(currentSession.scheduledDate);
          final formattedDate = DateFormat(
            'MMMM d, yyyy',
          ).format(scheduledDate);
          final formattedTime = DateFormat('h:mm a').format(scheduledDate);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(
                  title: 'Resident Information',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSession.residentDetails.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.cake,
                        'Date of Birth: ${DateFormat('MMMM d, yyyy').format(DateTime.parse(currentSession.residentDetails.dateOfBirth))}',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.apartment,
                        'Care Home: ${currentSession.residentDetails.careHome.name}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoCard(
                  title: 'Session Information',
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Date: $formattedDate',
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.access_time, 'Time: $formattedTime'),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildInfoIcon(Icons.info_outline),
                          const SizedBox(width: 8),
                          Text('Status: '),
                          const SizedBox(width: 4),
                          _buildStatusChip(currentSession.status),
                        ],
                      ),
                      if (currentSession.endTime != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          Icons.timer_off,
                          'End Time: ${DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(currentSession.endTime!))}',
                        ),
                      ],
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.feedback,
                        'Feedback Status: ${currentSession.feedbackStatus}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildNotesSection(context, currentSession),
                const SizedBox(height: 16),
                _buildAnalyzeEmotionButton(context, currentSession),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildInfoIcon(icon),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    );
  }

  Widget _buildInfoIcon(IconData icon) {
    return Icon(icon, size: 18, color: Colors.grey[600]);
  }

  Widget _buildInfoCard({required String title, required Widget content}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Divider(height: 24),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context, SessionModel session) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                if (!_isEditingNotes)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    tooltip: 'Edit Notes',
                    onPressed: () {
                      setState(() {
                        _isEditingNotes = true;
                      });
                    },
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        tooltip: 'Cancel',
                        onPressed: () {
                          setState(() {
                            _isEditingNotes = false;
                            _notesController.text = session.notes ?? '';
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.save, color: Colors.green),
                        tooltip: 'Save Notes',
                        onPressed: () {
                          context.read<SessionsBloc>().add(
                            UpdateSessionNotes(
                              sessionId: session.id,
                              notes: _notesController.text,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
            const Divider(height: 24),
            if (_isEditingNotes)
              TextField(
                controller: _notesController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Enter session notes here...',
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  session.notes?.isNotEmpty == true
                      ? session.notes!
                      : 'No notes available.',
                  style:
                      session.notes?.isEmpty == true
                          ? const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          )
                          : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzeEmotionButton(
    BuildContext context,
    SessionModel session,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.video_camera_front),
        label: const Text('Analyze Emotion'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoAnalysisPage(session: session),
            ),
          );
        },
      ),
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
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      backgroundColor: chipColor,
      avatar: Icon(statusIcon, color: Colors.white, size: 16),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildStatusButton(BuildContext context) {
    return BlocBuilder<SessionsBloc, SessionsState>(
      builder: (context, state) {
        // Determine current session status
        String currentStatus = widget.session.status;

        if (state is SessionUpdateSuccess) {
          currentStatus = state.updatedSession.status;
        }

        return PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          tooltip: 'Change Status',
          onSelected: (String newStatus) {
            if (newStatus != currentStatus) {
              context.read<SessionsBloc>().add(
                UpdateSessionStatus(
                  sessionId: widget.session.id,
                  status: newStatus,
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuEntry<String>>[
              _buildStatusMenuItem(
                'scheduled',
                'Scheduled',
                Icons.schedule,
                Colors.blue,
                isDisabled:
                    currentStatus == 'completed' ||
                    currentStatus == 'cancelled',
              ),
              _buildStatusMenuItem(
                'in_progress',
                'In Progress',
                Icons.play_circle_fill,
                Colors.orange,
                isDisabled:
                    currentStatus == 'completed' ||
                    currentStatus == 'cancelled',
              ),
              _buildStatusMenuItem(
                'completed',
                'Completed',
                Icons.check_circle,
                Colors.green,
                isDisabled: currentStatus == 'cancelled',
              ),
              _buildStatusMenuItem(
                'cancelled',
                'Cancelled',
                Icons.cancel,
                Colors.red,
              ),
            ];
          },
        );
      },
    );
  }

  PopupMenuItem<String> _buildStatusMenuItem(
    String value,
    String text,
    IconData icon,
    Color color, {
    bool isDisabled = false,
  }) {
    return PopupMenuItem<String>(
      value: value,
      enabled: !isDisabled,
      child: Row(
        children: [
          Icon(icon, color: isDisabled ? Colors.grey : color),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              color: isDisabled ? Colors.grey : null,
              fontWeight: isDisabled ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
