import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_photo_container.dart';
import '../widgets/log_out_container.dart';
import '../widgets/more_information_container.dart';
import '../widgets/my_account_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            leading: const SizedBox(),
            snap: false,
            pinned: false,
            floating: false,
            stretch: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Container(
                    color: Colors.deepPurple,
                  ),
                ),
                const CustomPhotoContainer(),
              ],
            ),
            expandedHeight: 200,
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        '${FirebaseAuth.instance.currentUser!.displayName}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${FirebaseAuth.instance.currentUser!.email}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      const MyAccountContainer(),
                      const MoreInformationContainer(),
                      const LogOutContainer(),
                    ],
                  ))),
        ],
      ),
    );
  }
}
