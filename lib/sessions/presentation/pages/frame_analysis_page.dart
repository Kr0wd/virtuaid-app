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

      // Extract the relative path from the full URL by removing the base URL part
      final uri = Uri.parse(fullUrl);
      final segments = uri.pathSegments;

      // Find where 'api' appears in the path (if at all)
      int apiIndex = segments.indexOf('api');
      final List<String> relativePath =
          apiIndex >= 0 ? segments.sublist(apiIndex + 1) : segments;

      // Join the path segments to form the relative path
      final relativeUrl = relativePath.join('/');

      final dioService = DioService();
      final response = await dioService.dioInstance.get(relativeUrl);

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _frames = data['results'];
          _isLoading = false;
        });
        print("Frames data loaded: ${_frames.length} items");
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load frames: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print("Error loading frames data: $e");
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
    final timestamp = frame['timestamp'].toDouble();
    final minutes = (timestamp ~/ 60).toString().padLeft(2, '0');
    final seconds = (timestamp % 60).toStringAsFixed(2).padLeft(5, '0');
    final timeFormatted = '$minutes:$seconds';

    final angry = (frame['angry'] * 100).toStringAsFixed(1);
    final sad = (frame['sad'] * 100).toStringAsFixed(1);
    final happy = (frame['happy'] * 100).toStringAsFixed(1);

    String dominantEmotion = frame['dominant_emotion'] ?? '';
    if (dominantEmotion.isEmpty) {
      final emotions = {
        'Happy': double.parse(frame['happy'].toString()),
        'Sad': double.parse(frame['sad'].toString()),
        'Angry': double.parse(frame['angry'].toString()),
      };

      dominantEmotion =
          emotions.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }

    // Determine card border color based on dominant emotion
    Color borderColor;
    IconData emotionIcon;
    switch (dominantEmotion.toLowerCase()) {
      case 'happy':
        borderColor = Colors.green;
        emotionIcon = Icons.sentiment_satisfied_alt;
        break;
      case 'sad':
        borderColor = Colors.blue;
        emotionIcon = Icons.sentiment_dissatisfied;
        break;
      case 'angry':
        borderColor = Colors.red;
        emotionIcon = Icons.mood_bad;
        break;
      default:
        borderColor = Colors.grey;
        emotionIcon = Icons.face;
    }

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

            // Emotion indicators
            _buildEmotionRow('Happy', double.parse(happy) / 100, Colors.green),
            const SizedBox(height: 6),
            _buildEmotionRow('Sad', double.parse(sad) / 100, Colors.blue),
            const SizedBox(height: 6),
            _buildEmotionRow('Angry', double.parse(angry) / 100, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionRow(String label, double value, Color color) {
    return Row(
      children: [
        SizedBox(width: 50, child: Text(label, style: TextStyle(fontSize: 12))),
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
          '${(value * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
