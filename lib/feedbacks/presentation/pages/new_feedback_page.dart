import 'package:flutter/material.dart';

class NewFeedbackPage extends StatelessWidget {
  const NewFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Feedback')),
      body: const Center(child: Text('New Feedback Form')),
    );
  }
}
