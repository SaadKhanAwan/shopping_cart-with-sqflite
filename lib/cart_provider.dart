import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart_app/db_helper.dart';
import 'package:shopping_cart_app/model.dart';

class Cart_provider with ChangeNotifier {
  // this is for database initilise
  DB_helper db = DB_helper();
  // this is getter and setter method
  int _counter = 0;
  int get counter => _counter;

  double _totalprice = 0.0;
  double get totalprice => _totalprice;

  // <cart> is name of model
  // get_Cart_List is function define in dp_helper
  // Cart is just a name
  // getdata is function made here its name
  late Future<List<cart>> _cart;
  Future<List<cart>> get Cart => _cart;
  Future<List<cart>> getdata() {
    _cart = db.Get_Cart_list();
    return _cart;
  }

  // this is for to set a funtion to save data
  void _setprefrence() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("cart_item", _counter);
    pref.setDouble("total_price", _totalprice);
    notifyListeners();
  }

  // this is for save
  void _getprefrence() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _counter = pref.getInt("cart_item") ?? 0;
    _totalprice = pref.getDouble("total_price") ?? 0.0;
    notifyListeners();
  }

  // this is for final price
  void addTotalprice(double product_price) {
    _totalprice = _totalprice + product_price;
    _setprefrence();
    // here notifiylistner is to changr value through provider
    notifyListeners();
  }

  // this is for if a item remove so dicrement price
  void removeTotalprice(double product_price) {
    _totalprice = _totalprice - product_price;
    _setprefrence();
    notifyListeners();
  }

  // thsi is to save total price value
  double get_totalprice() {
    _getprefrence();
    return _totalprice;
  }

  // this is to increase amount of items in cart
  void addCounter() {
    _counter++;
    _setprefrence();
    notifyListeners();
  }

  // this is to deccrese amount of items in cart
  void removeCounter() {
    _counter--;
    _setprefrence();
    notifyListeners();
  }

  // this is to save that
  int getCounter() {
    _getprefrence();
    return _counter;
  }
}
