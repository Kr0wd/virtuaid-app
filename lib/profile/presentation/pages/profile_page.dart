import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/authentication/bloc/authentication_bloc.dart';
import 'package:flutter_starter/authentication/models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  bool _isEditing = false;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();

    // Initialize with user data
    final state = context.read<AuthenticationBloc>().state;
    if (state is Authenticated) {
      _user = state.auth.user;
      nameController.text = _user!.name;
      usernameController.text = _user!.username;
      emailController.text = _user!.email;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    // TODO: Implement save functionality with API
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile update functionality will be implemented soon'),
      ),
    );
    _toggleEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _toggleEdit,
              tooltip: 'Edit Profile',
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveChanges,
              tooltip: 'Save Changes',
            ),
        ],
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authenticated) {
            final user = state.auth.user;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Avatar section
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[200],
                          backgroundImage:
                              user.avatar != null
                                  ? NetworkImage(user.avatar!)
                                  : null,
                          child:
                              user.avatar == null
                                  ? Text(
                                    user.name.isNotEmpty
                                        ? user.name[0].toUpperCase()
                                        : user.username[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : null,
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              radius: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  // TODO: Implement image upload
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Image upload will be implemented soon',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // User details form
                  _buildTextField(
                    label: 'Name',
                    controller: nameController,
                    enabled: _isEditing,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Username',
                    controller: usernameController,
                    enabled: false, // Username is typically not editable
                    icon: Icons.alternate_email,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    label: 'Email',
                    controller: emailController,
                    enabled: _isEditing,
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  // User role display
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          user.isAdmin ? Colors.amber[100] : Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          user.isAdmin
                              ? Icons.admin_panel_settings
                              : Icons.person,
                          color:
                              user.isAdmin
                                  ? Colors.amber[900]
                                  : Colors.blue[900],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          user.isAdmin ? 'Administrator' : 'Standard User',
                          style: TextStyle(
                            color:
                                user.isAdmin
                                    ? Colors.amber[900]
                                    : Colors.blue[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Cancel button when editing
                  if (_isEditing)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      onPressed: () {
                        // Restore original values
                        nameController.text = user.name;
                        emailController.text = user.email;
                        _toggleEdit();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                      ),
                    ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Please log in to view your profile'),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool enabled,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[100],
      ),
    );
  }
}
