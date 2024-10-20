import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracking/models/habit.dart';

class EditHabitDialog extends StatefulWidget {
  final Habit habit;
  final Function onHabitUpdated;

  const EditHabitDialog({
    super.key,
    required this.habit,
    required this.onHabitUpdated,
  });

  @override
  _EditHabitDialogState createState() => _EditHabitDialogState();
}

class _EditHabitDialogState extends State<EditHabitDialog> {
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
  late TextEditingController _habitNameController;
  late TextEditingController _timeTakenController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the existing habit data
    _habitNameController = TextEditingController(text: widget.habit.habitName);
    _timeTakenController =
        TextEditingController(text: widget.habit.timeTaken.toString());
    selectedDate = widget.habit.date; // Assuming date is a Timestamp
    selectedCategory = widget.habit.category;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _habitNameController,
                  decoration: InputDecoration(
                    hintText: 'Habit Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a habit name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _timeTakenController,
                  decoration: InputDecoration(
                    hintText: 'Time Taken',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.purple),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.purpleAccent),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 6)),
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
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Close the dialog on cancel
                      },
                      color: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please select a date')),
                            );
                          } else if (selectedCategory == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please select a category')),
                            );
                          } else {
                            _updateHabit();
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      color: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateHabit() async {
    try {
      final user = _auth.currentUser;

      if (user != null) {
        int timeInMinutes = int.parse(_timeTakenController.text.trim());
        if (isHours) {
          timeInMinutes *= 60; // Convert hours to minutes
        }

        // تحديث العادة في Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('habits')
            .doc(widget.habit.id) // استخدام المعرف الفريد للعادة
            .update({
          'habitName': _habitNameController.text.trim(),
          'timeTaken': timeInMinutes,
          'date': Timestamp.fromDate(selectedDate!),
          'category': selectedCategory,
        });

        widget.onHabitUpdated(); // استدعاء الوظيفة المحددة
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Habit updated successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update habit: $e')),
      );
    }
  }
}
