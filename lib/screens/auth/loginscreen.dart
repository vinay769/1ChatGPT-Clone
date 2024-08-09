import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talkito1/helper/dialog.dart';
import 'package:talkito1/screens/homescreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../apis/api.dart';
import '../../main.dart';

class loginscreens extends StatefulWidget {
  const loginscreens({super.key});

  @override
  State<loginscreens> createState() => _loginscreensState();
}

class _loginscreensState extends State<loginscreens> {
  bool _isAnimate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  _handelGoogleBtnClick() {
    signInWithGoogle().then((user) async {
      dialogs.showProgressBar(context);
      if (user != null) {
        Navigator.pop(context);
        log('\nUser : ${user.user}' as num);
        log('\nUserAdditionalInfo : ${user.additionalUserInfo}' as num);

        if (await Apis.userexists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const homescreens()));
        } else {
          await Apis.createuser();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const homescreens()));
        }
      }
    });
  }

  // copied from federated identity from google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await Apis.auth.signInWithCredential(credential);
    } catch (e) {
      log('\signInWithGoogle : $e' as num);
      dialogs.showSnackBar(context, "something went wrong");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    /* mq = MediaQuery.of(context).size;*/
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome To TalkiTO'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: mq.height * .15,
              width: mq.width * .25,
              right: _isAnimate ? mq.width * .37 : -mq.width * .5,
              duration: Duration(milliseconds: 1000),
              child: Image.asset('images/conversation.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width * .70,
              left: mq.width * .15,
              height: mq.height * .05,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0XFF76ABAE)),
                  onPressed: () {
                    _handelGoogleBtnClick();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Image.asset('images/google.png',
                        height: mq.height * .07),
                  ),
                  label: RichText(
                    text: const TextSpan(children: [
                      TextSpan(text: 'Login With'),
                      TextSpan(
                          text: ' Google',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          )),
                    ]),
                  ))),
        ],
      ),
    );
  }
}
