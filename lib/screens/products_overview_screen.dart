import 'package:flutter/material.dart';
import 'package:myshop2/providers/Cart.dart';
import 'package:myshop2/providers/products.dart';
import 'package:provider/provider.dart';


import '../widgets/app_drawer.dart';
import './cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum filterOptions {
  Favorites,
  All,
}

// if you want to used local or widget level Approch to change the state or get data & set data you has to change
// ProductOverviewSceen widget class and convert statelessWidget to statefullWidget there we convert it beacuse we used global State
//

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _ShowOnlyFavorites = false; // this connect with local approch
   var _isInit = true;
   var _isloading=false;
    @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProduvts();    // we dont use of(context) in initState(){} there 
    // Future.delayed(Duration.zero).then((_){                  // this approch is work but its a hack beacause first initState() work and then this approch work 
    //   Provider.of<Products>(context).fetchAndSetProduvts();  // its not a good practice ?
    // }); 
    super.initState();
  }

  @override
  void didChangeDependencies() {
     if (_isInit) { // if is initial state is true it will run and fetch all products from link 
        
        setState(() {
               _isloading=true;  
        });
      
        Provider.of<Products>(context).fetchAndSetProduvts().then((_) {
          setState(() {
               _isloading=false;  
        });
        });
     }
     _isInit=false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false); it will be used in globle approch of Statemanagement system
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              //________>  this is loacl or widget-level approch

              onSelected: (filterOptions selectedValue) {
                setState(() {
                  if (selectedValue == filterOptions.Favorites) {
                    _ShowOnlyFavorites = true;
                  } else {
                    _ShowOnlyFavorites = false;
                  }
                });

               
                //<<___ 
                ////this is globle approch of Provider StateManagement System here we get and sent some values from Provider/Protuct.dart file
                //  if(selectedValue ==filterOptions.Favorites){
                //       productsContainer.showFavoritOnly();
                //  }else{
                //       productsContainer.showAll();
                //  }
                //__>>
                print(selectedValue);
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text("only Favorit"),
                      value: filterOptions.Favorites,
                    ),
                    const PopupMenuItem(
                      child: Text("show all"),
                      value: filterOptions.All,
                    )
                  ],
              ),
              Consumer<Cart>(builder: 
                (_ ,cart, ch)=>  Badge(
                color: Colors.red,
                child: ch as Widget,
                value: cart.itemCount.toString(),
                    ),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    ),
                     onPressed: () { 
                       Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
              )
              
        ],
      ),
      drawer: AppDrawer(),
      body: _isloading ? Center(child: CircularProgressIndicator()): ProductsGrid(_ShowOnlyFavorites),
    );
  }
}
