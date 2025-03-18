import 'package:flutter/material.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapy Sessions'),
        // Back button is automatically added by Go Router
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Session ${index + 1}'),
              subtitle: Text(
                'Date: ${DateTime.now().add(Duration(days: index)).toString().substring(0, 10)}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to session details
              },
            ),
          );
        },
      ),
    );
  }
}
