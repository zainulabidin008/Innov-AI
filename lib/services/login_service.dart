// ignore_for_file: avoid_print

import 'package:AiHub/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../constants/app_constant.dart';

class LoginServie {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Google Login
  static googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      print('Google login result: ${googleSignInAccount.toString()}');

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        await firebaseAuth.signInWithCredential(authCredential);
        var uid = firebaseAuth.currentUser?.uid;
        storage.write(AppConst.uid, uid);
        storage.write(AppConst.chatCredit, 3);
        var doc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (!doc.exists) {
          await FirebaseFirestore.instance.collection('users').doc(uid).set({
            'chat_exp_date': '',
            'img_credit': 3,
            'img_res': '1024x1024',
            'video_credit': DateFormat('mm:ss')
                .format(DateTime.parse('2023-10-08 00:00:20')),
          });
        }

        print('Google login successfully');
        return true;
      } else {
        print('Google login cancelled');
        return false;
      }
    } catch (e) {
      print('Google login error: ${e.toString()}');
      return false;
    }
  }

  //Facebook Login
  static facebooklogin() async {
    try {
      final result = await FacebookAuth.instance
          .login(loginBehavior: LoginBehavior.webOnly);

      print("Facebook login result: ${result.accessToken!.token}");
      switch (result.status) {
        case LoginStatus.success:
          final credential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          await firebaseAuth.signInWithCredential(credential);
          var uid = firebaseAuth.currentUser?.uid;
          storage.write(AppConst.uid, uid);
          storage.write(AppConst.chatCredit, 3);
          var doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .get();

          if (!doc.exists) {
            await FirebaseFirestore.instance.collection('users').doc(uid).set({
              'chat_exp_date': '',
              'img_credit': 3,
              'img_res': '1024x1024',
              'video_credit': DateFormat('mm:ss')
                  .format(DateTime.parse('2023-10-08 00:00:20')),
            });
          }
          print('Facebook login success');
          return true;

        case LoginStatus.cancelled:
          print('Facebook login cancelled');
          return false;

        case LoginStatus.failed:
          print('Facebook login failed');
          return false;

        default:
          return false;
      }
    } catch (e) {
      print("Facebook login error: ${e.toString()}");
    }
  }
}
