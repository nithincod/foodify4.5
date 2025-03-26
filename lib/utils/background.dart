import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.blueAccent, Colors.purple[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
    );
  }
}