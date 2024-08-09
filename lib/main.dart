
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:talkito1/screens/auth/loginscreen.dart';
//import 'package:talkito1/screens/homescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:talkito1/screens/splashscreen.dart';
import 'firebase_options.dart';

// GLOBLE SIZE IN ANY DEVICE
late Size mq;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initialziedFirebase();
  runApp( myapp());
}
class myapp extends StatelessWidget {
  const myapp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TalkiTO',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0XFFEEEEEE),
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(color: Color(0XFF222831)),
          titleTextStyle: TextStyle(
                color: Color(0XFF222831), // Set color to red
                fontWeight: FontWeight.w700,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ),
          ),
      home: splashscreens(),
    );
  }
}

_initialziedFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
