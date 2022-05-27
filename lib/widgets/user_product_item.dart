import 'package:flutter/material.dart';
import 'package:myshop2/providers/products.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_Screen.dart';

class UserProductItem extends StatelessWidget {
  final dynamic id;
  final String title;
  final String imageUrl;

  UserProductItem(
    this.id,
    this.title,
    this.imageUrl,
  );

  @override
  Widget build(BuildContext context) {
   final scaffold = ScaffoldMessenger.of(context) ;
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                 await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text("deleting fails!"),
                  ));
                  print(error.toString());
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
