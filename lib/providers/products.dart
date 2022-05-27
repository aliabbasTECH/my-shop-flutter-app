import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; // as http is a prefix for the package for avoiding name clashes
import 'package:myshop2/model/http_excption.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  //for show favorit product on the condition of true or false
  var _showFavoritOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this._items,
      this.userId); // this auth toke is used is fatching, posting,replacing, deleting or editing the product data to spacific user

  List<Product> get items {
    // this is Globle StateManagement approch means this approch able to get in every widget that is come under the ChangeNotifierProvider() in a Provider
    // // if _showFavoritOnly is true it will shows products from the Product List where isFavorite is true;
    // if (_showFavoritOnly){
    //      //  prodItem is perameter where Product list is present .where filter product from where isFAvorit is true
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  // this function Filter Data by id that function worked in Product_detail_screen.dart file
  Product findById(String id) {
    // this String id come from productId
    // .firstWhere method  return only one item from Product where id is matched
    return _items.firstWhere((prod) =>
        prod.id ==
        id); // prod.id comes from Product _items and check condition if match return only matched data
  }

// ______{ this is loacal StateManagement approch
  List<Product> get favoriteItem {
    return _items.where((proditem) => proditem.isFavorite).toList();
  }

//______}

// _______this is Globle StateManagement approch

  // void showFavoritOnly(){
  //   // convert _showFavoritOnly to true , it will show favorite if function is called
  //  _showFavoritOnly=true;
  //  notifyListeners();
  // }
  // void showAll(){
  //   // convert _showFavoritOnly to false ,it will hide or remove if function is called
  //    _showFavoritOnly=false;
  //    notifyListeners();
  // }
  // _______this is Globle StateManagement approch

  Future<void> fetchAndSetProduvts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : "";
    var url =
        'https://shop-app-803b4-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final res = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducats = [];
      if (extractedData.isEmpty) {
        return;
      }
      url =
          "https://shop-app-803b4-default-rtdb.firebaseio.com/userFavorit/$userId.json?auth=$authToken";
      final favoritResponse = await http.get(Uri.parse(url));
      final favoritData = jsonDecode(favoritResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducats.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData["description"],
          price: prodData["price"],
          imageUrl: prodData["imageUrl"],
          isFavorite: favoritData == null
              ? false
              : favoritData[prodId] ??
                  false, // if favortData is null then false if not null save favoritData[prodId] double question marks represents that if no data is in variable then impliment next that is after double question marks there is false
          // authToken: authToken           // this is a way off add authtoken in Single product where Product Favorit is saved and there are other way too! .
        ));
      });
      _items = loadedProducats;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // add Product function
  Future<void> addProduct(Product product) async {
    // only firebase has feature added .json none other services has that feature yet!
    //and after the Question Mark ??auth=$authToken  this will triger the Auth user data and addProduct to spacific authanticated used after authantication
    final url =
        "https://shop-app-803b4-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            // json.encode convert the dart object to json(javaScript object notation ) and save to restAPI link that firebase provided body their is a url body
            // we take Product class as a parameter in addProduct Function and store in product get product data and saved on fire-base realtime DB
            'title': product.title,
            'description': product.description, //
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId, // save user id as CreatorId 
            // 'isFavoirte': product.isFavorite,
          }));
      final newProduct = Product(
        id: jsonDecode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        // authToken: authToken   // this is a way off add authtoken in Single product where Product Favorit is saved and there are other way too! .
      );

      _items.add(newProduct);
      notifyListeners();

      ;
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      // product/$id means that the target the product at spacific product id and update, data of that product .
      //and after the Question Mark ?auth=$authToken  this will triger the Auth user data and UpdateProduct to spacific authanticated used after authantication
      final url =
          "https://shop-app-803b4-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(Uri.parse(url),
          body: jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            // 'isFavoirte': newProduct.isFavorite,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("....");
    }
  }

  Future<void> deleteProduct(String id) async {
    // product/$id means that the target the product at spacific product id and delete product .
    //and after the Question Mark ?auth=$authToken  this will triger the Auth user data and Delete-Product to spacific authanticated used after authantication
    final url =
        "https://shop-app-803b4-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";
    //__________________   OPTAMISTIC UPDATING __________________________//
    //       this code block create refrence pointer in memory
    //       and store in memory to recovery of indexed product after
    //       failed delete or error is occured
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProducts = _items[existingProductIndex];
    //_________________
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(
      Uri.parse(url),
    );
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProducts);
      notifyListeners();
      throw HttpExcption('coud not delete product ');
    }
    existingProducts = null;

    // _items.removeWhere((prod) => prod.id == id);
  }
}

//______________________________ RW______________________\
//++++_items++++++
// Product(
//   id: 'p1',
//   title: 'Red Shirt',
//   description: 'A red shirt - it is pretty red!',
//   price: 29.99,
//   imageUrl:
//       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// ),
// Product(
//   id: 'p2',
//   title: 'Trousers',
//   description: 'A nice pair of trousers.',
//   price: 59.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// ),
// Product(
//   id: 'p3',
//   title: 'Yellow Scarf',
//   description: 'Warm and cozy - exactly what you need for the winter.',
//   price: 19.99,
//   imageUrl:
//       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// ),
// Product(
//   id: 'p4',
//   title: 'A Pan',
//   description: 'Prepare any meal you want.',
//   price: 49.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
// ),
