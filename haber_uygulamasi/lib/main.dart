import 'package:animated_splash/animated_splash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haber_uygulamasi/Sayfalar/anasayfa.dart';
import 'package:haber_uygulamasi/Sayfalar/detay.dart';
import 'package:haber_uygulamasi/data/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'data/sharedprefs.dart';

void main() async {
  timeago.setLocaleMessages('tr', timeago.TrMessages());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs.initialize();
  runApp(MyApp());
}

class MyApp extends GetWidget<LoginIslemleri> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Blog Uygulaması',
      home: AnaSayfa1(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // other properties...
      ),
      theme: ThemeData(
          fontFamily: 'Montserrat',
          accentColor: Colors.green,
          brightness: Brightness.light,
          primaryColor: Colors.white),
    );
  }
}

class AnaSayfa1 extends StatefulWidget {
  @override
  _AnaSayfa1State createState() => _AnaSayfa1State();
}

class _AnaSayfa1State extends State<AnaSayfa1> {
  @override
  initState() {
    // TODO: implement initState
    super.initState();
    var _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        final data = message['data'];
        if (data['page'] != null) {
          tiklananBildirim(message['id']);
        }
      },
    );
    run();
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future run() async {
    //await onerilenler("Teknoloji");
    await veriGetir();
    await getDocs(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedSplash(
      imagePath: 'assets/logo.png',
      home: AnaSayfa(),
      duration: 2500,
      type: AnimatedSplashType.StaticDuration,
    ));
  }
}
