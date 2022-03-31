import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products_provider.dart';

import 'package:myshop/screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';





void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {   
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx)=>Products(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My shop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange)),
        home: ProductOverViewScreen(),
        routes:{ 
          ProductDetailScreen.routeName:(ctx)=> ProductDetailScreen(),
        },
      ),
    );
  }
}
