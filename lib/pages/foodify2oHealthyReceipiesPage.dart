import 'package:flutter/material.dart';

import '../utils/background.dart';



class SearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;

  const SearchInput({
    required this.textController,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 26),
            blurRadius: 50,
            spreadRadius: 0,
            color: const Color.fromARGB(255, 88, 87, 87).withOpacity(.25),
          ),
        ],
      ),
      child: TextField(
        controller: textController,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff4338CA),
          ),
          filled: true,
          fillColor: Colors.blue[50],
          hintText: hintText,
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 147, 146, 146), width: 1.0),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 53, 52, 52), width: 2.0),
            borderRadius: BorderRadius.circular(50.0),
          ),
        ),
      ),
    );
  }
}

class RecipiesPage extends StatefulWidget {
  const RecipiesPage({super.key});

  @override
  State<RecipiesPage> createState() => _RecipiesPageState();
}

class _RecipiesPageState extends State<RecipiesPage> {
  final TextEditingController textController = TextEditingController();

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
        title: const Text('Healthy Recipes'),
      ),
      body: Stack(
        children: [
          const Background(), // Background behind everything
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  
                  children: [
                    
                    SearchInput(
                      textController: textController,
                      hintText: "Search",
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topCategories.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: ListTile(
                          title: Text(topCategories[index]),
                          subtitle: Text('Description $index'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
                            ),
                            
                    const SizedBox(height: 16),
                    _buildCategoryList('Rice Based Dishes', topCategories),
                    _buildCategoryList('Salads', topCategories),
                    _buildCategoryList('Fruit Juices', topCategories),
                    _buildCategoryList('Vegetarian Dishes', topCategories),
                    _buildCategoryList('Sabzis, Dals and Curries', topCategories),
                    _buildCategoryList('Rotis And Parathas', topCategories),
                    _buildCategoryList('Idlis and Dosas', topCategories),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(String name, List<String> items) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 130,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[50],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 2,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      items[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
