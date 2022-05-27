import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {
      ..._items
    }; // there we used curly brackets to return as Map   ...  3 dots represent that its a spread operator that work like add multiple maps with out using Add operator at dynamic level means ans any time or multiple time
  }
  int get itemCount {
    return  _items.length;
  }
  double get totalAmount{
    var total = 0.0;
 _items.forEach((key, CartItem) {
        total += CartItem.price * CartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {                  // ___
      _items.update(                                      //   |     this condition is change the quantity 
          productId,                                      //   |      of products 
          (existingCartItem) => CartItem(                 //   |      .containsKey method is retrn true if productId is present
              id: existingCartItem.id,                    //   |====> .uptate method is use to update data
              title: existingCartItem.title,              //   |     existingCArtItem parameter store privous data
              quantity: existingCartItem.quantity + 1,    //   |   
              price: existingCartItem.price));            // __|
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId){
     _items.remove(productId);
     notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)){
      return ;
    }
    if(_items[productId]!.quantity>1){
      _items.update(productId, (existngCart) => CartItem(
          id: existngCart.id,
          title: existngCart.title,
          quantity: existngCart.quantity -1,
          price: existngCart.price));
    }else{
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
 }

}
