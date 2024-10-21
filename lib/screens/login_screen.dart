import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracking/screens/sign_up_screen.dart';
import 'package:habit_tracking/services/animation_enum.dart';
import 'package:habit_tracking/widgets/buttom_nav_bar.dart';
import 'package:habit_tracking/widgets/custom_TextWithAction.dart';
import 'package:rive/rive.dart' as rive;
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  rive.Artboard? riveArtboard;
  late rive.RiveAnimationController controllerIdle;
  late rive.RiveAnimationController controllerHandsUp;
  late rive.RiveAnimationController controllerHandsDown;
  late rive.RiveAnimationController controllerLookLeft;
  late rive.RiveAnimationController controllerLookRight;
  late rive.RiveAnimationController controllerSuccess;
  late rive.RiveAnimationController controllerFail;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();

  bool isLookingLeft = false;
  bool isLookingRight = false;
  bool _isPasswordVisible = false;

  void removeAllControllers() {
    riveArtboard?.artboard.removeController(controllerIdle);
    riveArtboard?.artboard.removeController(controllerHandsUp);
    riveArtboard?.artboard.removeController(controllerHandsDown);
    riveArtboard?.artboard.removeController(controllerLookLeft);
    riveArtboard?.artboard.removeController(controllerLookRight);
    riveArtboard?.artboard.removeController(controllerSuccess);
    riveArtboard?.artboard.removeController(controllerFail);
    isLookingLeft = false;
    isLookingRight = false;
  }

  void addSpecifcAnimationAction(
      rive.RiveAnimationController<dynamic> neededAnimationAction) {
    removeAllControllers();
    riveArtboard?.artboard.addController(neededAnimationAction);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void checkForPasswordFocusNodeToChangeAnimationState() {
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        addSpecifcAnimationAction(controllerHandsUp);
      } else {
        addSpecifcAnimationAction(controllerHandsDown);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controllerIdle = rive.SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = rive.SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = rive.SimpleAnimation(AnimationEnum.hands_down.name);
    controllerLookRight =
        rive.SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookLeft =
        rive.SimpleAnimation(AnimationEnum.Look_down_left.name);
    controllerSuccess = rive.SimpleAnimation(AnimationEnum.success.name);
    controllerFail = rive.SimpleAnimation(AnimationEnum.fail.name);

    loadRiveFileWithItsStates();
    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void loadRiveFileWithItsStates() async {
    await rive.RiveFile.initialize();

    rootBundle.load('assets/login_anim.riv').then(
      (data) {
        final file = rive.RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.addController(controllerIdle);
        setState(() {
          riveArtboard = artboard;
        });
      },
    );
  }

  void validateEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        //if the user verify your email go to homepage.
        if (credential.user!.emailVerified) {
          addSpecifcAnimationAction(controllerSuccess);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ButtonNavBar()),
          );
        } else {
          //else show dialog to go to email to verify account
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Verified Email',
            desc: 'Please go to your email and verify the account',
          ).show();
        }
      } on FirebaseAuthException catch (e) {
        addSpecifcAnimationAction(controllerFail);

        if (e.code == 'user-not-found') {
          // Show dialog for non-existent email
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: 'The email you entered does not exist.',
            btnOkOnPress: () {},
          ).show();
        } else if (e.code == 'wrong-password') {
          // Show dialog for incorrect password
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: 'The password you entered is incorrect.',
            btnOkOnPress: () {},
          ).show();
        } else {
          // General error dialog
          AwesomeDialog(
            context: context,
            dialogType: DialogType.error,
            title: 'Error',
            desc: e.message ?? 'An error occurred. Please try again.',
            btnOkOnPress: () {},
          ).show();
        }
      }
    } else {
      addSpecifcAnimationAction(controllerFail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8264de), Color(0xfff0b2ee)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 20,
                vertical: MediaQuery.of(context).size.height / 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hello",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign in!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30),
                  ),
                ),
                const SizedBox(height: 8),
                // استخدام Expanded هنا لتوزيع المساحة المتاحة
                Expanded(
                  flex: 1, // هذا التوسيع يملأ المساحة المتبقية
                  child: riveArtboard == null
                      ? const SizedBox.shrink()
                      : rive.Rive(
                          artboard: riveArtboard!,
                        ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 25),
                      TextFormField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        focusNode: passwordFocusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 18),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 8,
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            passwordFocusNode.unfocus();
                            validateEmailAndPassword();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      customTextWithAction(
                        mainText: "Don't have an account? ",
                        actionText: "Sign up",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Signupscreen()),
                          );
                        },
                        mainTextColor: Colors.white,
                        actionTextColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
