import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

import './Cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  // this will store data from other class that is connected there its only initilize it not save any data on that variabel save data from other classes   
  final String authToken;
  final String userId;
  //this is constructor . will select only this variable will cahnge or manipulate from other classes  only these to variable will go out from class  
  Orders(this.authToken,this._orders,this.userId);    

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://shop-app-803b4-default-rtdb.firebaseio.com/orders/users/$userId.json?auth=$authToken";
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic> ;
    if (extractedData.isEmpty){
       return;
    }
    
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['Total amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData["products"] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total ) async {
    final url =
        "https://shop-app-803b4-default-rtdb.firebaseio.com/orders/users/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'Total amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  "id": cp.id,
                  "title": cp.title,
                  "quantity": cp.quantity,
                  "price": cp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          products: cartProducts,
          dateTime: timeStamp,
        ));
    notifyListeners();
  }
}
