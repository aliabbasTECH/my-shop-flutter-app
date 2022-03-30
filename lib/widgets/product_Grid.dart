import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './product_item.dart';

class ProductGridView extends StatelessWidget {
 

  

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context) ;
    final products =productData.items;
    return GridView.builder( 
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(products[i].id,
          products[i].title, products[i].imageUrl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}