# Video Analysis & Therapy Sessions Integration Guide for Flutter

## Overview

This documentation provides comprehensive information on integrating the VirtuAid backend's video analysis and therapy sessions features into a Flutter application. The system provides AI-powered emotion analysis for therapy session recordings with real-time processing capabilities.

## Base API Configuration

**Base URL**: `http://127.0.0.1:8000/api/`

**Authentication**: JWT Token required in headers
```
Authorization: Bearer <your_jwt_token>
```

## 1. Therapy Sessions API

### Base Endpoint: `/sessions/`

#### 1.1 List Therapy Sessions
**GET** `/sessions/`

**Query Parameters:**
- `status`: Filter by session status (`scheduled`, `in_progress`, `completed`, `cancelled`)
- `status_category`: Filter by category (`completed`, `upcoming`, `past_due`, `in_progress`, `today`)
- `feedback_status`: Filter by feedback status (`completed`, `pending`)
- `resident`: Filter by resident UUID
- `search`: Search in resident names and session notes
- `ordering`: Order results (`scheduled_date`, `-scheduled_date`, `created_at`, etc.)

**Example Request:**
```dart
final response = await http.get(
  Uri.parse('$baseUrl/sessions/?status=completed&ordering=-scheduled_date'),
  headers: {'Authorization': 'Bearer $token'},
);
```

**Response:**
```json
{
  "count": 12,
  "next": null,
  "previous": null,
  "results": [
    {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "title": "Morning VR Relaxation Session",
      "description": "Calming virtual environment session",
      "resident": "456e7890-e89b-12d3-a456-426614174001",
      "scheduled_date": "2024-09-03T10:00:00Z",
      "duration": 30,
      "status": "completed",
      "feedback_status": "Completed"
    }
  ]
}
```

#### 1.2 Create New Therapy Session
**POST** `/sessions/`

**Request Body:**
```json
{
  "title": "Anxiety Management Session",
  "description": "Breathing exercises and relaxation techniques",
  "resident": "456e7890-e89b-12d3-a456-426614174001",
  "scheduled_date": "2024-09-10T14:00:00Z",
  "duration": 45,
  "notes": "Patient requested additional breathing exercises"
}
```

**Flutter Example:**
```dart
final response = await http.post(
  Uri.parse('$baseUrl/sessions/'),
  headers: {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  },
  body: jsonEncode({
    'title': 'Anxiety Management Session',
    'resident': residentId,
    'scheduled_date': DateTime.now().add(Duration(days: 1)).toIso8601String(),
    'duration': 45,
  }),
);
```

#### 1.3 Get Session Details
**GET** `/sessions/{session_id}/`

#### 1.4 Update Session
**PUT** `/sessions/{session_id}/` or **PATCH** `/sessions/{session_id}/`

#### 1.5 Session Status Management

##### Mark as Completed
**POST** `/sessions/{session_id}/mark_completed/`

```dart
final response = await http.post(
  Uri.parse('$baseUrl/sessions/$sessionId/mark_completed/'),
  headers: {'Authorization': 'Bearer $token'},
);
```

##### Mark as In Progress
**POST** `/sessions/{session_id}/mark_in_progress/`

##### Cancel Session
**POST** `/sessions/{session_id}/cancel_session/`

#### 1.6 Get Session Videos with Analysis Endpoints
**GET** `/sessions/{session_id}/videos/`

**Response:**
```json
[
  {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "title": "VR Session Recording",
    "file": "http://127.0.0.1:8000/media/videos/session_recording.mp4",
    "status": "completed",
    "emotion_analysis_urls": {
      "frames": "http://127.0.0.1:8000/api/analysis/videos/123e4567-e89b-12d3-a456-426614174000/frames/",
      "timeline": "http://127.0.0.1:8000/api/analysis/videos/123e4567-e89b-12d3-a456-426614174000/timeline/",
      "summary": "http://127.0.0.1:8000/api/analysis/videos/123e4567-e89b-12d3-a456-426614174000/summary/"
    }
  }
]
```

## 2. Video Analysis API

### Base Endpoint: `/analysis/videos/`

#### 2.1 List Videos
**GET** `/analysis/videos/`

**Query Parameters:**
- `search`: Search by title or description
- `ordering`: Order by `uploaded_at`, `title`, etc.

#### 2.2 Upload Video for Analysis
**POST** `/analysis/videos/`

**Content-Type**: `multipart/form-data`

**Flutter Example:**
```dart
var request = http.MultipartRequest(
  'POST',
  Uri.parse('$baseUrl/analysis/videos/'),
);

request.headers['Authorization'] = 'Bearer $token';
request.fields['title'] = 'Therapy Session Recording';
request.fields['description'] = 'Main session recording';
request.fields['therapy_session'] = sessionId;

var file = await http.MultipartFile.fromPath(
  'file',
  videoFile.path,
  contentType: MediaType('video', 'mp4'),
);
request.files.add(file);

var response = await request.send();
```

**Response:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440001",
  "title": "Therapy Session Recording",
  "file": "/media/videos/group_therapy_002.mp4",
  "status": "pending",
  "therapy_session": 2
}
```

#### 2.3 Get Video Details
**GET** `/analysis/videos/{video_id}/`

**Response includes embedded emotion analysis summary:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "CBT Session - Week 1",
  "file": "/media/videos/cbt_week1.mp4",
  "status": "completed",
  "emotion_summary": {
    "angry_avg": 0.12,
    "sad_avg": 0.25,
    "happy_avg": 0.63,
    "dominant_emotion": "happy",
    "emotion_counts": {
      "happy": 1250,
      "sad": 480,
      "angry": 200,
      "total_frames": 1930
    }
  }
}
```

#### 2.4 Get Processing Status
**GET** `/analysis/videos/{video_id}/status/`

**Response:**
```json
{
  "status": "completed",
  "message": "Video analysis completed successfully"
}
```

**Status Values:**
- `pending`: Queued for processing
- `processing`: Currently analyzing
- `completed`: Analysis finished
- `failed`: Analysis failed

#### 2.5 Get Frame-by-Frame Analysis
**GET** `/analysis/videos/{video_id}/frames/`

**Response:**
```json
[
  {
    "id": "frame-uuid-1",
    "timestamp": 0.5,
    "angry": 0.15,
    "sad": 0.20,
    "happy": 0.65,
    "dominant_emotion": "happy"
  },
  {
    "id": "frame-uuid-2",
    "timestamp": 1.0,
    "angry": 0.25,
    "sad": 0.35,
    "happy": 0.40,
    "dominant_emotion": "happy"
  }
]
```

#### 2.6 Get Emotion Timeline
**GET** `/analysis/videos/{video_id}/timeline/`

**Response:**
```json
[
  {
    "id": "timeline-uuid-1",
    "start_time": 0.0,
    "end_time": 15.5,
    "duration": 15.5,
    "dominant_emotion": "happy",
    "confidence": 0.78
  },
  {
    "id": "timeline-uuid-2",
    "start_time": 15.5,
    "end_time": 32.0,
    "duration": 16.5,
    "dominant_emotion": "sad",
    "confidence": 0.65
  }
]
```

#### 2.7 Get Analysis Summary
**GET** `/analysis/videos/{video_id}/summary/`

**Response:**
```json
{
  "id": 1,
  "video": "550e8400-e29b-41d4-a716-446655440000",
  "angry_avg": 0.12,
  "sad_avg": 0.25,
  "happy_avg": 0.63,
  "dominant_emotion": "happy",
  "emotion_counts": {
    "happy": 1250,
    "sad": 480,
    "angry": 200,
    "total_frames": 1930
  },
  "created_at": "2024-01-15T10:45:00Z"
}
```

#### 2.8 Download Analysis Data as CSV
**GET** `/analysis/videos/{video_id}/download_csv/`

Returns CSV file with frame-by-frame emotion data.

#### 2.9 Download Timeline as CSV
**GET** `/analysis/videos/{video_id}/download_timeline_csv/`

Returns CSV file with emotion timeline segments.

## 3. Flutter Integration Examples

### 3.1 Complete Video Upload and Monitoring Flow

```dart
class VideoAnalysisService {
  final String baseUrl;
  final String token;

  VideoAnalysisService(this.baseUrl, this.token);

  // Upload video and start analysis
  Future<String> uploadVideo({
    required File videoFile,
    required String title,
    required String sessionId,
    String? description,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/analysis/videos/'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['therapy_session'] = sessionId;
    if (description != null) {
      request.fields['description'] = description;
    }

    var file = await http.MultipartFile.fromPath(
      'file',
      videoFile.path,
    );
    request.files.add(file);

    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    var jsonData = jsonDecode(responseData);
    
    return jsonData['id']; // Return video ID
  }

  // Monitor processing status
  Future<String> getProcessingStatus(String videoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/analysis/videos/$videoId/status/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    var data = jsonDecode(response.body);
    return data['status'];
  }

  // Get analysis results when complete
  Future<Map<String, dynamic>> getAnalysisResults(String videoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/analysis/videos/$videoId/summary/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    return jsonDecode(response.body);
  }

  // Get timeline data for visualization
  Future<List<dynamic>> getEmotionTimeline(String videoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/analysis/videos/$videoId/timeline/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    return jsonDecode(response.body);
  }
}
```

### 3.2 Session Management Widget

```dart
class SessionManager extends StatefulWidget {
  @override
  _SessionManagerState createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  List<dynamic> sessions = [];
  
  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  Future<void> loadSessions() async {
    final response = await http.get(
      Uri.parse('$baseUrl/sessions/?status_category=today'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    setState(() {
      sessions = jsonDecode(response.body)['results'];
    });
  }

  Future<void> markSessionCompleted(String sessionId) async {
    await http.post(
      Uri.parse('$baseUrl/sessions/$sessionId/mark_completed/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    loadSessions(); // Refresh the list
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        var session = sessions[index];
        return ListTile(
          title: Text(session['title']),
          subtitle: Text('Status: ${session['status']}'),
          trailing: session['status'] == 'in_progress'
              ? ElevatedButton(
                  onPressed: () => markSessionCompleted(session['id']),
                  child: Text('Complete'),
                )
              : null,
        );
      },
    );
  }
}
```

### 3.3 Real-time Analysis Monitoring

```dart
class AnalysisMonitor extends StatefulWidget {
  final String videoId;
  
  AnalysisMonitor({required this.videoId});
  
  @override
  _AnalysisMonitorState createState() => _AnalysisMonitorState();
}

class _AnalysisMonitorState extends State<AnalysisMonitor> {
  Timer? _timer;
  String status = 'pending';
  Map<String, dynamic>? results;

  @override
  void initState() {
    super.initState();
    startMonitoring();
  }

  void startMonitoring() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      await checkStatus();
    });
  }

  Future<void> checkStatus() async {
    final response = await http.get(
      Uri.parse('$baseUrl/analysis/videos/${widget.videoId}/status/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    var data = jsonDecode(response.body);
    setState(() {
      status = data['status'];
    });

    if (status == 'completed') {
      _timer?.cancel();
      await loadResults();
    } else if (status == 'failed') {
      _timer?.cancel();
    }
  }

  Future<void> loadResults() async {
    final response = await http.get(
      Uri.parse('$baseUrl/analysis/videos/${widget.videoId}/summary/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    setState(() {
      results = jsonDecode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Analysis Status: $status'),
        if (status == 'processing') CircularProgressIndicator(),
        if (results != null) ...[
          Text('Dominant Emotion: ${results!['dominant_emotion']}'),
          Text('Happy Average: ${results!['happy_avg'].toStringAsFixed(2)}'),
          Text('Sad Average: ${results!['sad_avg'].toStringAsFixed(2)}'),
          Text('Angry Average: ${results!['angry_avg'].toStringAsFixed(2)}'),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
```

## 4. Error Handling

### Common HTTP Status Codes:
- `200`: Success
- `201`: Created (for uploads)
- `400`: Bad Request (validation errors)
- `401`: Unauthorized (invalid token)
- `404`: Not Found
- `500`: Internal Server Error

### Recommended Error Handling:
```dart
Future<Map<String, dynamic>> makeApiCall(String url) async {
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Authentication failed');
    } else if (response.statusCode == 404) {
      throw Exception('Resource not found');
    } else {
      throw Exception('API call failed: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Network error: $e');
  }
}
```

## 5. Data Models for Flutter

### Session Model:
```dart
class TherapySession {
  final String id;
  final String title;
  final String description;
  final String residentId;
  final DateTime scheduledDate;
  final int duration;
  final String status;
  
  TherapySession({
    required this.id,
    required this.title,
    required this.description,
    required this.residentId,
    required this.scheduledDate,
    required this.duration,
    required this.status,
  });
  
  factory TherapySession.fromJson(Map<String, dynamic> json) {
    return TherapySession(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      residentId: json['resident'],
      scheduledDate: DateTime.parse(json['scheduled_date']),
      duration: json['duration'],
      status: json['status'],
    );
  }
}
```

### Video Analysis Model:
```dart
class VideoAnalysis {
  final String id;
  final String title;
  final String status;
  final EmotionSummary? emotionSummary;
  
  VideoAnalysis({
    required this.id,
    required this.title,
    required this.status,
    this.emotionSummary,
  });
  
  factory VideoAnalysis.fromJson(Map<String, dynamic> json) {
    return VideoAnalysis(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      emotionSummary: json['emotion_summary'] != null
          ? EmotionSummary.fromJson(json['emotion_summary'])
          : null,
    );
  }
}

class EmotionSummary {
  final double angryAvg;
  final double sadAvg;
  final double happyAvg;
  final String dominantEmotion;
  final Map<String, int> emotionCounts;
  
  EmotionSummary({
    required this.angryAvg,
    required this.sadAvg,
    required this.happyAvg,
    required this.dominantEmotion,
    required this.emotionCounts,
  });
  
  factory EmotionSummary.fromJson(Map<String, dynamic> json) {
    return EmotionSummary(
      angryAvg: json['angry_avg'].toDouble(),
      sadAvg: json['sad_avg'].toDouble(),
      happyAvg: json['happy_avg'].toDouble(),
      dominantEmotion: json['dominant_emotion'],
      emotionCounts: Map<String, int>.from(json['emotion_counts']),
    );
  }
}
```
