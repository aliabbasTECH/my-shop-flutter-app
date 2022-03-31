import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detial ';

  @override
  Widget build(BuildContext context) {
    // | abbrivation is provided below
    // v
    final pIFPI = ModalRoute.of(context)?.settings.arguments as String;

    final pDAFWRI =
        Provider.of<Products>(context, listen: false).findById(pIFPI);

    // print(pDAFWRI.title);
    return Scaffold(
      appBar: AppBar(title: Text(pDAFWRI.title)),
    );
  }
}

//pDAFWRI = Product Data After Filter With Respect To ID.
// pFP   = product From Provider.
// pIFPI       = product Id From Product Item.
