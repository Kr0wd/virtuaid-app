import 'package:flutter/material.dart';
import 'package:flutter_starter/residents/data/models/resident_model.dart';
import '../../bloc/access_report_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;
import '../util/pdf_opener.dart';

class AccessReportPage extends StatefulWidget {
  final ResidentModel resident;
  const AccessReportPage({super.key, required this.resident});

  @override
  State<AccessReportPage> createState() => _AccessReportPageState();
}

class _AccessReportPageState extends State<AccessReportPage> {
  DateTime? startDate;
  DateTime? endDate;
  bool loading = false;

  Future<void> _openPdf(String url) async {
    // Try external app first
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (ok) return;
      }
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening with device viewer...')),
    );

    final filename = () {
      try {
        final last = Uri.parse(url).pathSegments.isNotEmpty
            ? Uri.parse(url).pathSegments.last
            : 'report.pdf';
        return p.basename(last).split('?').first;
      } catch (_) {
        return 'report.pdf';
      }
    }();

    final ok = await PdfOpener.downloadAndOpen(url, filename: filename);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open PDF. Please install a PDF viewer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Activity Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reports for Resident', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(widget.resident.name),
                subtitle: Text('DOB: ${widget.resident.dateOfBirth}'),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Start Date'),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => startDate = picked);
                    },
                    controller: TextEditingController(text: startDate != null ? '${startDate!.day}/${startDate!.month}/${startDate!.year}' : ''),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'End Date'),
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) setState(() => endDate = picked);
                    },
                    controller: TextEditingController(text: endDate != null ? '${endDate!.day}/${endDate!.month}/${endDate!.year}' : ''),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loading || startDate == null || endDate == null
                  ? null
                  : () async {
                      setState(() => loading = true);
                      try {
                        await context.read<AccessReportCubit>().fetchReports(
                          residentId: widget.resident.id ?? '',
                          start: startDate!,
                          end: endDate!,
                        );
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to load reports: $e')),
                          );
                        }
                      } finally {
                        if (mounted) setState(() => loading = false);
                      }
                    },
              child: const Text('Get Reports'),
            ),
            const SizedBox(height: 24),
            Text('Report Records', style: Theme.of(context).textTheme.titleLarge),
            // Reports list
            Expanded(
              child: BlocBuilder<AccessReportCubit, AccessReportState>(
                builder: (context, state) {
                  if (state is AccessReportLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is AccessReportLoaded) {
                    final reports = state.reports;
                    if (reports.isEmpty) {
                      return const Center(child: Text('No reports found'));
                    }
                    return ListView.separated(
                      itemCount: reports.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final report = reports[index];
                        final dateStr = DateFormat('dd MMM yyyy').format(report.date);
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  dense: false,
                                  leading: const Icon(Icons.description_outlined),
                                  title: const Text('Report'),
                                  subtitle: Text('Date: $dateStr'),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                ),
                                const SizedBox(height: 4),
                                OverflowBar(
                                  alignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: null, // placeholder
                                      child: const Text('Generate AI Summary'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _openPdf(report.pdfUrl);
                                      },
                                      child: const Text('View Report'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  if (state is AccessReportError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const Center(child: Text('Pick dates and tap Get Reports'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
