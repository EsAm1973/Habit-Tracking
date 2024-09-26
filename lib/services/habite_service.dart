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
}
