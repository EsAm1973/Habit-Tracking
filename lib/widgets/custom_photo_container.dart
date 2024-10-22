import 'package:flutter/material.dart';

class CustomPhotoContainer extends StatelessWidget {
  const CustomPhotoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(
                    30,
                  ),
                ),
              )),
        ),
        Align(
          alignment: const Alignment(0, 1.1),
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 150,
            width: 150,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.network(
                  "https://static.vecteezy.com/system/resources/previews/028/569/170/original/single-man-icon-people-icon-user-profile-symbol-person-symbol-businessman-stock-vector.jpg"),
            ),
          ),
        ),
      ],
    );
  }
}
