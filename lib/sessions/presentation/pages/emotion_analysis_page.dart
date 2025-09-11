import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/network/dio_service.dart';
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
  const FramesAnalysisPage({super.key, required super.analysis})
    : super(title: 'Frame Analysis');

  @override
  Widget buildBody(BuildContext context) {
    return _FramesAnalysisContent(analysis: analysis);
  }
}

class _FramesAnalysisContent extends StatefulWidget {
  final EmotionAnalysisModel analysis;

  const _FramesAnalysisContent({required this.analysis});

  @override
  State<_FramesAnalysisContent> createState() => _FramesAnalysisContentState();
}

class _FramesAnalysisContentState extends State<_FramesAnalysisContent> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _frames = [];

  @override
  void initState() {
    super.initState();
    _fetchFramesData();
  }

  Future<void> _fetchFramesData() async {
    try {
      // Get the full URL from emotionAnalysisUrls
      final fullUrl = widget.analysis.emotionAnalysisUrls.frames;

      if (fullUrl.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Frames URL not found';
        });
        return;
      }

      // Backend already returns absolute API URLs; we can call them directly.
      final dioService = DioService();
      final response = await dioService.dioInstance.get(fullUrl);

      final data = response.data;
      List<dynamic> items;
      if (data is List) {
        items = data;
      } else if (data is Map && data['results'] is List) {
        items = List<dynamic>.from(data['results']);
      } else if (data is Map && data['data'] is List) {
        items = List<dynamic>.from(data['data']);
      } else if (data is Map && data.isNotEmpty) {
        items = [data];
      } else {
        items = const [];
      }
      setState(() {
        _frames = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading frame analysis data...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchFramesData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_frames.isEmpty) {
      return const Center(
        child: Text('No frame data available for this analysis.'),
      );
    }

    return _buildFramesTimeline(context);
  }

  Widget _buildFramesTimeline(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isNarrow = screenWidth < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _frames.length,
                  itemBuilder: (_, index) {
                    return _buildFrameCard(_frames[index], isNarrow);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frame-by-Frame Analysis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Analysis ID: ${widget.analysis.id}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Total Frames: ${_frames.length}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrameCard(dynamic frame, bool isNarrow) {
    final timestamp = (frame['timestamp'] as num).toDouble();
    final minutes = (timestamp ~/ 60).toString().padLeft(2, '0');
    final seconds = (timestamp % 60).toStringAsFixed(2).padLeft(5, '0');
    final timeFormatted = '$minutes:$seconds';

    String? formattedDate;
    if (frame['created_at'] != null) {
      try {
        final createdAt = DateTime.parse(frame['created_at'].toString());
        formattedDate = DateFormat('MMM d, yyyy HH:mm:ss').format(createdAt);
      } catch (_) {}
    }

    // Read all 7 emotions with safe defaults
    final Map<String, double> emotions = {
      'angry': (frame['angry'] as num?)?.toDouble() ?? 0.0,
      'disgust': (frame['disgust'] as num?)?.toDouble() ?? 0.0,
      'fear': (frame['fear'] as num?)?.toDouble() ?? 0.0,
      'happy': (frame['happy'] as num?)?.toDouble() ?? 0.0,
      'neutral': (frame['neutral'] as num?)?.toDouble() ?? 0.0,
      'sad': (frame['sad'] as num?)?.toDouble() ?? 0.0,
      'surprised': (frame['surprised'] as num?)?.toDouble() ?? 0.0,
    };

    String dominantEmotion = (frame['dominant_emotion'] as String?) ?? '';
    if (dominantEmotion.isEmpty) {
      dominantEmotion = emotions.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isNarrow
                  ? _buildNarrowFrameContent(
                      timeFormatted,
                      formattedDate,
                      emotions,
                      dominantEmotion,
                    )
                  : _buildWideFrameContent(
                      timeFormatted,
                      formattedDate,
                      emotions,
                      dominantEmotion,
                    ),
        ),
      ),
    );
  }

  Widget _buildNarrowFrameContent(
    String timeFormatted,
    String? formattedDate,
    Map<String, double> emotions,
    String dominantEmotion,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.timer, size: 16),
            const SizedBox(width: 8),
            Text(
              'Time: $timeFormatted',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (formattedDate != null)
          Text('Created: $formattedDate', style: const TextStyle(fontSize: 12)),
        const Divider(),
        const SizedBox(height: 8),
  ..._buildAllEmotionIndicators(emotions),
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              'Dominant: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildDominantEmotionChip(dominantEmotion),
          ],
        ),
      ],
    );
  }

  Widget _buildWideFrameContent(
  String timeFormatted,
  String? formattedDate,
  Map<String, double> emotions,
  String dominantEmotion,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Time: $timeFormatted',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (formattedDate != null)
                    Text(
                      'Created: $formattedDate',
                      style: const TextStyle(fontSize: 12),
                    ),
                ],
              ),
            ),
            _buildDominantEmotionChip(dominantEmotion),
          ],
        ),
        const Divider(),
        const SizedBox(height: 8),
        ..._buildAllEmotionIndicators(emotions, wide: true),
      ],
    );
  }

  Widget _buildEmotionIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const Spacer(),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildDominantEmotionChip(String emotion) {
    final chipColor = _emotionColor(emotion);

    return Chip(
      label: Text(
        emotion,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.all(0),
      visualDensity: VisualDensity.compact,
    );
  }

  // Build indicators for all 7 emotions
  List<Widget> _buildAllEmotionIndicators(
    Map<String, double> emotions, {
    bool wide = false,
  }) {
    const order = [
      'happy',
      'neutral',
      'sad',
      'angry',
      'surprised',
      'fear',
      'disgust',
    ];
    if (wide) {
      // Render in two rows of 3/4 for better use of width
      final rows = <Widget>[];
      final chunks = [order.sublist(0, 3), order.sublist(3)];
      for (final group in chunks) {
        rows.add(
          Row(
            children: group
                .map(
                  (k) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildEmotionIndicator(
                        _labelCase(k),
                        emotions[k] ?? 0.0,
                        _emotionColor(k),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
        rows.add(const SizedBox(height: 8));
      }
      if (rows.isNotEmpty) rows.removeLast();
      return rows;
    }
    // Narrow: vertical list
    return [
      for (final k in order) ...[
        _buildEmotionIndicator(_labelCase(k), emotions[k] ?? 0.0, _emotionColor(k)),
        const SizedBox(height: 8),
      ],
    ]..removeLast();
  }

  Color _emotionColor(String key) {
    switch (key.toLowerCase()) {
      case 'angry':
        return Colors.red;
      case 'disgust':
        return const Color(0xFF4CAF50); // Green
      case 'fear':
        return Colors.purple;
      case 'happy':
        return Colors.green; // Use green for happy bars
      case 'neutral':
        return Colors.grey;
      case 'sad':
        return Colors.blue;
      case 'surprised':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _labelCase(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}

class TimelineAnalysisPage extends EmotionAnalysisPage {
  const TimelineAnalysisPage({
    super.key,
    required super.analysis,
  }) : super(title: 'Timeline Analysis');

  @override
  Widget buildBody(BuildContext context) {
    return _TimelineAnalysisContent(analysis: analysis);
  }
}

class _TimelineAnalysisContent extends StatefulWidget {
  final EmotionAnalysisModel analysis;

  const _TimelineAnalysisContent({required this.analysis});

  @override
  State<_TimelineAnalysisContent> createState() =>
      _TimelineAnalysisContentState();
}

class _TimelineAnalysisContentState extends State<_TimelineAnalysisContent> {
  bool _isLoading = true;
  String _errorMessage = '';
  List<dynamic> _timelineData = [];

  @override
  void initState() {
    super.initState();
    _fetchTimelineData();
  }

  Future<void> _fetchTimelineData() async {
    try {
      // Get the full URL from emotionAnalysisUrls
      final fullUrl = widget.analysis.emotionAnalysisUrls.timeline;

      if (fullUrl.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Timeline URL not found';
        });
        return;
      }

      final dioService = DioService();
      final response = await dioService.dioInstance.get(fullUrl);

      final data = response.data;
      List<dynamic> items;
      if (data is List) {
        items = data;
      } else if (data is Map && data['results'] is List) {
        items = List<dynamic>.from(data['results']);
      } else if (data is Map && data['data'] is List) {
        items = List<dynamic>.from(data['data']);
      } else if (data is Map && data.isNotEmpty) {
        items = [data];
      } else {
        items = const [];
      }
      setState(() {
        _timelineData = items;
        _isLoading = false;
      });
  // Loaded timeline data
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
  // Error is surfaced to UI via _errorMessage
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading timeline analysis data...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_errorMessage),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchTimelineData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_timelineData.isEmpty) {
      return const Center(
        child: Text('No timeline data available for this analysis.'),
      );
    }

    return _buildEmotionTimeline();
  }

  Widget _buildEmotionTimeline() {
    // Sort the timeline data by timestamp/start_time to ensure chronological order
    int ts(dynamic item) {
      if (item is Map<String, dynamic>) {
        final v = item['timestamp'] ?? item['start_time'] ?? item['start'];
        if (v is num) return v.floor();
        if (v is String) {
          final d = double.tryParse(v);
          if (d != null) return d.floor();
        }
      }
      return 0;
    }
    _timelineData.sort((a, b) => ts(a).compareTo(ts(b)));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildTimelineView(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emotion Timeline Analysis',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Analysis ID: ${widget.analysis.id}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Data Points: ${_timelineData.length}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emotion Changes Over Time',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '${_timelineData.length} data points',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _timelineData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _buildEmotionCard(_timelineData[index], index);
          },
        ),
      ],
    );
  }

  Widget _buildEmotionCard(dynamic timelineItem, int index) {
    // Get emotion values for all 7 emotions
    final emotions = <String, double>{
      'angry': (timelineItem['angry'] as num?)?.toDouble() ?? 0.0,
      'disgust': (timelineItem['disgust'] as num?)?.toDouble() ?? 0.0,
      'fear': (timelineItem['fear'] as num?)?.toDouble() ?? 0.0,
      'happy': (timelineItem['happy'] as num?)?.toDouble() ?? 0.0,
      'neutral': (timelineItem['neutral'] as num?)?.toDouble() ?? 0.0,
      'sad': (timelineItem['sad'] as num?)?.toDouble() ?? 0.0,
      'surprised': (timelineItem['surprised'] as num?)?.toDouble() ?? 0.0,
    };
    final dominantEmotion = _getDominantEmotion(timelineItem);
    if (emotions.values.every((v) => v == 0.0) && dominantEmotion.isNotEmpty) {
      emotions[dominantEmotion.toLowerCase()] = 1.0;
    }

    // Format timestamp; prefer 'timestamp', else show start->end time
    String timeFormatted;
    if (timelineItem['timestamp'] != null) {
      final timestamp = (timelineItem['timestamp'] as num).toDouble();
      final minutes = (timestamp ~/ 60).toString().padLeft(2, '0');
      final seconds = (timestamp % 60).toStringAsFixed(2).padLeft(5, '0');
      timeFormatted = '$minutes:$seconds';
    } else if (timelineItem['start_time'] != null && timelineItem['end_time'] != null) {
      final start = (timelineItem['start_time'] as num).toDouble();
      final end = (timelineItem['end_time'] as num).toDouble();
      String fmt(double t) {
        final m = (t ~/ 60).toString().padLeft(2, '0');
        final s = (t % 60).toStringAsFixed(2).padLeft(5, '0');
        return '$m:$s';
      }
      timeFormatted = '${fmt(start)} → ${fmt(end)}';
    } else {
      timeFormatted = '—';
    }

    // Determine card border color based on dominant emotion
  final borderColor = _emotionColor(dominantEmotion);
  final emotionIcon = _emotionIcon(dominantEmotion);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: borderColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(emotionIcon, color: borderColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data Point ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'Time: $timeFormatted',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _buildDominantEmotionChip(dominantEmotion),
              ],
            ),
            const Divider(height: 24),
            ..._buildAllEmotionIndicators(emotions),
          ],
        ),
      ),
    );
  }

  String _getDominantEmotion(dynamic dataPoint) {
    String dominantEmotion = (dataPoint['dominant_emotion'] as String?) ?? '';
    if (dominantEmotion.isEmpty) {
      final emotions = <String, double>{
        'angry': (dataPoint['angry'] as num?)?.toDouble() ?? 0.0,
        'disgust': (dataPoint['disgust'] as num?)?.toDouble() ?? 0.0,
        'fear': (dataPoint['fear'] as num?)?.toDouble() ?? 0.0,
        'happy': (dataPoint['happy'] as num?)?.toDouble() ?? 0.0,
        'neutral': (dataPoint['neutral'] as num?)?.toDouble() ?? 0.0,
        'sad': (dataPoint['sad'] as num?)?.toDouble() ?? 0.0,
        'surprised': (dataPoint['surprised'] as num?)?.toDouble() ?? 0.0,
      };
      dominantEmotion = emotions.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }
    return dominantEmotion;
  }

  IconData _emotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'angry':
        return Icons.sentiment_very_dissatisfied;
      case 'disgust':
        return Icons.sick;
      case 'fear':
        return Icons.warning_amber;
      case 'happy':
        return Icons.sentiment_very_satisfied;
      case 'neutral':
        return Icons.sentiment_neutral;
      case 'sad':
        return Icons.sentiment_dissatisfied;
      case 'surprised':
        return Icons.help_outline;
      default:
        return Icons.face;
    }
  }

  Widget _buildEmotionIndicator(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            const Spacer(),
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildDominantEmotionChip(String emotion) {
    final chipColor = _emotionColor(emotion);

    return Chip(
      label: Text(
        emotion,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.all(0),
      visualDensity: VisualDensity.compact,
    );
  }

  // Build indicators for all 7 emotions for timeline cards
  List<Widget> _buildAllEmotionIndicators(
    Map<String, double> emotions, {
    bool wide = false,
  }) {
    const order = [
      'happy',
      'neutral',
      'sad',
      'angry',
      'surprised',
      'fear',
      'disgust',
    ];
    if (wide) {
      // Not used in timeline currently, but implemented for parity
      final rows = <Widget>[];
      final chunks = [order.sublist(0, 3), order.sublist(3)];
      for (final group in chunks) {
        rows.add(
          Row(
            children: group
                .map(
                  (k) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: _buildEmotionIndicator(
                        _labelCase(k),
                        emotions[k] ?? 0.0,
                        _emotionColor(k),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        );
        rows.add(const SizedBox(height: 8));
      }
      if (rows.isNotEmpty) rows.removeLast();
      return rows;
    }
    return [
      for (final k in order) ...[
        _buildEmotionIndicator(_labelCase(k), emotions[k] ?? 0.0, _emotionColor(k)),
        const SizedBox(height: 8),
      ],
    ]..removeLast();
  }

  Color _emotionColor(String key) {
    switch (key.toLowerCase()) {
      case 'angry':
        return Colors.red;
      case 'disgust':
        return const Color(0xFF4CAF50); // Green
      case 'fear':
        return Colors.purple;
      case 'happy':
        return Colors.green;
      case 'neutral':
        return Colors.grey;
      case 'sad':
        return Colors.blue;
      case 'surprised':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _labelCase(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}

class SummaryAnalysisPage extends EmotionAnalysisPage {
  const SummaryAnalysisPage({super.key, required super.analysis})
    : super(title: 'Summary Analysis');

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
          ],
        ),
      ),
    );
  }
}
