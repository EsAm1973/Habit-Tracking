import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracking/screens/login_screen.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Stack(children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.15,
              width: MediaQuery.sizeOf(context).width * 0.825,
              child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        "Are you want to logout?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: Colors.purpleAccent))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.purpleAccent,
                                  fontSize: 20,
                                ),
                              )),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purpleAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: Colors.purpleAccent))),
                              onPressed: () async {
                                GoogleSignIn googleSignIn = GoogleSignIn();
                                googleSignIn.disconnect();
                                await FirebaseAuth.instance.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                    (route) => false);
                              },
                              child: const Text(
                                "LogOut",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              )),
                          // BlocConsumer<UserCubit, UserState>(
                          //   listener: (context, state) {
                          //     if (state is AuthLoadedState) {
                          //       try {
                          //         Hive.box<UserModel>('user').clear();
                          //         Hive.box<bool>('remember_me').clear();
                          //         Hive.box<List<String>>(Constants.recentQueryBox)
                          //             .clear();
                          //       } catch (e) {
                          //         log(name: 'error', e.toString());
                          //       }
                          //       context.navigateToReplacement(
                          //         const LoginView(),
                          //       );
                          //     }
                          //   },
                          //   builder: (context, state) {
                          //     return SizedBox(
                          //       child: ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //               backgroundColor: AppColors.primaryColor,
                          //               shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(12),
                          //               )),
                          //           onPressed: () {
                          //             context.read<UserCubit>().logout();
                          //           },
                          //           child: state is AuthLoadingState
                          //               ? const CircularProgressIndicator(
                          //                   color: Colors.white,
                          //                 )
                          //               : const Text(
                          //                   "logout",
                          //                   style: TextStyle(
                          //                     fontFamily: "Montserrat",
                          //                     fontWeight: FontWeight.w400,
                          //                     color: Colors.white,
                          //                     fontSize: 20,
                          //                   ),
                          //                 )),
                          //     );
                          //   },
                          // ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: MediaQuery.sizeOf(context).height * .365,
        //   left: 50,
        //   child: Container(
        //       height: 60,
        //       width: 60,
        //       decoration: const BoxDecoration(
        //           color: Colors.purpleAccent, shape: BoxShape.circle),
        //       child: Image.asset("assets/icons/logout.png")),
        // ),
        // Positioned(
        //   top: MediaQuery.sizeOf(context).height * .475,
        //   left: 35,
        //   child: Image.asset("assets/images/dialog_decoration.png"),
        // ),
      ]),
    );
  }
}
