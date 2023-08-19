// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rento/screens/Authentication/forgotPassword/finish_forgot_password.dart';
import 'package:rento/screens/account/confirm/confirm_email/confirm_email.dart';
import 'package:rento/screens/account/confirm/confirm_email/finish_to_confirm_email.dart';
import 'package:rento/screens/main/main_screen.dart';
import 'package:rento/utils/show_snack_bar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  FirebaseAuthMethods();

  // SIGN UP WITH EMAIL
  Future<String> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    String response = '';
    try {
      // REGISTER USER
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ADD USER TO DATABSE
      await _fireStore.collection('users').doc(userCredential.user!.uid).set(
        {
          'firstname': firstName,
          'lastname': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
        },
      );

      response = 'success';

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return const ConfirmEmail();
          },
        ),
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case 'auth/email-already-in-use':
          response =
              "Email already is in use by another account, please try another email";
          break;
        case "invalid-email":
          response = "Invalid email address";
          break;

        default:
          response = error.message!;
      }
    }
    return response;
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification({
    required BuildContext context,
  }) async {
    try {
      await _auth.currentUser!.sendEmailVerification();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return const FinishToComfirmEmail();
          },
        ),
      );
    } on FirebaseAuthException catch (err) {
      String errorMessage;

      switch (err.code) {
        case "user-disabled":
          errorMessage = "User account disabled";
          break;

        case "too-many-attempts":
          errorMessage = "Too many attempts. Please try again later";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Email/password accounts are not enabled. Please contact support";
          break;
        default:
          errorMessage = err.message!;
      }

      showSnackBar(context, errorMessage);
    }
  }

  // LOGIN WITH EMAIL
  Future<String> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String response = '';
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      response = 'success';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) {
            return const MainScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (error) {
      switch (error.code.toString()) {
        case "invalid-email":
          response = "Invalid email address";
          break;
        case 'wrong-password':
          response = "Incorrect password, enter a correct password";
          break;
        case "user-not-found":
          response = "User not found, please sign up";
          break;
        case "user-disabled":
          response = "User account disabled, please contact Rento support";
          break;
        case "too-many-attempts":
          response = "Too many login attempts. Please try again later";
          break;
        case "operation-not-allowed":
          response = "Account not enabled. Please contact Rento support";
          break;
        default:
          response = error.message!;
      }
    }
    return response;
  }

  // FOGOT PASSWORD
  Future<void> forgotPassword({
    required email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
        return FinishForgotPassword(email: email);
      }));
    } on FirebaseAuthException catch (err) {
      String errorMessage;
      switch (err.code) {
        case "user-disabled":
          errorMessage = "User account disabled";
          break;
        case "unknown":
          errorMessage = "Too many attempts. Please try again later";
          break;
        case "operation-not-allowed":
          errorMessage =
              "Email/password accounts are not enabled. Please contact support";
          break;
        default:
          errorMessage = err.message!;
      }

      showSnackBar(context, errorMessage);
    }
  }
}
