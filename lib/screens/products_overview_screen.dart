import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_Grid.dart';

class ProductOverViewScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
        body: ProductGridView(),
    );
  }
}

