import 'package:flutter/material.dart';
import 'package:habit_tracking/models/habit.dart';
import 'package:habit_tracking/screens/habit_tracking_screen.dart';
import 'package:habit_tracking/services/habite_service.dart';
import 'package:habit_tracking/widgets/add_habit_sheet.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For user information

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HabitService habitService;
  User? user; // Firebase user to get the user's name
  DateTime selectedDate =
      DateTime.now(); // The initially selected date is today
  List<DateTime> weekDays = []; // List to store the next 7 days
  int totalTasksToday = 0;
  int completedTasksToday = 0;

  @override
  void initState() {
    super.initState();
    habitService = HabitService();
    user = FirebaseAuth.instance.currentUser; // Get current user info
    _generateWeekDays(); // Generate 7 days starting from today
    _calculateTasksForSelectedDate(
        selectedDate); // Calculate today's tasks initially
  }

  void _generateWeekDays() {
    weekDays = List<DateTime>.generate(
        7, (index) => DateTime.now().add(Duration(days: index)));
  }

  // Fetch habits for the selected date and calculate the total/completed tasks
  void _calculateTasksForSelectedDate(DateTime date) async {
    // Fetch all habits for the selected date
    List<Habit> habits = await habitService.fetchHabitsByDate(date);
    print('Fetched habits: $habits');
    setState(() {
      totalTasksToday = habits.length; // Total number of habits for today
      completedTasksToday =
          habits.where((habit) => habit.status == 'complete').length;
    });
  }

  // Helper function to get the image based on category (same as before)
  Widget getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Image.asset('assets/sports.png', width: 40);
      case 'study':
        return Image.asset('assets/study.png', width: 40);
      case 'work':
        return Image.asset('assets/work.png', width: 40);
      default:
        return Image.asset('assets/default_icon.png', width: 40);
    }
  }

  // Helper function to get the card color based on status (same as before)
  Color getCardColor(String status) {
    return status.toLowerCase() == 'complete'
        ? Colors.blue.shade100
        : Colors.white;
  }

  // Helper function to get the status text (same as before)
  Widget getStatusText(Habit habit, Function() navigator) {
    return habit.status.toLowerCase() == 'complete'
        ? const Text('Complete', style: TextStyle(color: Colors.blue))
        : GestureDetector(
            onTap: () {
              navigator();
            },
            child: const Text(
              'Start',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          );
  }

  // Helper function to compare only the date (ignoring time)
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 155, 135, 192),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddHabitSheet(
              onHabitAdded: () {
                _calculateTasksForSelectedDate(selectedDate);
              },
            ),
          );
        },
        backgroundColor: Colors.deepPurple.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Welcome message with user's name
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Welcome, ${user?.displayName ?? 'User'}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Slider showing total and completed tasks for today
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                        'Tasks for today: $completedTasksToday / $totalTasksToday'),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                          begin: 0,
                          end: totalTasksToday == 0
                              ? 0
                              : completedTasksToday.toDouble()),
                      duration: const Duration(seconds: 1),
                      builder: (context, value, child) {
                        return Slider(
                          value: totalTasksToday == 0
                              ? 0
                              : value / totalTasksToday,
                          onChanged: null, // This is a non-interactive slider
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Days of the week to select
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: weekDays.map((day) {
                  bool isSelected = isSameDate(day, selectedDate);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = day;
                        _calculateTasksForSelectedDate(
                            day); // Calculate tasks for the selected date
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Text(
                        DateFormat('EEE, MMM d').format(day),
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // List of habits for the selected day
            Expanded(
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
                    // فلترة العادات حسب اليوم المحدد
                    List<Habit> habits = snapshot.data!.where((habit) {
                      return DateFormat.yMMMd().format(habit.date) ==
                          DateFormat.yMMMd().format(selectedDate);
                    }).toList();

                    // إذا كانت القائمة فارغة بعد الفلترة، اعرض رسالة "لا توجد عادات"
                    if (habits.isEmpty) {
                      return const Center(
                        child: Text(
                          'No habits found for the selected date.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      );
                    }

                    // إذا كانت هناك عادات، اعرض القائمة
                    return ListView.builder(
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        Habit habit = habits[index];
                        return Dismissible(
                          key:
                              Key(habit.id), // تأكد من أن لديك معرف فريد للعادة
                          background: Container(color: Colors.red),
                          onDismissed: (direction) {
                            // حذف العادة من HabitService
                            habitService.deleteHabit(habit.id).then((_) {
                              // تحديث العادات بعد الحذف
                              _calculateTasksForSelectedDate(selectedDate);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text('${habit.habitName} deleted')),
                              );
                            });
                          },
                          child: Card(
                            color: getCardColor(habit.status),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  getCategoryImage(habit.category),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${habit.timeTaken} minutes ${habit.habitName}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        getStatusText(habit, () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      HabitTrackingScreen(
                                                          habitId: habit.id,
                                                          habitName:
                                                              habit.habitName,
                                                          durationMinutes:
                                                              habit.timeTaken,
                                                          habitImage:
                                                              getCategoryImage(
                                                                  habit
                                                                      .category))))
                                              .then((completed) {
                                            if (completed == true) {
                                              // إذا كانت العادة مكتملة، قم بتحديث الـ Slider
                                              _calculateTasksForSelectedDate(
                                                  selectedDate);
                                            }
                                          });
                                        }),
                                      ],
                                    ),
                                  ),
                                  Text(DateFormat.yMd().format(habit.date)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
