import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart'; // For input formatters

class AddHabitSheet extends StatefulWidget {
  const AddHabitSheet({super.key, required this.onHabitAdded});
   final Function onHabitAdded;
  @override
  _AddHabitSheetState createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  DateTime? selectedDate;
  String? selectedCategory;
  bool isHours = false; // Toggle between hours and minutes

  final List<String> categories = [
    'Work',
    'Study',
    'Sports',
    'Food',
    'Drink',
    'Sleep',
    'Worship',
    'Entertainment'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _habitNameController = TextEditingController();
  final TextEditingController _timeTakenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _habitNameController,
                  decoration: const InputDecoration(
                    hintText: 'Habit Name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a habit name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                // Time Taken Field (with number input only)
                TextFormField(
                  controller: _timeTakenController,
                  decoration: const InputDecoration(
                    hintText: 'Time Taken',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the time taken for the habit';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Toggle between Minutes and Hours
                Row(
                  children: [
                    const Text('Time in:'),
                    const Spacer(),
                    Switch(
                      value: isHours,
                      onChanged: (value) {
                        setState(() {
                          isHours = value;
                        });
                      },
                    ),
                    Text(isHours ? 'Hours' : 'Minutes'),
                  ],
                ),

                const SizedBox(height: 15),

                // Date Picker Row
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                              const Duration(days: 6)), // 6 days after today
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.blue,
                      ),
                    ),

                    Text(
                      selectedDate == null
                          ? 'No Date Selected'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                    ),
                    const Spacer(),
                    // Cancel Button
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    // Save Button
                    MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (selectedDate == null) {
                            _showError('Please select a date');
                          } else if (selectedCategory == null) {
                            _showError('Please select a category');
                          } else {
                            await _saveHabit();
                            widget.onHabitAdded();
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  hint: const Text('Select Category'),
                  value: selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveHabit() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        // Convert time based on user selection (hours to minutes)
        int timeInMinutes = int.parse(_timeTakenController.text.trim());
        if (isHours) {
          timeInMinutes *= 60; // Convert hours to minutes
        }

        // Add the new habit to Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('habits')
            .add({
          'habitName': _habitNameController.text.trim(),
          'timeTaken': timeInMinutes,
          'date': Timestamp.fromDate(selectedDate!),
          'status': 'Uncompleted',
          'category': selectedCategory,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit added successfully'),
          ),
        );
      } else {
        _showError('User not logged in.');
      }
    } catch (e) {
      _showError('Failed to add habit: $e');
    }
  }
}
