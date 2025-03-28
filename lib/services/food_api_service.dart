import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodApiService {
  static const String baseUrl = 'https://api.edamam.com/api/recipes/v2';
  static const String appId = 'YOUR_APP_ID'; // Replace with your actual ID
  static const String appKey = 'YOUR_APP_KEY'; // Replace with your actual key

  Future<List<dynamic>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse(
      '$baseUrl?type=public&q=${Uri.encodeQueryComponent(query)}&app_id=$appId&app_key=$appKey',
    ));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['hits'];
    } else {
      throw Exception('Failed to load recipes: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> getRecipeDetails(String id) async {
    final response = await http.get(Uri.parse(
      '$baseUrl/$id?type=public&app_id=$appId&app_key=$appKey',
    ));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['recipe'];
    } else {
      throw Exception('Failed to load recipe details: ${response.statusCode}');
    }
  }
}