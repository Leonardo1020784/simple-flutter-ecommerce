import 'package:flutter/material.dart';
import 'database.dart';

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  List<Map<String, dynamic>> _basketItems = [];

  @override
  void initState() {
    super.initState();
    _loadBasketItems();
  }

  Future<void> _loadBasketItems() async {
    List<Map<String, dynamic>> basketItems = await DatabaseHelper.getAllBasketItems();
    setState(() {
      _basketItems = basketItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Basket Items:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _basketItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_basketItems[index]['name']),
                    subtitle: Text('Quantity: ${_basketItems[index]['quantity']}'),
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
