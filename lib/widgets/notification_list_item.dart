import 'package:flutter/material.dart';

class NotificationListItem extends StatelessWidget {
  const NotificationListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(
        top: 18,
        left: 16,
        right: 8,
      ),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(
            0xffF3F3F3,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 32,
            width: 32,
            child: Icon(Icons.notifications),
          ),
          const SizedBox(
            height: 12,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('App Update'),
              Text(
                '''new update out now! Discover improved
productivity tools and more''',

              )
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xff212227),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              '1',
            ),
          ),
        ],
      ),
    );
  }
}
