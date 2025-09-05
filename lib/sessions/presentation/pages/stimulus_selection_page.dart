import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'reaction_recording_page.dart';
import '../../data/models/session_model.dart';

class StimulusVideo {
  final int id;
  final String title;
  final String url; // dummy
  final Duration? duration;
  StimulusVideo({
    required this.id,
    required this.title,
    required this.url,
    this.duration,
  });
}

class StimulusSelectionPage extends StatelessWidget {
  final SessionModel session;
  StimulusSelectionPage({super.key, required this.session});

  final _dummy = <StimulusVideo>[
    StimulusVideo(
      id: 1,
      title: 'Stimulus 1 (5s)',
      url: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
    ),
    StimulusVideo(
      id: 2,
      title: 'Stimulus 2 (10s)',
      url: 'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
    ),
    StimulusVideo(
      id: 3,
      title: 'Stimulus 3 (15s)',
      url: 'https://samplelib.com/lib/preview/mp4/sample-15s.mp4',
    ),
    StimulusVideo(
      id: 4,
      title: 'Stimulus 4 (30s)',
      url: 'https://samplelib.com/lib/preview/mp4/sample-30s.mp4',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Stimuli (Unsupported on Web)')),
        body: const Center(
          child: Text('Live reaction recording not supported on web yet.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Select Stimulus')),
      body: ListView.separated(
        itemCount: _dummy.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = _dummy[index];
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.url),
              trailing: const Icon(Icons.play_arrow),
              onTap: () async {
                final recorded =
                    await Navigator.push<Map<String, dynamic>?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReactionRecordingPage(stimulus: item),
                  ),
                );
                if (recorded != null && recorded['file'] != null) {
                  Navigator.pop(context, {
                    'file': recorded['file'] as File,
                    'stimulusTitle': item.title,
                  });
                }
              },
            );
        },
      ),
    );
  }
}