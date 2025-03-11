import 'package:flutter/material.dart';

class FeedbacksPage extends StatelessWidget {
  const FeedbacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Feedback')),
      body: const Center(child: Text('Feedback List Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/feedbacks/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
