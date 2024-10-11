import 'package:flutter/cupertino.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  const CustomContainer({super.key, this.child});

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
      child: Center(
        child: child, // Replace with your splash logo
      ),

    );
  }
}
