import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking/models/habit.dart';
import 'package:habit_tracking/screens/habit_tracking_screen.dart';
import 'package:habit_tracking/services/habite_service.dart';
import 'package:habit_tracking/widgets/add_habit_sheet.dart';
import 'package:habit_tracking/widgets/habit_edit.dart';
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
        return Image.asset('assets/sports.png', width: 40.w);
      case 'study':
        return Image.asset('assets/study.png', width: 40.w);
      case 'work':
        return Image.asset('assets/work.png', width: 40.w);
      case 'food':
        return Image.asset('assets/food.png', width: 40.w);
      case 'sleep':
        return Image.asset('assets/sleep.png', width: 40.w);
      case 'worship':
        return Image.asset('assets/worship.png', width: 40.w);
      case 'drink':
        return Image.asset('assets/drink.png', width: 40.w);
      case 'entertainment':
        return Image.asset('assets/entertainment.png', width: 40.w);
      default:
        return Image.asset('assets/default_icon.png', width: 40.w);
    }
  }

  // Helper function to get the card color based on status (same as before)
  BoxDecoration getCardDecoration(String status) {
    return BoxDecoration(
      gradient: status.toLowerCase() == 'complete'
          ? const LinearGradient(
              colors: [
                Color.fromARGB(255, 205, 179, 228),
                Color(0xFF9A4EBC),
              ], // استخدام الألوان المطلوبة
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : const LinearGradient(colors: [
              Colors.white,
              Colors.white,
            ]), // أو استخدام تدرج آخر أو لون آخر هنا
      borderRadius: BorderRadius.circular(12),
    );
  }

  // Helper function to get the status text (same as before)
  Widget getStatusText(Habit habit, Function() navigator) {
    return habit.status.toLowerCase() == 'complete'
        ? Text('Complete',
            style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 13.sp))
        : GestureDetector(
            onTap: () {
              navigator();
            },
            child: Text(
              'Start',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp),
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
      backgroundColor: const Color.fromARGB(255, 225, 219, 236),
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
        child: Icon(Icons.add, color: Colors.white, size: 30.r),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC), // Light gradient start
              Color(0xFFE1BEE7) // Gradient end
            ],
          ),
        ),
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            // Welcome message with user's name
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r)),
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF8A2387),
                      Color.fromARGB(255, 147, 95, 231),
                      Color.fromARGB(255, 158, 33, 242)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Welcome back, ',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  TextSpan(
                                    text: '${user?.displayName ?? 'User'}!',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 70),
                            Text(
                              'Complete $completedTasksToday/$totalTasksToday task today',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 70),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 8.h,
                                activeTrackColor: Colors.pinkAccent,
                                inactiveTrackColor: Colors.purple.shade100,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.r),
                                overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 14),
                                thumbColor: Colors.white,
                                overlayColor: Colors.pink.withOpacity(0.2),
                              ),
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: 0,
                                  end: totalTasksToday == 0
                                      ? 0
                                      : completedTasksToday.toDouble() /
                                          totalTasksToday,
                                ),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, child) {
                                  return Slider(
                                    value: value,
                                    onChanged: null, // Non-interactive slider
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      Image.asset(
                        'assets/calender.png',
                        width: 100.w,
                        height: 100.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 70),
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
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.deepPurple : Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: Colors.deepPurple),
                      ),
                      child: Text(
                        DateFormat('EEE, MMM d').format(day),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: isSelected ? Colors.white : Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 70),

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
                      return Center(
                        child: Text(
                          'No habits found for the selected date.',
                          style: TextStyle(
                            fontSize: 18.sp,
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
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 6.h),
                              decoration: getCardDecoration(habit.status),
                              child: ListTile(
                                leading: getCategoryImage(
                                    habit.category), // الصورة بجانب العنصر
                                title: Text(
                                  '${habit.timeTaken} minutes ${habit.habitName}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                    color: habit.status == 'complete'
                                        ? Colors.white
                                        : Colors.purple,
                                  ),
                                ),
                                subtitle: getStatusText(habit, () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              HabitTrackingScreen(
                                                habitId: habit.id,
                                                habitName: habit.habitName,
                                                durationMinutes:
                                                    habit.timeTaken,
                                                habitImage: getCategoryImage(
                                                    habit.category),
                                              )))
                                      .then((completed) {
                                    if (completed == true) {
                                      // إذا كانت العادة مكتملة، قم بتحديث الـ Slider
                                      _calculateTasksForSelectedDate(
                                          selectedDate);
                                    }
                                  });
                                }),

                                trailing: habit.status != 'complete'
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit_note_outlined,
                                          color: Colors.purple,
                                          size: 28.r,
                                        ),
                                        onPressed: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.noHeader,
                                            body: EditHabitDialog(
                                              habit: habit,
                                              onHabitUpdated: () {
                                                // إعادة تحميل العادات هنا
                                                _calculateTasksForSelectedDate(
                                                    selectedDate);
                                              },
                                            ),
                                          ).show();
                                        },
                                      )
                                    : null,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5.w, horizontal: 12.h),
                              )),
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
