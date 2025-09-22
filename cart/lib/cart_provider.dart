import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier{
  int _itemCount=0;
  int get itemCount => _itemCount;

  void addItem(){
    _itemCount++;
    notifyListeners();
    }
}