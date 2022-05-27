import 'package:myshop2/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
//--| Providers
import './providers/auth.dart';
import './providers/orders.dart';
import './providers/Cart.dart';
import './providers/products.dart';
//--| Screens
import './screens/cart_screen.dart';
import './screens/edit_product_Screen.dart';
import './screens/order_screen.dart';
import './screens/user_product_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/auth-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          // this allow setup a provider which itselfe depends of another provider which was find before this one.
          //there the Product provider is depends os Auth() so The Auth() provider is always on top in the list or above the proxy provider

          // here we use ProxyProvider to get data/token from auth provider and connect auth with Produts provider
          // get Auth token from auth provider
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token ?? '' ,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
            create: (ctx) => Products('', [], ''), // this will provide null
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: ((ctx, auth, previousOrder) => Orders(
              auth.token ?? '',
              previousOrder == null ? [] : previousOrder.orders,
              auth.userId )),
            create: (ctx) => Orders('', [] ,''),
          ),
        ],
        child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'MyShop',
                    theme: ThemeData(
                      fontFamily: 'Lato',
                      colorScheme:
                          ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                              .copyWith(secondary: Colors.deepOrange),
                    ),
                    home: auth.isAuth
                        ? ProductsOverviewScreen()
                        : AuthScreen(), //    if auth .isAuth is true then print ProductDetailScreen() if false then AuthScreen()
                    routes: {
                      ProductDetailScreen.routeName: (ctx) =>
                          ProductDetailScreen(),
                      CartScreen.routeName: (ctx) => CartScreen(),
                      OrderScreen.routName: (ctx) => OrderScreen(),
                      UserProductScreen.routeName: (ctx) => UserProductScreen(),
                      EditProductScreen.routeName: (ctx) => EditProductScreen(),
                      AuthScreen.routeName: (ctx) => AuthScreen(),
                    })));
  }
}
