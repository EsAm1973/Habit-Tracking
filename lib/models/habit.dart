import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String id;
  String habitName;
  int timeTaken;
  DateTime date;
  String status;
  String category;  

  Habit({
    required this.id,
    required this.habitName,
    required this.timeTaken,
    required this.date,
    required this.status,
    required this.category,  
  });

  // Convert Habit object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'habitName': habitName,
      'timeTaken': timeTaken,
      'date': date,
      'status': status,
      'category': category,  
    };
  }

  // Convert Firestore Map to Habit object
  static Habit fromMap(String id, Map<String, dynamic> map) {
    return Habit(
      id: id,
      habitName: map['habitName'],
      timeTaken: map['timeTaken'],
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'],
      category: map['category'],  // Retrieve category from the map
    );
  }

   // Helper function to create Habit from Firestore document
  static Habit fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Habit.fromMap(doc.id, data);
  }
}
