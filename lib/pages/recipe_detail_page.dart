import 'package:flutter/material.dart';
import 'package:foodify2o/services/food_api_service.dart';

class RecipeDetailPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailPage({Key? key, required this.recipeId}) : super(key: key);

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late Future<Map<String, dynamic>> _recipeFuture;
  final FoodApiService _apiService = FoodApiService();

  @override
  void initState() {
    super.initState();
    _recipeFuture = _apiService.getRecipeDetails(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final recipe = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    recipe['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildRecipeMeta(recipe),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Summary'),
                      const SizedBox(height: 10),
                      _buildRecipeSummary(recipe),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Ingredients'),
                      const SizedBox(height: 10),
                      _buildIngredientsList(recipe),
                      const SizedBox(height: 20),
                      _buildSectionTitle('Nutrition'),
                      const SizedBox(height: 10),
                      _buildNutritionInfo(recipe),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecipeMeta(Map<String, dynamic> recipe) {
    return Row(
      children: [
        if (recipe['readyInMinutes'] != null)
          _buildMetaChip(Icons.timer, '${recipe['readyInMinutes']} mins'),
        if (recipe['servings'] != null)
          _buildMetaChip(Icons.people, '${recipe['servings']} servings'),
        if (recipe['vegetarian'] == true)
          _buildMetaChip(Icons.eco, 'Vegetarian'),
      ],
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Chip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildRecipeSummary(Map<String, dynamic> recipe) {
    return Text(
      recipe['summary']?.replaceAll(RegExp(r'<[^>]*>'), '') ?? 'No summary available',
    );
  }

  Widget _buildIngredientsList(Map<String, dynamic> recipe) {
    final ingredients = recipe['extendedIngredients'] as List? ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients.map((ingredient) => 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text('• ${ingredient['original']}'),
        ),
      ).toList(),
    );
  }

  Widget _buildNutritionInfo(Map<String, dynamic> recipe) {
    final nutrition = recipe['nutrition'];
    if (nutrition == null) return const Text('Nutrition data not available');

    final nutrients = nutrition['nutrients'] as List? ?? [];
    return Column(
      children: nutrients.take(5).map((nutrient) => 
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Expanded(child: Text(nutrient['name'])),
              Text('${nutrient['amount']?.toStringAsFixed(1)} ${nutrient['unit']}'),
            ],
          ),
        ),
      ).toList(),
    );
  }
}