import 'package:flutter/material.dart';
import 'package:myshop2/providers/product.dart';

import 'package:myshop2/screens/edit_product_Screen.dart';

import 'package:provider/provider.dart';
import 'package:myshop2/widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    // context is only avialable inside the widget out side the widget you have to diclared it in function
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduvts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);\
    print("rebuild");
    return Scaffold(
        appBar: AppBar(title: const Text("your Products"), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ]),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: (context, productsData, child) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserProductItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
