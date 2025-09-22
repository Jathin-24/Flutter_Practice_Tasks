import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';

void main(){
  runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (_) => CartProvider(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CartWithProvider(),
    );
  }
}

class CartWithProvider extends StatelessWidget {
  const CartWithProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart - ${cart.itemCount} items'),
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
          cart.addItem();
        }, child: Text('Add Item to Cart')),
      ),
    );
  }
}
