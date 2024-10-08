import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracking/models/habit.dart';

class HabitService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save habit
  Future<void> saveHabit(Habit habit) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .add(habit.toMap());
    }
  }

  // Update habit status
  Future<void> updateHabitStatus(String habitId, String status) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habitId)
          .update({
        'status': status,
      });
    }
  }

  // Fetch user habits
  Stream<List<Habit>> getUserHabits() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  Habit.fromMap(doc.id, doc.data() as Map<String, dynamic>))
              .toList());
    }
    return Stream.empty();
  }

  // Fetch habits by selected date
  Future<List<Habit>> fetchHabitsByDate(DateTime selectedDate) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('No user logged in');
    }

    // Adjusting the query to filter by date correctly
    final startOfDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    print('Fetching habits for date range: $startOfDay to $endOfDay');

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .get();

      return snapshot.docs.map((doc) {
        // Ensure you have a fromFirestore method to create Habit instances
        return Habit.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching habits: $e');
      throw Exception('Failed to fetch habits: $e');
    }
  }

  // Delete habit
  Future<void> deleteHabit(String habitId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('habits')
          .doc(habitId)
          .delete();
    }
  }

  // جلب العادات بناءً على الأسبوع الحالي أو السابق
  Future<List<Habit>> getHabitsByWeek(String week) async {
    QuerySnapshot snapshot;
    DateTime start, end;

    if (week == 'This week') {
      start = _getStartOfWeek();
      end = _getEndOfWeek();
    } else {
      start = _getStartOfPreviousWeek();
      end = _getEndOfPreviousWeek();
    }

    // Adjusting for timezone when querying
    print('Fetching habits for date range: $start to $end');

    try {
      snapshot = await _firestore
          .collection('users') // Ensure you use the correct path
          .doc(_auth.currentUser!.uid)
          .collection('habits')
          .where('date',
              isGreaterThanOrEqualTo:
                  Timestamp.fromDate(start.toUtc().add(Duration(hours: 3))))
          .where('date',
              isLessThanOrEqualTo:
                  Timestamp.fromDate(end.toUtc().add(Duration(hours: 3))))
          .get();

      print('Fetched documents: ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print('Habit data: ${doc.data()}');
      }

      return snapshot.docs.map((doc) {
        return Habit.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Error fetching habits: $e');
      throw Exception('Failed to fetch habits: $e');
    }
  }

  DateTime _getStartOfWeek() {
    DateTime now = DateTime.now();
    // نبدأ من يوم السبت (أول ساعة في اليوم)
    DateTime startOfWeek = now.subtract(Duration(days: (now.weekday % 7) + 1));
    return DateTime(
        startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
  }

  DateTime _getEndOfWeek() {
    DateTime now = DateTime.now();
    // نهاية الأسبوع تكون يوم الجمعة (آخر ثانية من اليوم)
    DateTime endOfWeek = now.add(Duration(days: 6 - (now.weekday % 7)));
    return DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
  }

  DateTime _getStartOfPreviousWeek() {
    DateTime now = DateTime.now();
    // حساب بداية الأسبوع السابق (أول ساعة من يوم السبت السابق)
    DateTime startOfPreviousWeek =
        now.subtract(Duration(days: (now.weekday % 7) + 8));
    return DateTime(startOfPreviousWeek.year, startOfPreviousWeek.month,
        startOfPreviousWeek.day, 0, 0, 0);
  }

  DateTime _getEndOfPreviousWeek() {
    DateTime now = DateTime.now();
    // حساب نهاية الأسبوع السابق (آخر ثانية من يوم الجمعة السابق)
    DateTime endOfPreviousWeek =
        now.subtract(Duration(days: (now.weekday % 7) + 2));
    return DateTime(endOfPreviousWeek.year, endOfPreviousWeek.month,
        endOfPreviousWeek.day, 23, 59, 59);
  }
}
