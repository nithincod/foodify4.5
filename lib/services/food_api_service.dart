import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodApiService {
  static const String baseUrl = 'https://api.spoonacular.com';
  static const String apiKey = '42153536c0344335a8fc57965d15927f'; 

  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recipes/complexSearch?query=$query&apiKey=$apiKey&number=10&addRecipeInformation=true')
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getRecipeDetails(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recipes/$id/information?apiKey=$apiKey&includeNutrition=true')
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load recipe details');
    }
  }
}