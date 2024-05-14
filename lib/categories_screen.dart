import 'package:flutter/material.dart';
import 'database.dart';
import 'products_screen.dart'; // Import ProductsScreen

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final TextEditingController _categoryController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> categories = await DatabaseHelper.getCategories();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _categoryController,
              decoration: InputDecoration(labelText: 'Category Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.insertCategory(_categoryController.text);
                setState(() {
                  _categoryController.clear();
                  _loadCategories(); // Reload categories after insertion
                });
              },
              child: Text('Save Category'),
            ),
            SizedBox(height: 20),
            Text('Categories:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_categories[index]['name']),
                    onTap: () {
                      // Navigate to ProductsScreen with the selected category ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsScreen(categoryId: _categories[index]['id']),
                        ),
                      );
                    },
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
