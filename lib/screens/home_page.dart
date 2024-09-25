import 'package:flutter/material.dart';
import 'package:habit_tracking/models/habit.dart';
import 'package:habit_tracking/services/habite_service.dart';
import 'package:habit_tracking/widgets/add_habit_sheet.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HabitService habitService;

  @override
  void initState() {
    super.initState();
    habitService = HabitService();
  }

  // Helper function to get the image based on category
  Widget getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Image.asset('assets/sports.png',
            width: 40); // Add your sport image here
      case 'study':
        return Image.asset('assets/study.png',
            width: 40); // Add your study image here
      case 'work':
        return Image.asset('assets/work.png',
            width: 40); // Add your entertainment image here
      default:
        return Image.asset('assets/default_icon.png',
            width: 40); // Default image
    }
  }

  // Helper function to get the card color based on status
  Color getCardColor(String status) {
    return status.toLowerCase() == 'complete'
        ? Colors.blue.shade100
        : Colors.white;
  }

  // Helper function to get the status text
  Widget getStatusText(Habit habit) {
    return habit.status.toLowerCase() == 'complete'
        ? const Text(
            'Complete',
            style: TextStyle(color: Colors.blue),
          )
        : GestureDetector(
            onTap: () {
              // Navigate to a new page when "Start" is clicked
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => HabitDetailsPage(habit: habit), // Add your page here
              //   ),
              // );
            },
            child: const Text(
              'Start',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 135, 192),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const AddHabitSheet(),
          );
        },
        backgroundColor: Colors.deepPurple.shade700,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<List<Habit>>(
          stream: habitService.getUserHabits(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No habits added yet.'));
            } else {
              List<Habit> habits = snapshot.data!;
              return ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  Habit habit = habits[index];
                  return Card(
                    color: getCardColor(habit.status),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Display the image based on category
                          getCategoryImage(habit.category),
                          const SizedBox(width: 12),
                          // Display the habit name, time taken, and status
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${habit.timeTaken} minutes ${habit.habitName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                getStatusText(habit),
                              ],
                            ),
                          ),
                          // Display the date
                          Text(
                            DateFormat.yMMMd().format(habit.date),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
