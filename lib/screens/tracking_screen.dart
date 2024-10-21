import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking/models/habit.dart';
import 'package:habit_tracking/services/habite_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  String selectedWeek = 'This week';
  List<Habit> habits = [];
  HabitService habitService = HabitService();
  Map<int, double> completionRates =
      {}; // Map to store completion percentages for each day
  Map<int, int> habitsPerDay = {}; // Map to store total habits per day
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _fetchHabits();
  }

  Future<void> _fetchHabits() async {
    setState(() {
      loading = true;
    });
    List<Habit> fetchedHabits =
        await habitService.getHabitsByWeek(selectedWeek);
    print('Fetched ${fetchedHabits.length} habits');
    setState(() {
      habits = fetchedHabits;
      _calculateCompletionRates(); // إعادة حساب النسب المئوية بعد جلب البيانات
      loading = false;
    });
  }

  void _calculateCompletionRates() {
    Map<int, int> totalHabitsPerDay = {};
    Map<int, int> completedHabitsPerDay = {};

    DateTime today = DateTime.now();
    DateTime startOfWeek;
    DateTime endOfWeek;

    if (selectedWeek == 'Previous week') {
      // حساب بداية ونهاية الأسبوع السابق بحيث يبدأ من السبت وينتهي الجمعة
      startOfWeek =
          today.subtract(Duration(days: today.weekday + 8)); // يوم السبت السابق
      endOfWeek = startOfWeek.add(const Duration(days: 6)); // يوم الجمعة
    } else {
      // حساب بداية ونهاية هذا الأسبوع بحيث يبدأ من السبت وينتهي الجمعة
      startOfWeek = today
          .subtract(Duration(days: today.weekday % 7 + 1)); // يوم السبت الحالي
      endOfWeek = startOfWeek.add(const Duration(days: 6)); // يوم الجمعة
    }

    // تصفير العداد لكل يوم
    for (int i = 0; i < 7; i++) {
      totalHabitsPerDay[i] = 0;
      completedHabitsPerDay[i] = 0;
    }

    for (var habit in habits) {
      // التأكد من أن العادة تخص الأسبوع المحدد
      if (habit.date.isAfter(startOfWeek) && habit.date.isBefore(endOfWeek)) {
        int habitWeekday = (habit.date.weekday + 1) %
            7; // تعديل لحساب الأيام من السبت إلى الجمعة

        totalHabitsPerDay[habitWeekday] =
            (totalHabitsPerDay[habitWeekday] ?? 0) + 1;
        if (habit.status == 'complete') {
          completedHabitsPerDay[habitWeekday] =
              (completedHabitsPerDay[habitWeekday] ?? 0) + 1;
        }
      }
    }

    // حساب النسب المئوية لكل يوم
    setState(() {
      completionRates = Map.fromEntries(List.generate(7, (index) {
        int total = totalHabitsPerDay[index] ?? 0;
        int completed = completedHabitsPerDay[index] ?? 0;
        double completionRate = total > 0 ? completed / total : 0.0;
        habitsPerDay[index] = total;
        return MapEntry(index, completionRate);
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3E5FC),
        centerTitle: true,
        title: Text('Tracking',
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.purple)),
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
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16.0.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding:  EdgeInsets.symmetric(
                          horizontal: 10.h, vertical: 5.w),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 185, 197, 248),
                          borderRadius: BorderRadius.circular(20.r)),
                      child: DropdownButton<String>(
                        icon: const Icon(Icons.keyboard_arrow_down_sharp),
                        style:  TextStyle(
                            color: Colors.purple,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                        value: selectedWeek,
                        items:
                            ['This week', 'Previous week'].map((String week) {
                          return DropdownMenuItem<String>(
                            value: week,
                            child: Text(week),
                          );
                        }).toList(),
                        onChanged: (String? newWeek) {
                          setState(() {
                            selectedWeek = newWeek!;
                            _fetchHabits();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Bar Chart Section inside a Container with Violet Shades
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                        255, 183, 170, 247), // Violet shade
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding:  EdgeInsets.all(16.r),
                  child: AspectRatio(
                    aspectRatio: 1.5.r,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: BarChart(
                        key: ValueKey<int>(
                            habits.length), // Important for animation
                        BarChartData(
                          borderData: FlBorderData(show: false),
                          gridData:
                              const FlGridData(show: false), // Hide grid lines
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            show: true,
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false), // Remove left numbers
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: false), // Remove top numbers
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold);

                                  // List of day names from Saturday to Friday
                                  const List<String> daysOfWeek = [
                                    'Sat',
                                    'Sun',
                                    'Mon',
                                    'Tue',
                                    'Wed',
                                    'Thu',
                                    'Fri'
                                  ];

                                  // Get the day name based on the index value
                                  String dayName =
                                      daysOfWeek[value.toInt() % 7];

                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 4.0,
                                    child: Text(dayName, style: style),
                                  );
                                },
                              ),
                            ),
                          ),
                          barGroups: _buildBarGroups(),
                          barTouchData:
                              BarTouchData(enabled: false), // Disable tooltips
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Progress of this week',
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                loading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Expanded(
                        child: habits.isEmpty
                            ? const Center(
                                child: Text(
                                    'No habits found for the selected week'))
                            : ListView.builder(
                                itemCount: habits.length,
                                itemBuilder: (context, index) {
                                  final habit = habits[index];
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0)),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      leading: getCategoryImage(habit.category),
                                      title: Text(habit.habitName,
                                          style: const TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold)),
                                      subtitle: Text(
                                          'Time Taken: ${habit.timeTaken} minutes',
                                          style: const TextStyle(
                                              color: Colors.black)),
                                      trailing: Text(
                                        habit.status,
                                        style: TextStyle(
                                            color: habit.status == 'complete'
                                                ? Colors.purple
                                                : Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      double completionRate = completionRates[index] ?? 0.0;
      int totalHabits = habitsPerDay[index] ?? 0;

      // Show the bar only if there are habits for that day
      return totalHabits > 0
          ? BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: completionRate, // Display the ratio of completed/total
                  width: 20,
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 223, 52, 241),
                      Color.fromARGB(255, 228, 106, 226),
                      Color.fromARGB(255, 240, 139, 208),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  // Add the AnimatedContainer here
                  rodStackItems: [],
                ),
              ],
            )
          : BarChartGroupData(x: index, barRods: []); // No bar if no habits
    });
  }

  Widget getCategoryImage(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Image.asset('assets/sports.png', width: 40);
      case 'study':
        return Image.asset('assets/study.png', width: 40);
      case 'work':
        return Image.asset('assets/work.png', width: 40);
      case 'food':
        return Image.asset('assets/food.png', width: 40);
      case 'sleep':
        return Image.asset('assets/sleep.png', width: 40);
      case 'worship':
        return Image.asset('assets/worship.png', width: 40);
      case 'drink':
        return Image.asset('assets/drink.png', width: 40);
      case 'entertainment':
        return Image.asset('assets/entertainment.png', width: 40);
      default:
        return Image.asset('assets/default_icon.png', width: 40);
    }
  }
}
