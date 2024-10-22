import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import 'Onboardig_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => (FirebaseAuth.instance.currentUser != null &&
                    FirebaseAuth.instance.currentUser!.emailVerified)
                ? ButtonNavBar()
                : OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff8264de), Color(0xfff0b2ee)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 300.h,
              child: Lottie.asset('assets/Animation - 1728606717399.json'),
            ),
          ),
          TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: Duration(seconds: 2), // Duration of the animation
              builder: (context, opacity, child) {
                return Opacity(
                  opacity: opacity,
                  child: child,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0), // Add some padding
                child: Text(
                  "Habit Hive",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none, // Ensure no underline
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
