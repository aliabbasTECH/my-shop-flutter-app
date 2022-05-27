import 'package:flutter/material.dart';
import 'package:myshop2/providers/Cart.dart';
import 'package:myshop2/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false); 
    final authData= Provider.of<Auth>(context, listen: false);   // listen false means listen one time and get data from provider one time  
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              // it will get product.id direct from providers/product.dart  (note: not from products), and save in argument when someone click on 
              // ClipRRect it will send id 
              arguments: product.id, 
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    product.toggleFavoriteStatus(authData.token as String,authData.userId );
                  },
                ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id,product.price,product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:Text(" item add to cart"),
                  action: SnackBarAction(label: "UNDO",onPressed: (){
                    cart.removeSingleItem(product.id);
                  } ),
                  )
              ); // in old version it is |=> Scaffold.of(context).showSnackBar(SnackBar(content:Text(" item add to cart")));
            },
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
