import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkito1/apis/api.dart';
import 'package:talkito1/screens/auth/loginscreen.dart';
import 'package:talkito1/screens/homescreen.dart';

import '../../main.dart';

class splashscreens extends StatefulWidget {
  const splashscreens({super.key});

  @override
  State<splashscreens> createState() => _splashscreensState();
}

class _splashscreensState extends State<splashscreens> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Color(0XFF76ABAE)));
      // Check if a user is signed in
      if (Apis.auth.currentUser != null) {
        log('\nUser : ${Apis.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => homescreens()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => loginscreens()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome To TalkiTO'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              width: mq.width * .25,
              right: mq.width * .37,
              child: Image.asset('images/conversation.png')),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Center(
                child: Text(
                  'MADE IN DUBAI 󠁡󠁥󠁤󠁵󠁿',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Color(0XFF76ABAE),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
