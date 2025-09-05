import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/dio_service.dart';
import '../../data/models/session_model.dart';
import '../../data/repositories/video_repository_impl.dart';
import '../bloc/video_analysis_bloc.dart';
import '../bloc/video_analysis_event.dart';
import '../bloc/video_analysis_state.dart';
import '../widgets/video_upload_success_widget.dart';
import 'stimulus_selection_page.dart';

class VideoAnalysisPage extends StatefulWidget {
  final SessionModel session;

  const VideoAnalysisPage({super.key, required this.session});

  @override
  State<VideoAnalysisPage> createState() => _VideoAnalysisPageState();
}

class _VideoAnalysisPageState extends State<VideoAnalysisPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _videoFile;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Pre-fill title with session info
    _titleController.text = 'Session video - ${widget.session.id}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? pickedFile = await picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 5),
      );

      if (pickedFile != null) {
        setState(() {
          _videoFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking video: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Record new video'),
            onTap: () {
              Navigator.pop(context);
              _pickVideo(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickVideo(ImageSource.gallery);
            },
          ),
          ListTile(
            leading: const Icon(Icons.live_tv),
            title: const Text('Live Reaction Recording'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push<Map<String, dynamic>?>(
                context,
                MaterialPageRoute(
                  builder: (_) => StimulusSelectionPage(
                    session: widget.session,
                  ),
                ),
              );
              if (result != null && result['file'] != null) {
                setState(() {
                  _videoFile = result['file'] as File;
                  final stimulusTitle = result['stimulusTitle'] as String?;
                  if (stimulusTitle != null) {
                    _titleController.text = 'Reaction to $stimulusTitle';
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reaction recording ready')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _uploadVideo(BuildContext context) {
    if (_formKey.currentState?.validate() != true || _videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a video and fill in required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<VideoAnalysisBloc>().add(
      UploadVideo(
        videoFile: _videoFile!,
        title: _titleController.text,
        description: _descriptionController.text,
        sessionId: widget.session.id,
        residentId: int.tryParse(widget.session.residentDetails.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Create a provider for VideoAnalysisBloc
    return BlocProvider(
      create:
          (context) => VideoAnalysisBloc(
            VideoRepositoryImpl(context.read<DioService>()),
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Emotion Analysis')),
        body: BlocConsumer<VideoAnalysisBloc, VideoAnalysisState>(
          listener: (context, state) {
            if (state is VideoAnalysisError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is VideoAnalysisLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Uploading video...'),
                  ],
                ),
              );
            } else if (state is VideoAnalysisSuccess) {
              return VideoUploadSuccessWidget(
                video: state.video,
                session: widget.session,
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_videoFile == null)
                      InkWell(
                        onTap: _showSourceSelector,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_library, size: 64),
                              SizedBox(height: 8),
                              Text('Tap to record or select a video'),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.video_file,
                                    color: Colors.white,
                                    size: 64,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _videoFile = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Video selected: ${_videoFile!.path.split('/').last}',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Video Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    if (_videoFile == null)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.video_call),
                          label: const Text('Select Video'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _showSourceSelector,
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_upload),
                          label: const Text('Upload and Analyze'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => _uploadVideo(context),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}