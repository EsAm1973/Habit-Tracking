import 'package:flutter/material.dart';
import 'package:habit_tracking/screens/contact_us_view.dart';
import 'package:habit_tracking/screens/privacy_policy_view.dart';
import 'package:habit_tracking/screens/terms_and_conditions_view.dart';

import '../screens/about_us_view.dart';


class MoreInformationContainer extends StatelessWidget {
  const MoreInformationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
     // "Language",
      "About Us",
      "Terms & Conditions",
      "Contact Us",
      "Privacy Policy",
      //"Theme",
    ];
    List<String> icons = [
      "global",
      "info",
      "conditions",
      "headphone",
      "privacy",
      "theme",
    ];
    List onChanged = [
      const AboutUsView(),
      const TermsAndConditionsView(),
      const ContactUsView(),
      const PrivacyPolicyView(),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 32,
        ),
        const Text(
          "More Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          //   height: MediaQuery.sizeOf(context).height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap:  () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => onChanged[index]));
                            },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffF4F4F4))),
                    child: ListTile(
                      title: Text(
                        titles[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5C5C5C),
                        ),
                      ),
                      trailing:
                      Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
