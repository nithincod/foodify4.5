
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodify2o/pages/foodify2oHomePage.dart';
import 'package:foodify2o/pages/foodify2oLoginPage.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
           if (snapshot.hasData){
             return Foodify2oHomePage();
           }
           else {
             return const Foodify2oLoginInView();
           }
      }
      ),
    );
  }
}
