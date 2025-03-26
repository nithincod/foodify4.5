import 'package:cloud_firestore/cloud_firestore.dart';

class _Foodify2oData {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getTotalCalories(String date) async {
    Map<String, int> mealCalories = {
      'breakfast': 0,
      'lunch': 0,
      'Snacks': 0,
      'Dinner': 0,
    };

    for (String mealType in mealCalories.keys) {
      QuerySnapshot snapshot = await _firestore
          .collection('meals')
          .doc(date)
          .collection(mealType)
          .get();

      int totalCalories = snapshot.docs.fold(0, (sum, doc) {
        int calories = int.tryParse(doc['calories'] ?? '0') ?? 0;
        return sum + calories;
      });

      mealCalories[mealType] = totalCalories;
    }
    return mealCalories;
  }
}