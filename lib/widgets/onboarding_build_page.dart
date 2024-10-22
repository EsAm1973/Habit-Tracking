import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../classes/colors.dart';

Widget buildPage({
  required String title,
  required String description,
  required String image,
}) {
  return Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          image,
          height: 300.h, // Ensure consistent height
          fit: BoxFit.cover, // Use BoxFit.cover or BoxFit.contain
        ),
        SizedBox(height: 20.h),
        Text(
          title,
          style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold,color:MyColors.purple ),
        ),
        SizedBox(height: 10.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.sp, color: Colors.black),
        ),
      ],
    ),
  );
}