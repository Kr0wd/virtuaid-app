import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/residents/data/models/resident_response.dart';
import 'package:flutter_starter/residents/data/repositories/resident_repository.dart';
import 'package:flutter_starter/access_report/bloc/access_report_cubit.dart';
import 'package:flutter_starter/access_report/domain/access_report_repository.dart';
import 'access_report_page.dart';

class ResidentSearchPage extends StatefulWidget {
  const ResidentSearchPage({super.key});

  @override
  State<ResidentSearchPage> createState() => _ResidentSearchPageState();
}

class _ResidentSearchPageState extends State<ResidentSearchPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  ResidentResponse? _data;
  bool _loading = false;

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = context.read<ResidentRepository>();
      final res = await repo.getResidents();
      setState(() => _data = res);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load residents: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final list = _data?.results ?? [];
    final query = _searchCtrl.text.toLowerCase();
    final filtered = list.where((r) => r.name.toLowerCase().contains(query)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a Resident')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final res = filtered[index];
                        return ListTile(
                          leading: const Icon(Icons.person_outline),
                          title: Text(res.name),
                          subtitle: Text('DOB: ${res.dateOfBirth}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            final accessRepo = context.read<AccessReportRepository>();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => AccessReportCubit(accessRepo),
                                  child: AccessReportPage(resident: res),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
