import 'package:flutter/material.dart';

class RecipeDetailPage extends StatelessWidget {
  final dynamic recipe;

  const RecipeDetailPage({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                recipe['image'],
                fit: BoxFit.cover,
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
                    recipe['label'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${recipe['calories']?.toStringAsFixed(0) ?? 'N/A'} calories | ${recipe['ingredients'].length} ingredients',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildNutritionSection(),
                  const SizedBox(height: 20),
                  _buildIngredientsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nutrition Facts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Nutrient')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Daily %')),
            ],
            rows: [
              _buildNutritionRow('Calories', recipe['calories'], 'kcal'),
              _buildNutritionRow('Protein', recipe['totalNutrients']['PROCNT']['quantity'], 'g'),
              _buildNutritionRow('Carbs', recipe['totalNutrients']['CHOCDF']['quantity'], 'g'),
              _buildNutritionRow('Fat', recipe['totalNutrients']['FAT']['quantity'], 'g'),
              _buildNutritionRow('Fiber', recipe['totalNutrients']['FIBTG']['quantity'], 'g'),
            ],
          ),
        ),
      ],
    );
  }

  DataRow _buildNutritionRow(String label, dynamic value, String unit) {
    return DataRow(
      cells: [
        DataCell(Text(label)),
        DataCell(Text('${value?.toStringAsFixed(1) ?? 'N/A'} $unit')),
        DataCell(Text('${(value != null ? (value * 100 / 2000).toStringAsFixed(0) : 'N/A')}%')),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...recipe['ingredientLines'].map<Widget>((ingredient) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text(ingredient)),
              ],
            ),
          ),
        ).toList(),
      ],
    );
  }
}