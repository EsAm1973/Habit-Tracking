import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracking/screens/login_screen.dart';
import 'package:habit_tracking/widgets/custom_TextWithAction.dart';
import 'package:habit_tracking/widgets/custom_text_field.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // تحديث displayName بالاسم الكامل
        await userCredential.user!
            .updateDisplayName(_fullNameController.text.trim());

        // تأكد من إعادة تحميل البيانات المحدثة للمستخدم
        await userCredential.user!.reload();

        // إرسال رابط التحقق إلى البريد الإلكتروني
        await userCredential.user!.sendEmailVerification();

        // عرض رسالة تأكيد بأن رابط التحقق تم إرساله
        _showVerificationDialog();
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            _showErrorDialog("This email is already in use.");
            break;
          case 'invalid-email':
            _showErrorDialog("The email address is not valid.");
            break;
          case 'operation-not-allowed':
            _showErrorDialog("Email/Password accounts are not enabled.");
            break;
          case 'weak-password':
            _showErrorDialog("The password is too weak.");
            break;
          default:
            _showErrorDialog(e.message ?? "An error occurred");
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.topSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {
        // Optionally do something on OK press
      },
    ).show();
  }

  void _showVerificationDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.topSlide,
      title: 'Verification Email Sent',
      desc:
          'A verification link has been sent to your email. Please check your inbox.',
      btnOkOnPress: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    bool isDesktop = screenWidth >= 1024;

    double horizontalPadding = isDesktop
        ? screenWidth * 0.1
        : (isTablet ? screenWidth * 0.07 : screenWidth * 0.05);
    double verticalPadding =
        isDesktop || isTablet ? screenHeight * 0.08 : screenHeight * 0.05;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.redAccent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff8264de), Color(0xfff0b2ee)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: verticalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Create Your",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: isDesktop
                                ? screenWidth * 0.05
                                : screenWidth * 0.08,
                          ),
                        ),
                        Text(
                          "Account",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: isDesktop
                                ? screenWidth * 0.05
                                : screenWidth * 0.08,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              customTextFormField(
                                controller: _fullNameController,
                                labelText: 'Full Name',
                                hintText: 'Mahmoud Mustafa',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              customTextFormField(
                                controller: _emailController,
                                labelText: 'Email',
                                hintText: 'example@gmail.com',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              customTextFormField(
                                controller: _passwordController,
                                labelText: 'Password',
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              customTextFormField(
                                controller: _confirmPasswordController,
                                labelText: 'Confirm Password',
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  } else if (value !=
                                      _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: isTablet || isDesktop ? 70 : 55),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.02),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                                onPressed: _signUp,
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xff8264de),
                                        Color(0xfff0b2ee)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02),
                                    child: Text(
                                      'SIGN UP',
                                      style: TextStyle(
                                        fontSize: isDesktop
                                            ? screenWidth * 0.04
                                            : screenWidth * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              customTextWithAction(
                                mainText: "already have an account? ",
                                actionText: "Sign In",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                mainTextColor: Colors.black,
                                actionTextColor: const Color(0xff8264de),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
