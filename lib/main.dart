import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foodify2o/firebase_options.dart';
import 'widgets/gradient_container.dart';
import 'widgets/gradient_button.dart';
import 'package:foodify2o/pages/foofify2oOnboardinpage.dart';
import 'package:provider/provider.dart';
import 'services/AuthServices.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase Initialized Successfully');
  } catch (e) {
    print('Firebase Initialization Error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const GradientBackground(child: FoodifyHomePage()),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00296B), Color(0xFF003F88)], // Adjusted colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: child,
      ),
    );
  }
}

class FoodifyHomePage extends StatelessWidget {
  const FoodifyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GradientButton(
        text: "Track Now",
        onPressed: () {},
      ),
    );
  }
}
