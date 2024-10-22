import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';

import 'package:habit_tracking/services/habite_service.dart';

class HabitTrackingScreen extends StatefulWidget {
  final String habitId;
  final String habitName;
  final int durationMinutes;
  final Widget habitImage;

  const HabitTrackingScreen({
    super.key,
    required this.habitId,
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
  final HabitService _habitService = HabitService();

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
        _animationController.forward(); // يبدأ الانيميشن
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        title: Text(
          widget.habitName,
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB3E5FC),
        foregroundColor: Colors.deepPurple,
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
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180.w,
                  height: 180.h,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _animationController.value, // القيمة المتغيرة
                        strokeWidth: 15.w,
                        backgroundColor:
                            const Color.fromARGB(255, 252, 252, 252),
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple.shade600),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: widget.habitImage,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 30),
            Text(
              'Time Left',
              style:
                  TextStyle(fontSize: 20.sp, color: Colors.deepPurple.shade600),
            ),
            Text(
              "${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
              style: TextStyle(
                  fontSize: 35.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: _pauseTimer,
                  icon: Icon(
                    Icons.pause,
                    size: 40.r,
                    color: Colors.deepPurple,
                  ),
                ),
                Container(
                  width: 70.w,
                  height: 60.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: Colors.deepPurple,
                  ),
                  child: IconButton(
                    onPressed: _completeHabit,
                    icon: Icon(
                      Icons.check_circle_outline_sharp,
                      color: Colors.white,
                      size: 40.r,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isRunning ? null : _startTimer,
                  icon: Icon(
                    Icons.play_arrow_outlined,
                    size: 40.r,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
         
            Image.asset(
              'assets/running.png',
              width: 250.w,
              height: 140.h,
            ),
          ],
        ),
      ),
    );
  }
}
