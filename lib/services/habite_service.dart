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
    // Convert selectedDate to the required format
    final formattedDate = Timestamp.fromDate(selectedDate);

    // Get current logged-in user ID
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      throw Exception('No user logged in');
    }

    // Fetch habits for the logged-in user filtered by date
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .where('habitDate', isEqualTo: formattedDate)
        .get();

    // Map the Firebase docs to Habit objects
    return snapshot.docs.map((doc) => Habit.fromFirestore(doc)).toList();
  }
}
