import 'package:flutter/material.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: const Text("Privacy Policy" ,style: TextStyle(
                color: Colors.white
            ), ),
            centerTitle: true,
            leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              icon:
              const Icon(Icons.arrow_back_ios_new , color: Colors.white, size: 30,),),
            snap: false,
            pinned: false,
            floating: false,
            stretch: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background:
                  Stack(
                    children: [
                      Container(
                        color: Colors.deepPurple,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 30,
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
                    ],
                  ),
                ),

              ],
            ),
            expandedHeight: 130,
          ),
          const SliverToBoxAdapter(
              child: Padding(
                  padding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Column(
                    children: [
                      Text("At our app, we are committed to protecting your privacy. We collect personal information like your name, email, and habit-related data when you sign up. We also gather usage data, device information, and, with your consent, location data to improve your experience.We use this information to manage your account, track your habits, personalize your experience, and send you notifications. We may share your data with trusted third-party service providers or in response to legal requirements, but we do not sell your personal information.You have rights to access, correct, delete, or object to the use of your data. We take reasonable steps to secure your information, but no system is completely secure. We retain your data for as long as necessary to fulfill the purposes of the app or comply with legal requirements. Our app is not intended for children under [insert age], and we do not knowingly collect information from them. We may update this policy, and will notify you of significant changes. For any questions, you can contact us at." , style: TextStyle(fontSize: 18),)
                    ],
                  ))
          ),
        ],
      ),
    );
  }
}
