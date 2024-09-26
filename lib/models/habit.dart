import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  final String id;
  final String habitName; // Ensure this matches the field in Firestore
  final String category; // Ensure this matches the field in Firestore
  final int timeTaken; // Ensure this matches the field in Firestore
  final DateTime date; // Storing the date as DateTime
  final String status; // Ensure this matches the field in Firestore

  Habit({
    required this.id,
    required this.habitName,
    required this.category,
    required this.timeTaken,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'habitName': habitName,
      'category': category,
      'timeTaken': timeTaken,
      'date':
          Timestamp.fromDate(date), // Convert DateTime to Firestore Timestamp
      'status': status,
    };
  }

  // Factory method to create a Habit from a Map (e.g., Firestore document data)
  factory Habit.fromMap(String id, Map<String, dynamic> data) {
    return Habit(
      id: id,
      habitName: data['habitName'] as String, // Ensure this matches Firestore
      category: data['category'] as String, // Ensure this matches Firestore
      timeTaken: data['timeTaken'] as int, // Ensure this matches Firestore
      date: (data['date'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
      status: data['status'] as String, // Ensure this matches Firestore
    );
  }
}
