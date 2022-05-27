import 'package:flutter/material.dart';

class HttpExcption extends Object implements Exception {
  final String message;

  HttpExcption(this.message);
  
  @override
  String toString(){
    return message;
  }
}