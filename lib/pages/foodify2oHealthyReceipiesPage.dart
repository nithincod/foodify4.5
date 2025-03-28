import 'package:flutter/material.dart';
import '../services/food_api_service.dart';
import '../utils/background.dart';

class RecipiesPage extends StatefulWidget {
  const RecipiesPage({super.key});

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {
  final TextEditingController textController = TextEditingController();
  final FoodApiService apiService = FoodApiService();
  bool isLoading = false;

  final List<String> topCategories = [
    "Sabzis, Dals and Curries",
    "Rotis And Parathas",
    "Idlis and Dosas",
    "Sweets and Desserts"
  ];

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthy Recipes', style: TextStyle(color: Colors.white)),
      body: Stack(
        children: [
          const Background(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchField(),
                const SizedBox(height: 20),
                _buildTopCategories(),
                Expanded(
                  child: ListView(
                    children: [
                      _buildCategorySection('Rice Based Dishes'),
                      _buildCategorySection('Salads'),
                      _buildCategorySection('Fruit Juices'),
                      _buildCategorySection('Vegetarian Dishes'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: "Search recipes...",
        prefixIcon: const Icon(Icons.search, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: _searchRecipes,
        ),
      ),
    );
  }

  Widget _buildTopCategories() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topCategories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showCategoryRecipes(topCategories[index]),
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    topCategories[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategorySection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: FutureBuilder<List<dynamic>>(
            future: apiService.searchRecipes(title),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerLoading();
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              return _buildRecipeList(snapshot.data ?? []);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 150,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  Widget _buildRecipeList(List<dynamic> recipes) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index]['recipe'];
        return GestureDetector(
          onTap: () => _showRecipeDetails(recipe),
          child: Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(recipe['image']),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  recipe['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _searchRecipes() async {
    if (textController.text.isEmpty) return;
    setState(() => isLoading = true);
    try {
      final results = await apiService.searchRecipes(textController.text);
      _showRecipeResults(results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showCategoryRecipes(String category) async {
    setState(() => isLoading = true);
    try {
      final results = await apiService.searchRecipes(category);
      _showRecipeResults(results, category: category);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showRecipeDetails(dynamic recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailPage(recipe: recipe),
      ),
    );
  }

  void _showRecipeResults(List<dynamic> recipes, {String? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.blue[800],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              category ?? 'Search Results',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index]['recipe'];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Image.network(
                        recipe['image'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(recipe['label']),
                      subtitle: Text('${recipe['calories']?.toStringAsFixed(0) ?? 'N/A'} kcal'),
                      onTap: () => _showRecipeDetails(recipe),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}