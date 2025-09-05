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

      // Extract the relative path from the full URL by removing the base URL part
      // For URLs like http://localhost:8000/api/analysis/videos/8899aa8d-c2f2-4af6-aa07-44549bd037db/frames/
      // We need to extract 'analysis/videos/8899aa8d-c2f2-4af6-aa07-44549bd037db/frames/'

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
    final timestamp = frame['timestamp'].toDouble();
    final minutes = (timestamp ~/ 60).toString().padLeft(2, '0');
    final seconds = (timestamp % 60).toStringAsFixed(2).padLeft(5, '0');
    final timeFormatted = '$minutes:$seconds';

    final createdAt = DateTime.parse(frame['created_at']);
    final formattedDate = DateFormat('MMM d, yyyy HH:mm:ss').format(createdAt);

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
                    angry,
                    sad,
                    happy,
                    dominantEmotion,
                  )
                  : _buildWideFrameContent(
                    timeFormatted,
                    formattedDate,
                    angry,
                    sad,
                    happy,
                    dominantEmotion,
                  ),
        ),
      ),
    );
  }

  Widget _buildNarrowFrameContent(
    String timeFormatted,
    String formattedDate,
    String angry,
    String sad,
    String happy,
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
        Text('Created: $formattedDate', style: const TextStyle(fontSize: 12)),
        const Divider(),
        const SizedBox(height: 8),
        _buildEmotionIndicator(
          'Happy',
          double.parse(happy) / 100,
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildEmotionIndicator('Sad', double.parse(sad) / 100, Colors.blue),
        const SizedBox(height: 8),
        _buildEmotionIndicator('Angry', double.parse(angry) / 100, Colors.red),
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
    String formattedDate,
    String angry,
    String sad,
    String happy,
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
        Row(
          children: [
            Expanded(
              child: _buildEmotionIndicator(
                'Happy',
                double.parse(happy) / 100,
                Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildEmotionIndicator(
                'Sad',
                double.parse(sad) / 100,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildEmotionIndicator(
                'Angry',
                double.parse(angry) / 100,
                Colors.red,
              ),
            ),
          ],
        ),
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
    Color chipColor;
    switch (emotion.toLowerCase()) {
      case 'happy':
        chipColor = Colors.green;
        break;
      case 'sad':
        chipColor = Colors.blue;
        break;
      case 'angry':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

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
          _timelineData = data['results'] ?? [];
          _isLoading = false;
        });
        print("Timeline data loaded: ${_timelineData.length} items");
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load timeline: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
      print("Error loading timeline data: $e");
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
    // Sort the timeline data by timestamp to ensure chronological order
    _timelineData.sort(
      (a, b) => (a['timestamp'] as num).compareTo(b['timestamp'] as num),
    );

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
    // Get emotion values
    final happy = (timelineItem['happy'] * 100).toStringAsFixed(1);
    final sad = (timelineItem['sad'] * 100).toStringAsFixed(1);
    final angry = (timelineItem['angry'] * 100).toStringAsFixed(1);
    final dominantEmotion = _getDominantEmotion(timelineItem);

    // Format timestamp
    final timestamp = timelineItem['timestamp'].toDouble();
    final minutes = (timestamp ~/ 60).toString().padLeft(2, '0');
    final seconds = (timestamp % 60).toStringAsFixed(2).padLeft(5, '0');
    final timeFormatted = '$minutes:$seconds';

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
                    color: borderColor.withOpacity(0.2),
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
            _buildEmotionIndicator(
              'Happy',
              double.parse(happy) / 100,
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildEmotionIndicator('Sad', double.parse(sad) / 100, Colors.blue),
            const SizedBox(height: 8),
            _buildEmotionIndicator(
              'Angry',
              double.parse(angry) / 100,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  String _getDominantEmotion(dynamic dataPoint) {
    String dominantEmotion = dataPoint['dominant_emotion'] ?? '';
    if (dominantEmotion.isEmpty) {
      final emotions = {
        'Happy': double.parse(dataPoint['happy'].toString()),
        'Sad': double.parse(dataPoint['sad'].toString()),
        'Angry': double.parse(dataPoint['angry'].toString()),
      };

      dominantEmotion =
          emotions.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    }
    return dominantEmotion;
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
    Color chipColor;
    switch (emotion.toLowerCase()) {
      case 'happy':
        chipColor = Colors.green;
        break;
      case 'sad':
        chipColor = Colors.blue;
        break;
      case 'angry':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

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
