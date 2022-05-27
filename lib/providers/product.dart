import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final dynamic id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  // final String authToken;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    // required this.authToken,
  });

  void _setFavValue(bool newvalue) {
    isFavorite = newvalue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    // this genrates userFavoirt folder in firebase with productID  and put data to firebase with product id
    final url =
        "https://shop-app-803b4-default-rtdb.firebaseio.com/userFavorit/$userId/$id.json?auth=$authToken";
    try {
      final response =
          await http.put(Uri.parse(url), body: jsonEncode(isFavorite,));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
      print('error isFav ==> $error');
    }
  }
}
