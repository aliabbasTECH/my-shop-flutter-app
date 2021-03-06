import 'package:flutter/material.dart';
import 'package:myshop2/providers/auth.dart';
import 'package:myshop2/screens/products_overview_screen.dart';
import 'package:myshop2/screens/user_product_screen.dart';
import 'package:provider/provider.dart';
import '../screens/order_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(
          title: Text("hello friend!"),
          automaticallyImplyLeading: false,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("SHOP"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
         Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
          },
        ),
         Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("User Products"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName);
          },
        ),
         Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text("Logout"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context,listen: false).logout();
            
            
          },
        )
      ]),
    );
  }
}
