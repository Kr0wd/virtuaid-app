import 'package:flutter/material.dart';

class NewResidentPage extends StatelessWidget {
  const NewResidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Resident')),
      body: const Center(child: Text('New Resident Form')),
    );
  }
}
