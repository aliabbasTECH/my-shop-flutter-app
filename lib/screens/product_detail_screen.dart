import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detial ';
  // final String title;
  // final double price;

//  ProductDetailScreen( this.title,this.price);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text(routeName)),
      
    );
  }
}