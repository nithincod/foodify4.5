import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/background.dart';
import 'foodify2oHealthyReceipiesPage.dart';
import 'foodify2oSnapPage.dart';
import 'foodifyInsightsPage.dart';

class TrackingFoodPage extends StatefulWidget {
  @override
  _TrackingFoodPageState createState() => _TrackingFoodPageState();
}

class _Foodify2oData {
  Future<Map<String, double>> getTotalMacronutrients(String date) async {
    Map<String, double> totalMacronutrients = {
      'protein': 0,
      'carbs': 0,
      'fat': 0,
    };

    List<String> mealTypes = ['breakfast', 'lunch', 'snacks', 'dinner'];

    for (String mealType in mealTypes) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('meals')
          .doc(date)
          .collection(mealType)
          .get();

      for (var doc in snapshot.docs) {
        totalMacronutrients['protein'] =
            (totalMacronutrients['protein'] ?? 0) + (double.tryParse(doc['protein']?.toString() ?? '0') ?? 0);
        totalMacronutrients['carbs'] =
            (totalMacronutrients['carbs'] ?? 0) + (double.tryParse(doc['carbs']?.toString() ?? '0') ?? 0);
        totalMacronutrients['fat'] =
            (totalMacronutrients['fat'] ?? 0) + (double.tryParse(doc['fat']?.toString() ?? '0') ?? 0);
      }
    }
    return totalMacronutrients;
  }
}

class _TrackingFoodPageState extends State<TrackingFoodPage> {
  Map<String, int> mealCalories = {
    'breakfast': 0,
    'lunch': 0,
    'snacks': 0,
    'dinner': 0,
  };
  Map<String, double> macronutrients = {'protein': 0, 'carbs': 0, 'fat': 0};
  

  @override
  void initState() {
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          const Background(), 
          Column(
           
            children: [
              // **App Bar Section**
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios, size: 28),
                    ),
                    const Text("Today", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const Icon(Icons.settings, size: 28),
                  ],
                ),
              ),
              
              // **Calories Summary Section**
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.restaurant, size: 60, color: Colors.orange),
                    Text("0 of 1800", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const Text("Cal Eaten", style: TextStyle(fontSize: 16, color: Colors.black87)),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              
              SizedBox(
                height: 100,
                child: ListView(
                  children: [
                    _buildInsightsCard(context),
                    _buildReciepiesCard(context),
                    _buildSnapGalleriesCard(),
                    _buildSavedMealsCard(),
                  ],
                ),
              ),
              
              
              Expanded(
                child: 
                   
                    ListView(
                        children: [
                          _buildMealSection(context, "Breakfast", "${mealCalories['breakfast'] ?? 0} of 450 Cal", "All you need is some breakfast ☀️🍳"),
                          _buildMealSection(context, "Lunch", "${mealCalories['lunch'] ?? 0} of 450 Cal", "Don't miss lunch 🍱 It's time to get a tasty meal"),
                          _buildMealSection(context, "Snack", "${mealCalories['snacks'] ?? 0} of 450 Cal", "Have a great healthy snack 🥗"),
                          _buildMealSection(context, "Dinner", "${mealCalories['dinner'] ?? 0} of 225 Cal", "Get energized by grabbing a morning snack 🥜"),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // **Meal Section Widget**
  Widget _buildMealSection(BuildContext context, String title, String calories, String subtitle) {
    return Column(
      
      children: [
        Row(
          
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(calories, style: const TextStyle(fontSize: 16, color: Colors.black87)),
               
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SnapTrackPage(
                          appBarTitle: 'Track $title',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_a_photo,
                    size: 20,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          
          height: MediaQuery.of(context).size.height * .15,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.orangeAccent,
          ),
          child: Text(subtitle, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ),
        const Divider(),
      ],
    );
  }

  
  Widget _buildInsightsCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => InsightsPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white10
          ),
          
          child: const Text('Insights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }


  Widget _buildSnapGalleriesCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white10
        ),
        
        child: const Text('SnapGalleries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  // **Recipes Card Widget**
  Widget _buildReciepiesCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RecipiesPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.white10
          ),
         
          child: const Text('Recipes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  // **Saved Meals Card Widget**
  Widget _buildSavedMealsCard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white10
        ),
        
        child: const Text('SavedMeals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}