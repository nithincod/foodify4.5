import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodify2o/firebase_options.dart';
import 'package:foodify2o/pages/foofify2oOnboardinpage.dart';
import 'package:provider/provider.dart';

import 'services/AuthServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FoodifyOnboardingPage(),
      ),
    );
  }
}
