import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/routes.dart';

// Keep the original ResidentsPage for backward compatibility
class ResidentsPage extends StatelessWidget {
  const ResidentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Residents')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.newResidentPath),
        child: const Icon(Icons.add),
      ),
      body: const ResidentsContent(),
    );
  }
}

// Create a new component for use in the shell
class ResidentsContent extends StatelessWidget {
  const ResidentsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text('${index + 1}'),
                ),
                title: Text('Resident ${index + 1}'),
                subtitle: Text('Room ${100 + index}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navigate to resident details
                },
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () => context.push(AppRouter.newResidentPath),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
