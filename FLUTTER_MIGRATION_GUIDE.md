# Flutter Frontend Migration Guide: 7-Emotion Support

## 🎯 Overview

Your backend now returns **7 emotions** instead of just 3. This guide will help your Flutter team update the app to handle all emotions properly.

## 📊 What Changed

### Before (Old Response - 3 emotions):
```json
{
    "id": "e5e33204-181f-49b5-a47d-ba0fba6f1245",
    "video": "1b876fa8-63d0-4f89-a843-881b2bcf611e",
    "timestamp": 0.0,
    "angry": 0.000745902128983289,
    "sad": 0.0000269051161012612,
    "happy": 0.962816715240479,
    "dominant_emotion": "",
    "created_at": "2025-09-11T05:21:15.169267Z"
}
```

### After (New Response - 7 emotions):
```json
{
    "id": "e5e33204-181f-49b5-a47d-ba0fba6f1245",
    "video": "1b876fa8-63d0-4f89-a843-881b2bcf611e",
    "timestamp": 0.0,
    "angry": 0.000745902128983289,
    "disgust": 0.001234567890123456,
    "fear": 0.002345678901234567,
    "happy": 0.962816715240479,
    "neutral": 0.025678901234567890,
    "sad": 0.0000269051161012612,
    "surprised": 0.007890123456789012,
    "dominant_emotion": "happy",
    "created_at": "2025-09-11T05:21:15.169267Z"
}
```

## 🛠️ Required Updates

### 1. Update Data Models

**Before:**
```dart
class EmotionAnalysis {
  final String id;
  final String video;
  final double timestamp;
  final double angry;
  final double sad;
  final double happy;
  final String dominantEmotion;
  final DateTime createdAt;

  EmotionAnalysis({
    required this.id,
    required this.video,
    required this.timestamp,
    required this.angry,
    required this.sad,
    required this.happy,
    required this.dominantEmotion,
    required this.createdAt,
  });

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) {
    return EmotionAnalysis(
      id: json['id'],
      video: json['video'],
      timestamp: json['timestamp'].toDouble(),
      angry: json['angry'].toDouble(),
      sad: json['sad'].toDouble(),
      happy: json['happy'].toDouble(),
      dominantEmotion: json['dominant_emotion'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
```

**After:**
```dart
class EmotionAnalysis {
  final String id;
  final String video;
  final double timestamp;
  final double angry;
  final double disgust;     // NEW
  final double fear;        // NEW
  final double happy;
  final double neutral;     // NEW
  final double sad;
  final double surprised;   // NEW
  final String dominantEmotion;
  final DateTime createdAt;

  EmotionAnalysis({
    required this.id,
    required this.video,
    required this.timestamp,
    required this.angry,
    required this.disgust,     // NEW
    required this.fear,        // NEW
    required this.happy,
    required this.neutral,     // NEW
    required this.sad,
    required this.surprised,   // NEW
    required this.dominantEmotion,
    required this.createdAt,
  });

  factory EmotionAnalysis.fromJson(Map<String, dynamic> json) {
    return EmotionAnalysis(
      id: json['id'],
      video: json['video'],
      timestamp: json['timestamp'].toDouble(),
      angry: json['angry'].toDouble(),
      disgust: json['disgust'].toDouble(),     // NEW
      fear: json['fear'].toDouble(),           // NEW
      happy: json['happy'].toDouble(),
      neutral: json['neutral'].toDouble(),     // NEW
      sad: json['sad'].toDouble(),
      surprised: json['surprised'].toDouble(), // NEW
      dominantEmotion: json['dominant_emotion'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Helper method to get all emotions as a Map
  Map<String, double> get emotionMap => {
    'angry': angry,
    'disgust': disgust,
    'fear': fear,
    'happy': happy,
    'neutral': neutral,
    'sad': sad,
    'surprised': surprised,
  };

  // Helper method to get all emotions as a List for charts
  List<double> get emotionValues => [
    angry, disgust, fear, happy, neutral, sad, surprised
  ];

  // Helper method to get emotion labels
  static List<String> get emotionLabels => [
    'Angry', 'Disgust', 'Fear', 'Happy', 'Neutral', 'Sad', 'Surprised'
  ];
}
```

### 2. Update UI Components

#### Emotion Chart Widget
```dart
class EmotionChart extends StatelessWidget {
  final EmotionAnalysis emotion;

  const EmotionChart({Key? key, required this.emotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bar chart for all emotions
        Container(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              barGroups: _createBarGroups(),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          EmotionAnalysis.emotionLabels[value.toInt()],
                          style: TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Dominant emotion display
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(_getEmotionIcon(emotion.dominantEmotion)),
                SizedBox(width: 8),
                Text(
                  'Dominant: ${emotion.dominantEmotion.toUpperCase()}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    final values = emotion.emotionValues;
    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            color: _getEmotionColor(EmotionAnalysis.emotionLabels[index].toLowerCase()),
            width: 20,
          ),
        ],
      );
    });
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion) {
      case 'angry': return Colors.red;
      case 'disgust': return Colors.green[800]!;
      case 'fear': return Colors.purple;
      case 'happy': return Colors.yellow[700]!;
      case 'neutral': return Colors.grey;
      case 'sad': return Colors.blue;
      case 'surprised': return Colors.orange;
      default: return Colors.grey;
    }
  }

  IconData _getEmotionIcon(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'angry': return Icons.sentiment_very_dissatisfied;
      case 'disgust': return Icons.sick;
      case 'fear': return Icons.warning;
      case 'happy': return Icons.sentiment_very_satisfied;
      case 'neutral': return Icons.sentiment_neutral;
      case 'sad': return Icons.sentiment_dissatisfied;
      case 'surprised': return Icons.help_outline;
      default: return Icons.sentiment_neutral;
    }
  }
}
```

#### Emotion Summary Widget
```dart
class EmotionSummary extends StatelessWidget {
  final List<EmotionAnalysis> emotionData;

  const EmotionSummary({Key? key, required this.emotionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final averages = _calculateAverages();
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Emotion Summary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            ...averages.entries.map((entry) => 
              _buildEmotionRow(entry.key, entry.value)
            ).toList(),
          ],
        ),
      ),
    );
  }

  Map<String, double> _calculateAverages() {
    if (emotionData.isEmpty) return {};
    
    final totals = <String, double>{};
    for (final emotion in emotionData) {
      emotion.emotionMap.forEach((key, value) {
        totals[key] = (totals[key] ?? 0) + value;
      });
    }
    
    return totals.map((key, value) => 
      MapEntry(key, value / emotionData.length)
    );
  }

  Widget _buildEmotionRow(String emotion, double value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            _getEmotionIcon(emotion),
            size: 20,
            color: _getEmotionColor(emotion),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(emotion.toUpperCase()),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(_getEmotionColor(emotion)),
            ),
          ),
          SizedBox(width: 8),
          Text('${(value * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }

  // Add the same helper methods as in EmotionChart
  Color _getEmotionColor(String emotion) { /* Same as above */ }
  IconData _getEmotionIcon(String emotion) { /* Same as above */ }
}
```

### 3. Update API Service

```dart
class EmotionApiService {
  // ... existing code ...

  Future<List<EmotionAnalysis>> getVideoEmotions(String videoId) async {
    try {
      final response = await _dio.get('/api/analysis/videos/$videoId/frames/');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => EmotionAnalysis.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load emotion data');
      }
    } on DioError catch (e) {
      throw ApiException('Network error: ${e.message}');
    }
  }

  // New method to get emotion statistics
  Future<Map<String, double>> getEmotionStatistics(String videoId) async {
    final emotions = await getVideoEmotions(videoId);
    
    if (emotions.isEmpty) return {};
    
    final totals = <String, double>{};
    for (final emotion in emotions) {
      emotion.emotionMap.forEach((key, value) {
        totals[key] = (totals[key] ?? 0) + value;
      });
    }
    
    return totals.map((key, value) => 
      MapEntry(key, value / emotions.length)
    );
  }
}
```

### 4. Update State Management (if using Provider/Bloc)

#### Provider Example:
```dart
class EmotionProvider extends ChangeNotifier {
  List<EmotionAnalysis> _emotions = [];
  Map<String, double> _statistics = {};
  bool _isLoading = false;

  List<EmotionAnalysis> get emotions => _emotions;
  Map<String, double> get statistics => _statistics;
  bool get isLoading => _isLoading;

  Future<void> loadEmotions(String videoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _emotions = await EmotionApiService().getVideoEmotions(videoId);
      _statistics = await EmotionApiService().getEmotionStatistics(videoId);
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to get dominant emotion across all frames
  String get overallDominantEmotion {
    if (_statistics.isEmpty) return 'neutral';
    
    return _statistics.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
```

## 🎨 UI/UX Recommendations

### 1. Color Scheme
```dart
class EmotionColors {
  static const Map<String, Color> colors = {
    'angry': Colors.red,
    'disgust': Color(0xFF4CAF50),      // Green
    'fear': Color(0xFF9C27B0),         // Purple
    'happy': Color(0xFFFFEB3B),        // Yellow
    'neutral': Color(0xFF9E9E9E),      // Grey
    'sad': Color(0xFF2196F3),          // Blue
    'surprised': Color(0xFFFF9800),    // Orange
  };
}
```

### 2. Icons
```dart
class EmotionIcons {
  static const Map<String, IconData> icons = {
    'angry': Icons.sentiment_very_dissatisfied,
    'disgust': Icons.sick,
    'fear': Icons.warning_amber,
    'happy': Icons.sentiment_very_satisfied,
    'neutral': Icons.sentiment_neutral,
    'sad': Icons.sentiment_dissatisfied,
    'surprised': Icons.help_outline,
  };
}
```

## 🧪 Testing

### Unit Tests
```dart
void main() {
  group('EmotionAnalysis', () {
    test('should parse JSON with all 7 emotions', () {
      final json = {
        'id': 'test-id',
        'video': 'test-video',
        'timestamp': 1.5,
        'angry': 0.1,
        'disgust': 0.05,
        'fear': 0.15,
        'happy': 0.6,
        'neutral': 0.05,
        'sad': 0.02,
        'surprised': 0.03,
        'dominant_emotion': 'happy',
        'created_at': '2025-09-11T05:21:15.169267Z',
      };

      final emotion = EmotionAnalysis.fromJson(json);

      expect(emotion.angry, 0.1);
      expect(emotion.disgust, 0.05);
      expect(emotion.fear, 0.15);
      expect(emotion.happy, 0.6);
      expect(emotion.neutral, 0.05);
      expect(emotion.sad, 0.02);
      expect(emotion.surprised, 0.03);
      expect(emotion.dominantEmotion, 'happy');
    });

    test('should return correct emotion map', () {
      // Test emotionMap helper method
    });

    test('should return correct emotion values list', () {
      // Test emotionValues helper method
    });
  });
}
```

## 🚀 Migration Checklist

- [ ] **Update data models** to include all 7 emotions
- [ ] **Update API service** methods to handle new response structure
- [ ] **Update UI components** to display all emotions
- [ ] **Update charts/graphs** to show all 7 emotions
- [ ] **Update color schemes** and icons for new emotions
- [ ] **Update state management** (Provider/Bloc/etc.)
- [ ] **Test with real API data** from the backend
- [ ] **Update unit tests** to cover new emotion fields
- [ ] **Update documentation** and code comments
- [ ] **Test backward compatibility** (if needed)

## 💡 Pro Tips

1. **Graceful Degradation**: Handle cases where some emotion values might be missing
2. **Performance**: Consider pagination for large emotion datasets
3. **Caching**: Cache emotion data to reduce API calls
4. **Animation**: Add smooth transitions when switching between emotion views
5. **Accessibility**: Add proper semantics and contrast for emotion colors

## 🔧 Troubleshooting

### Common Issues:

1. **Missing emotion fields**: Add null safety checks in your JSON parsing
```dart
disgust: (json['disgust'] ?? 0.0).toDouble(),
```

2. **Chart rendering issues**: Ensure all emotion values are between 0.0 and 1.0
3. **Color conflicts**: Test emotion colors in both light and dark themes

---

**Need help?** Contact the backend team if you encounter any issues with the new emotion data format! 🤝
