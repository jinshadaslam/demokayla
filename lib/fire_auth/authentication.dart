import 'package:demokayla/ui/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';

class Fire_auth {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';

  Future<void> login(
      {required BuildContext context,
      required email,
      required password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          print("User logged in: ${userCredential.user!.uid}");
          // Only navigate if email is verified
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home_page()),
          );
        } else {
          print("User's email is not verified.");
          // Display a message to the user or handle as needed.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Your email is not verified. Please verify your email before logging in.")),
          );
        }
      } else {
        print("Login failed.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Login failed. Check your credentials.")),
        );
      }
    } catch (e) {
      // Handle login errors
      print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login failed. Check your credentials.")),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Sign out the user before signing in with Google
      await _auth.signOut();
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;
      final AdditionalUserInfo? additionalUserInfo =
          userCredential.additionalUserInfo;

      print('Signed in with Google:$user');
      print('User ID: ${user?.uid}');
      print('Email: ${user?.email}');
      print('Display Name: ${user?.displayName}');
      print('Provider ID: ${additionalUserInfo?.providerId}');
      print('token: ${user?.refreshToken}');
      print('token: ${user?.multiFactor}');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home_page()),
      );
    } catch (error) {
      if (error is PlatformException && error.code == 'network_error') {
        print('Network error. Please check your network connection.');
        // You can also show an error message to the user.
      } else {
        print('Sign in with Google failed: $error');
        // Handle other types of errors as needed.
      }
    }
  }

  Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      // await userCredential.user?.sendEmailVerification();

      // Navigate to a verification page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home_page(),
        ),
      );
    } catch (e) {
      // Handle registration errors
      print("Registration error: $e");

      final snackBar = SnackBar(
        content:
            Text("Registration failed. Please check your input and try again."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _forgotPassword({
    required BuildContext context,
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password reset email sent. Check your inbox.")),
      );
    } catch (e) {
      print("Forgot Password error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Password reset failed. Check your email address.")),
      );
    }
  }
}
