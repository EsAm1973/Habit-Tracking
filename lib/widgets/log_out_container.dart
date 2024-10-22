import 'package:flutter/material.dart';

import 'delete_account_dialog.dart';
import 'logout_dialog.dart';


class LogOutContainer extends StatelessWidget {
  const LogOutContainer({super.key});
 // navigateIfLoggedIn(Widget screen, BuildContext context) {
 //    if (checkIfUserISLoggedIn()) {
 //      context.navigateTo(
 //        screen,
 //      );
 //    } else {
 //      ErrorHandler.handleError(
 //          failure: ServerFailure('', statusCode: 401), context: context);
 //    }
 //  }
 //
 //  bool checkIfUserISLoggedIn() {
 //    return CacheServiceHeper()
 //            .getData<UserModel>(boxName: 'user', key: 'user') !=
 //        null;
 //  }

  @override
  Widget build(BuildContext context) {
    List<String> titles = [
      "Logout",
      "Delete Account",
    ];
    String iconsPath = "assets/icons/profile/";
    List<String> paymentIcons = [
      ("${iconsPath}logout.png"),
      ("${iconsPath}profile_delete.png"),
    ];
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 70),
      // height: MediaQuery.sizeOf(context).height*0.2,
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
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: index==0?(){
                showDialog(context: context, builder: (context){
                  return const LogoutDialog();
                });
              }:(){
                showDialog(context: context, builder: (context){
                  return const DeleteAccountDialog();
                });
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xffF4F4F4))),
                child: ListTile(
                  title: Text(
                    titles[index],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: index == 0
                          ? const Color(0xff5C5C5C)
                          : const Color(0xffDF1818),
                    ),
                  ),
                  //leading: Image.asset(paymentIcons[index]),
                ),
              ),
            );
          }),
    );
  }
}
