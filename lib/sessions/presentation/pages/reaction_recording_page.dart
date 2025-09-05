import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'stimulus_selection_page.dart';

enum _RRState { preparing, countdown, recording, preview }

class ReactionRecordingPage extends StatefulWidget {
  final StimulusVideo stimulus;
  const ReactionRecordingPage({super.key, required this.stimulus});

  @override
  State<ReactionRecordingPage> createState() => _ReactionRecordingPageState();
}

class _ReactionRecordingPageState extends State<ReactionRecordingPage> {
  _RRState state = _RRState.preparing;

  CameraController? _camera;
  VideoPlayerController? _videoCtrl;

  // ignore: unused_field
  File? _stimulusLocalFile;
  File? _recordedFile;

  int _countdown = 3;
  bool _isCancelling = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    // Permissions
    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (statuses.values.any((s) => !s.isGranted)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera/Mic permission denied')),
        );
        Navigator.pop(context);
      }
      return;
    }

    try {
      await _initCamera();
      await _initVideoPlayer();
      if (!mounted) return;
      setState(() => state = _RRState.countdown);
      _startCountdown();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Setup failed: $e')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front =
        cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    _camera = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: true,
    );
    await _camera!.initialize();
  }

  Future<void> _initVideoPlayer() async {
    _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(widget.stimulus.url));
    await _videoCtrl!.initialize();
    _videoCtrl!.addListener(_videoListener);
  }

  void _videoListener() {
    if (state == _RRState.recording &&
        _videoCtrl!.value.position >= _videoCtrl!.value.duration) {
      _stopRecording(autoComplete: true);
    }
  }

  void _startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (t) async {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_countdown == 0) {
        t.cancel();
        _beginPlaybackAndRecording();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> _beginPlaybackAndRecording() async {
    setState(() => state = _RRState.recording);
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/reaction_${DateTime.now().millisecondsSinceEpoch}.mp4';
    await _camera!.startVideoRecording();
    _videoCtrl!
      ..seekTo(Duration.zero)
      ..play();
    // Camera plugin stores internally; save path on stop
    _recordedFile = File(path); // Will replace after stop by saving file
  }

  Future<void> _stopRecording({bool autoComplete = false}) async {
    if (state != _RRState.recording) return;
    try {
      final file = await _camera!.stopVideoRecording();
      _videoCtrl?.pause();
      // Move recorded file to our chosen path if different
      if (_recordedFile != null) {
        final src = File(file.path);
        await src.copy(_recordedFile!.path);
      } else {
        _recordedFile = File(file.path);
      }
    } catch (_) {}
    if (!mounted) return;
    setState(() => state = _RRState.preview);
    if (autoComplete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recording complete')),
      );
    }
  }

  Future<void> _cancelMidPlayback() async {
    if (_isCancelling) return;
    _isCancelling = true;
    if (state == _RRState.recording) {
      await _stopRecording();
    }
    _isCancelling = false;
  }

  Future<void> _retake() async {
    // Reset
    _videoCtrl?.removeListener(_videoListener);
    await _videoCtrl?.dispose();
    _recordedFile = null;
    _countdown = 3;
    setState(() => state = _RRState.countdown);
    await _initVideoPlayer();
    _startCountdown();
  }

  void _useRecording() {
    if (_recordedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No recording available')),
      );
      return;
    }
    Navigator.pop<Map<String, dynamic>>(
      context,
      {
        'file': _recordedFile!,
      },
    );
  }

  @override
  void dispose() {
    _videoCtrl?.removeListener(_videoListener);
    _videoCtrl?.dispose();
    _camera?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (state) {
      case _RRState.preparing:
        body = _buildPreparing();
        break;
      case _RRState.countdown:
        body = _buildCountdown();
        break;
      case _RRState.recording:
        body = _buildRecording();
        break;
      case _RRState.preview:
        body = _buildPreview();
        break;
    }

    return WillPopScope(
      onWillPop: () async {
        if (state == _RRState.recording) {
          await _cancelMidPlayback();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: body),
      ),
    );
  }

  Widget _buildPreparing() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_isDownloading) const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            _isDownloading ? 'Downloading stimulus...' : 'Preparing...',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown() {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Center(
          child: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Center(
          child: Text(
            '$_countdown',
            style: const TextStyle(
              fontSize: 96,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecording() {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_videoCtrl != null && _videoCtrl!.value.isInitialized)
          FittedBox(
            fit: BoxFit.contain,
            child: SizedBox(
              width: _videoCtrl!.value.size.width,
              height: _videoCtrl!.value.size.height,
              child: VideoPlayer(_videoCtrl!),
            ),
          )
        else
          const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        Positioned(
          top: 12,
          left: 12,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.8),
            ),
            onPressed: _cancelMidPlayback,
            child: const Text('Cancel'),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  _videoCtrl?.value.isPlaying == true
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (_videoCtrl == null) return;
                  if (_videoCtrl!.value.isPlaying) {
                    _videoCtrl!.pause();
                  } else {
                    _videoCtrl!.play();
                  }
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop, color: Colors.white),
                onPressed: () => _stopRecording(),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up, color: Colors.white),
                onPressed: () {
                  // Simple volume toggle placeholder (video_player has no direct volume UI)
                  final isMuted = _videoCtrl?.value.volume == 0;
                  _videoCtrl?.setVolume(isMuted ? 1.0 : 0.0);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isMuted ? 'Volume On' : 'Volume Muted'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    return Column(
      children: [
        Expanded(
          child: _recordedFile == null
              ? const Center(
                  child: Text(
                    'No recording',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : FutureBuilder<VideoPlayerController>(
                  future: _createPreviewController(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }
                    final ctrl = snapshot.data!;
                    return AspectRatio(
                      aspectRatio: ctrl.value.aspectRatio,
                      child: VideoPlayer(ctrl),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _retake,
                  child: const Text('Retake'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Discard'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: _useRecording,
                  child: const Text('Use & Upload'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<VideoPlayerController> _createPreviewController() async {
    final ctrl = VideoPlayerController.file(_recordedFile!);
    await ctrl.initialize();
    ctrl.setLooping(true);
    ctrl.play();
    return ctrl;
  }
}