import 'package:flutter/material.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverAppBar(
            title: const Text(
              "Terms And Conditions",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 30,
              ),
            ),
            snap: false,
            pinned: false,
            floating: false,
            stretch: true,
            flexibleSpace: Stack(
              children: [
                FlexibleSpaceBar(
                  background: Stack(
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
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to Our App. By downloading, installing, or using the App, you agree to be bound by the following Terms and Conditions. Please read these Terms carefully before using the App. If you do not agree to these Terms, you should not use the App.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "1. Acceptance of Terms",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "By accessing or using the App, you confirm that you have read, understood, and agree to these Terms, as well as our Privacy Policy. These Terms apply to all users of the App, including those who use it for tracking habits or any other services we may offer.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "2. Eligibility",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "You must be at least [insert age, typically 13 or 16] years old to use the App. By using the App, you confirm that you meet this age requirement. If you are under the required age, you may only use the App under the supervision of a parent or guardian who agrees to be bound by these Terms.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "3. User Responsibilities",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Provide accurate and up-to-date information when setting up your account.Use the App for personal, non-commercial purposes only.Not engage in any activity that interferes with or disrupts the functioning of the App or its services.Not use the App for any illegal or unauthorized purposes.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "4. Account Security",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "You are responsible for maintaining the confidentiality of your account credentials (username, password) and for all activities that occur under your account. If you believe your account has been compromised, please notify us immediately.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "5. Intellectual Property",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "All content, features, and functionality of the App, including but not limited to text, graphics, logos, images, and software, are the property of our app or its licensors and are protected by copyright, trademark, and other intellectual property laws. You agree not to copy, modify, distribute, or create derivative works from any part of the App without our prior written consent.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "6. Privacy",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Your privacy is important to us. Please review our [Privacy Policy] to understand how we collect, use, and protect your personal information while using the App.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "7. Limitations of Liability",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "To the maximum extent permitted by law, and its team shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising from your use of the App. We do not guarantee that the App will meet your specific requirements, operate uninterrupted, or be error-free.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "8. Termination",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "We reserve the right to terminate or suspend your access to the App at any time, without notice or liability, for any reason, including but not limited to your violation of these Terms.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "9. Changes to Terms",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "We may update or modify these Terms from time to time. We will notify you of any significant changes by posting the new Terms in the App or by other communication. Your continued use of the App after the changes have been made constitutes acceptance of the new Terms.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "10. Governing Law",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "These Terms shall be governed by and construed in accordance with the laws of Egypt. Any disputes arising from these Terms or the use of the App will be subject to the exclusive jurisdiction of the courts.",
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }
}
