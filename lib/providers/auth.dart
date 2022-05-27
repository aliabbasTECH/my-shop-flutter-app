import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:myshop2/model/http_excption.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  late String _token;
  DateTime? _expiryDate;
  late String _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token.isNotEmpty) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> authentication(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDm60hn4cSaW612lLBoSukWVUwoz89i3QY';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpExcption(responseData["error"]["message"]);
      }
      _token = responseData["idToken"];
      _userId = responseData['localId'];
      // it will get data from firebase and convert String-data into int using int.parser and
      // store as a seconds to setup firebase provided duration in _expireDate
      _expiryDate = DateTime.now().add(
        Duration(
            seconds: int.parse(
          responseData['expiresIn'],
        )),
      );
      _autoLogout(); // there we call Autologout function beacuse we want to run it after Authentication
      notifyListeners();
      
      // _______ Use SharedPreference to Store data on device _________   
      final prefs = await SharedPreferences.getInstance();   // create preference and store as variable 
      final userData = jsonEncode(
        {                   // create  json data file and store that on a variable for later use
        "token": _token,
        "userId": _userId,
        "expireDate": _expiryDate!.toIso8601String()
        }
      );
      prefs.setString("userData", userData); // json data that we create above sotre in preference means in storage as a key value pair "Userdata" is key as String and data is store as a Object   
      print(userData); // it has to be remove ?????????????????????????????
      //_______________?
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authentication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false; 
    }
    final extractedUserData = prefs.getString('userData');
  }

  void logout() {
    _expiryDate = null;
    _token = '';
    _userId = '';
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    notifyListeners();
  }

  void _autoLogout() {
    // this function Automatically log out the user there we mention 3 second of time

    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
