import 'package:flutter/material.dart';
import 'gradient_container.dart';

class FoodCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const FoodCard({Key? key, required this.title, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Card(
        elevation: 0, // No extra elevation, as GradientContainer adds shadow
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            Image.network(imageUrl, height: 120, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
