import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_tracking/screens/home_page.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    UserCredential? userCredential;

    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      userCredential =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        _showMessage(context, "Sign-in cancelled.");
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    }

    if (userCredential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      _showMessage(context, "Failed to sign in. Please try again.");
    }
  } catch (e) {
    if (e is FirebaseAuthException) {
      if (e.code == 'popup-closed-by-user') {
        _showMessage(context, "Sign-in process was closed.");
      } else if (e.code == 'cancelled-popup-request') {
        _showMessage(context, "Another sign-in process is ongoing.");
      } else {
        _showMessage(context, "Error during sign-in: ${e.message}");
      }
    } else {
      _showMessage(context, "An unexpected error occurred. Please try again.");
    }
    print("Error during Google sign-in: $e");
  }
}

void _showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
