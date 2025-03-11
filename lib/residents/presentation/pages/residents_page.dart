import 'package:flutter/material.dart';

class ResidentsPage extends StatelessWidget {
  const ResidentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Residents')),
      body: const Center(child: Text('Residents List Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/residents/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
