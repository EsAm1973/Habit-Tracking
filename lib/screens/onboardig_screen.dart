import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_tracking/screens/home_page.dart';
import '../classes/colors.dart';
import '../widgets/custom_container.dart';
import '../widgets/onboarding_build_page.dart';


class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Get Started',
        finishButtonStyle: FinishButtonStyle(backgroundColor: MyColors.purple,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32),)),
        finishButtonTextStyle: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
        ),
        skipTextButton: Text(
          'Skip',
          style: TextStyle(
            color: MyColors.purple,
            fontSize: 16.sp,
          ),
        ),
        trailing: Icon(
          color: MyColors.purple,
          Icons.arrow_forward,
        ),
        controllerColor:MyColors.purple,
        background: [
          CustomContainer(),
          CustomContainer(),
          CustomContainer(),
        ],
        totalPage: 3,
        speed: 3,
        pageBodies: [
          buildPage(
            title: "Are you ready ? ",
            description: "We will help you to built some habits and learn skills ",
            image: 'assets/Animation - 1728606856706.json',
          ),
          buildPage(
            title: "Track Your Progress",
            description: "Add healthy habits and set a daily or weekly timer for practicing your habits ",
            image: 'assets/Animation - 1728253205424.json',
          ),
          buildPage(
            title: "Achieve Your Goals",
            description: "Set and reach your personal goals.",
            image: 'assets/Animation - 1728607284420.json',
          ),
        ],
        onFinish: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
      ),
    );
  }
}


