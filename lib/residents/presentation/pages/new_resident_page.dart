import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/residents/data/repositories/resident_repository.dart';
import 'package:intl/intl.dart';
import '../bloc/new_resident_bloc.dart';
import '../bloc/new_resident_event.dart';
import '../bloc/new_resident_state.dart';
import '../../../core/network/dio_service.dart';

class NewResidentPage extends StatelessWidget {
  const NewResidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    RepositoryProvider.of<DioService>(context);

    // Create the BlocProvider at this level
    return BlocProvider(
      create:
          (context) => NewResidentBloc(
            RepositoryProvider.of<ResidentRepository>(context, listen: false),
          ),
      child: const NewResidentForm(),
    );
  }
}

// Separate the form into its own widget with its own state
class NewResidentForm extends StatefulWidget {
  const NewResidentForm({super.key});

  @override
  State<NewResidentForm> createState() => _NewResidentFormState();
}

class _NewResidentFormState extends State<NewResidentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String get _formattedDate {
    return _selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : 'Select Date';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      // Now this context has access to the BlocProvider
      context.read<NewResidentBloc>().add(
        NewResidentEvent.addResident(
          name: _nameController.text.trim(),
          dateOfBirth: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        ),
      );
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date of birth')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Resident')),
      body: BlocConsumer<NewResidentBloc, NewResidentState>(
        listener: (context, state) {
          switch (state) {
            case NewResidentInitial():
              // Do nothing
              break;
            case NewResidentLoading():
              // Do nothing
              break;
            case NewResidentSuccess():
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resident added successfully!')),
              );
              Navigator.of(context).pop();
              break;
            case NewResidentError(:final message):
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
              break;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Header section
                  const Center(
                    child: Icon(
                      Icons.person_add_rounded,
                      size: 80,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      'Add Resident Information',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter resident name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Date of birth field
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      child: Text(_formattedDate),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Submit button
                  switch (state) {
                    NewResidentLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    _ => ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Add Resident',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  },
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
