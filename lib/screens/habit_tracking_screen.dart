import 'package:flutter/material.dart';
import 'dart:async';

import 'package:habit_tracking/services/habite_service.dart';

class HabitTrackingScreen extends StatefulWidget {
  final String habitId; // إضافة habitId
  final String habitName;
  final int durationMinutes;
  final Widget habitImage;

  HabitTrackingScreen({
    required this.habitId, // إضافة habitId
    required this.habitName,
    required this.durationMinutes,
    required this.habitImage,
  });

  @override
  _HabitTrackingScreenState createState() => _HabitTrackingScreenState();
}

class _HabitTrackingScreenState extends State<HabitTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  final HabitService _habitService = HabitService(); // إضافة HabitService

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60; // تحويل الدقائق إلى ثواني
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _remainingSeconds),
    );
  }

  void _startTimer() {
    if (!_isRunning) {
      setState(() {
        _isRunning = true;
        _animationController.forward();
      });
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _completeHabit(); // إنهاء العادة عند انتهاء المؤقت
          }
        });
      });
    }
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
      _timer?.cancel();
      _animationController.stop();
    });
  }

  void _completeHabit() async {
    _timer?.cancel();
    _animationController.stop();

    // تحديث حالة العادة إلى 'completed'
    await _habitService.updateHabitStatus(widget.habitId, 'complete');

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habitName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _animationController.value,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
                Container(
                  width: 160,
                  height: 160,
                  child: widget.habitImage,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: _pauseTimer,
                  child: Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: _completeHabit, // استدعاء _completeHabit عند النقر
                  child: Text('Complete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
