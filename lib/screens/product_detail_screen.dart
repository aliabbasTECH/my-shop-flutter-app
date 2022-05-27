import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    // it will get id from product_item.dart file from Navigator method that is "ontap()" in "GestureDetector" widget
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    // it will get/listen id data fronm StateManagement Service "Provider" but only by id beacuse of FindById() function that is present in Providers.Products
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(
        productId); //this get data onetime and false the real time listening
    // this is the function that filter data by id means ProductID
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title), // there we show data filter by id
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "\$ ${loadedProduct.price}",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
                child: Text(
              loadedProduct.description,
              textAlign: TextAlign.center,
              softWrap: true,
            ))
          ],
        ),
      ),
    );
  }
}
