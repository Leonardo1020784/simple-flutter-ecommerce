import 'package:flutter/material.dart';
import 'database.dart';
import 'basket_screen.dart'; // Import BasketScreen

class ProductsScreen extends StatefulWidget {
  final int categoryId;

  ProductsScreen({required this.categoryId});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final TextEditingController _productController = TextEditingController();
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    List<Map<String, dynamic>> products = await DatabaseHelper.getProducts(widget.categoryId);
    setState(() {
      _products = products;
    });
  }

  Future<void> _updateProductQuantity(int productId, int quantityChange) async {
    await DatabaseHelper.updateProductQuantity(productId, quantityChange);
    _loadProducts(); // Reload products after updating quantity
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _productController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await DatabaseHelper.insertProduct(widget.categoryId, _productController.text, 0); // Change 0 to actual price
                setState(() {
                  _productController.clear();
                  _loadProducts(); // Reload products after insertion
                });
              },
              child: Text('Save Product'),
            ),
            SizedBox(height: 20),
            Text('Products:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_products[index]['name']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            _updateProductQuantity(_products[index]['id'], -1);
                          },
                        ),
                        Text(_products[index]['quantity'].toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _updateProductQuantity(_products[index]['id'], 1);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BasketScreen(),
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
