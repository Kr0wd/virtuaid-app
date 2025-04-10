import 'package:flutter/material.dart';
import '../../data/models/emotion_analysis_model.dart';

abstract class EmotionAnalysisPage extends StatelessWidget {
  final EmotionAnalysisModel analysis;
  final String title;

  const EmotionAnalysisPage({
    super.key,
    required this.analysis,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context);
}

class FramesAnalysisPage extends EmotionAnalysisPage {
  const FramesAnalysisPage({super.key, required EmotionAnalysisModel analysis})
    : super(analysis: analysis, title: 'Frame Analysis');

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Frame Analysis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Analysis ID: ${analysis.id}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const Text(
              'This page will display the detailed frame-by-frame emotion detection analysis.',
              textAlign: TextAlign.center,
            ),
            // You would add actual frame analysis content here
          ],
        ),
      ),
    );
  }
}

class TimelineAnalysisPage extends EmotionAnalysisPage {
  const TimelineAnalysisPage({
    super.key,
    required EmotionAnalysisModel analysis,
  }) : super(analysis: analysis, title: 'Timeline Analysis');

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timeline, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            Text(
              'Timeline Analysis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Analysis ID: ${analysis.id}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const Text(
              'This page will display the emotion changes over time during the session.',
              textAlign: TextAlign.center,
            ),
            // You would add actual timeline analysis content here
          ],
        ),
      ),
    );
  }
}

class SummaryAnalysisPage extends EmotionAnalysisPage {
  const SummaryAnalysisPage({super.key, required EmotionAnalysisModel analysis})
    : super(analysis: analysis, title: 'Summary Analysis');

  @override
  Widget buildBody(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.summarize, size: 64, color: Colors.green),
            const SizedBox(height: 16),
            Text(
              'Summary Analysis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Analysis ID: ${analysis.id}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            const Text(
              'This page will display the overall summary of emotions detected during the session.',
              textAlign: TextAlign.center,
            ),
            // You would add actual summary analysis content here
          ],
        ),
      ),
    );
  }
}
