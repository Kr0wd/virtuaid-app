import 'package:flutter/material.dart';
import '../../../core/network/dio_service.dart';
import '../../data/models/emotion_analysis_model.dart';

class FrameAnalysisPage extends StatefulWidget {
  final EmotionAnalysisModel analysis;

  const FrameAnalysisPage({super.key, required this.analysis});

  @override
  State<FrameAnalysisPage> createState() => _FrameAnalysisPageState();
}

class _FrameAnalysisPageState extends State<FrameAnalysisPage> {
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
  // Loaded frames data
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
    return Scaffold(
      appBar: AppBar(title: const Text('Frame Analysis')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
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

    // Sort frames by timestamp
    _frames.sort(
      (a, b) => (a['timestamp'] as num).compareTo(b['timestamp'] as num),
    );

    // Simple, clean ListView implementation
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _frames.length + 1, // +1 for the header
      itemBuilder: (context, index) {
        if (index == 0) {
          // First item is the header
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: _buildHeader(),
          );
        }
        // Actual frame cards
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildSimpleFrameCard(_frames[index - 1], index - 1),
        );
      },
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

  Widget _buildSimpleFrameCard(dynamic frame, int index) {
    final timestamp = (frame['timestamp'] as num).toDouble();
    final minutes = (timestamp ~/ 60).toString().padLeft(2, '0');
    final seconds = (timestamp % 60).toStringAsFixed(2).padLeft(5, '0');
    final timeFormatted = '$minutes:$seconds';

    // Gather all 7 emotion values with safe defaults
    final emotions = <String, double>{
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

    // Determine card border color based on dominant emotion
    final borderColor = _emotionColor(dominantEmotion);
    final emotionIcon = _emotionIcon(dominantEmotion);

    // Wrap card with a gesture detector that doesn't interfere with scrolling
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Frame header with icon and time
            Row(
              children: [
                Icon(emotionIcon, color: borderColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Frame ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Time: $timeFormatted',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Chip(
                  label: Text(
                    dominantEmotion,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: borderColor,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 16),

            // Emotion indicators for all 7 emotions
            ..._buildAllEmotionIndicators(emotions),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAllEmotionIndicators(Map<String, double> emotions) {
    const order = [
      'happy',
      'neutral',
      'sad',
      'angry',
      'surprised',
      'fear',
      'disgust',
    ];
    return [
      for (final k in order) ...[
        _buildEmotionRow(_labelCase(k), emotions[k] ?? 0.0, _emotionColor(k)),
        const SizedBox(height: 6),
      ]
    ]..removeLast();
  }

  Widget _buildEmotionRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 12))),
        Expanded(
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(value * 100).toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
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

  String _labelCase(String key) {
    if (key.isEmpty) return key;
    return key[0].toUpperCase() + key.substring(1);
  }
}
