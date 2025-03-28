import 'package:flutter/material.dart';
import 'package:foodify2o/services/food_api_service.dart';
import 'package:foodify2o/utils/background.dart';
import 'package:foodify2o/pages/recipe_detail_page.dart';

class RecipiesPage extends StatefulWidget {
  const RecipiesPage({super.key});

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {
  final FoodApiService _apiService = FoodApiService();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  final List<String> _categories = [
    "Vegetarian",
    "Vegan",
    "Gluten Free",
    "Desserts"
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthy Recipes', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          const Background(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 20),
                _buildCategoryList(),
                const SizedBox(height: 20),
                Expanded(child: _buildRecipeGrid()),
              ],
            ),
          ),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search healthy recipes...',
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _handleSearch,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: (_) => _handleSearch(),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilterChip(
              label: Text(_categories[index]),
              onSelected: (_) => _fetchCategoryRecipes(_categories[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecipeGrid() {
    return FutureBuilder<List<dynamic>>(
      future: _apiService.searchRecipes("healthy"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final recipes = snapshot.data ?? [];

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return _buildRecipeCard(recipe);
          },
        );
      },
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _showRecipeDetails(recipe['id']),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  recipe['image'] ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe['title'] ?? 'No Title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (recipe['readyInMinutes'] != null)
                    Text('Ready in ${recipe['readyInMinutes']} mins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _handleSearch() async {
    if (_searchController.text.isEmpty) return;
    _setLoading(true);
    try {
      final results = await _apiService.searchRecipes(_searchController.text);
      _showRecipeResults(results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _fetchCategoryRecipes(String category) async {
    _setLoading(true);
    try {
      final results = await _apiService.searchRecipes(category);
      _showRecipeResults(results, category: category);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load $category recipes: $e')),
      );
    } finally {
      _setLoading(false);
    }
  }

  void _showRecipeDetails(int recipeId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailPage(recipeId: recipeId),
      ),
    );
  }

  void _showRecipeResults(List<dynamic> recipes, {String? category}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              category ?? 'Search Results',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return ListTile(
                    leading: Image.network(recipe['image'] ?? '', width: 50),
                    title: Text(recipe['title'] ?? 'No Title'),
                    subtitle: Text('${recipe['readyInMinutes'] ?? '?'} mins'),
                    onTap: () => _showRecipeDetails(recipe['id']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setLoading(bool loading) {
    setState(() => _isLoading = loading);
  }
}