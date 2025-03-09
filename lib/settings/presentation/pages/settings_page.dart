import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 24),
            const Text(
              'App settings will be implemented here.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            // Placeholder card for settings sections
            Card(
              child: ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('Theme'),
                subtitle: const Text('Change app appearance'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Theme settings will be implemented soon'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                subtitle: const Text('Manage notifications preferences'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Notification settings will be implemented soon',
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Privacy'),
                subtitle: const Text('Manage privacy settings'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Privacy settings will be implemented soon',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
