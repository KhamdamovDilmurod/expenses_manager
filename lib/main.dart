import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_manager/api/firestore_db_service.dart';
import 'package:expenses_manager/firebase_options.dart';
import 'package:expenses_manager/screen/auth/auth_screen.dart';
import 'package:expenses_manager/screen/main/kirim/kirimlar_screen.dart';
import 'package:expenses_manager/screen/main/main_screen.dart';
import 'package:expenses_manager/screen/pdf_screen/pdf_screen.dart';
import 'package:expenses_manager/screen/report/report_screen.dart';
import 'package:expenses_manager/screen/splash/splash_screen.dart';
import 'package:expenses_manager/utils/pref_utils.dart';
import 'package:expenses_manager/views/report_item_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await PrefUtils.initInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(
            210,
            224,
            251,
            1,
          ),
        ),
      ),
      home: MainScreen(),
    );
  }
}
