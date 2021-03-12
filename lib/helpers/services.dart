import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services with ChangeNotifier {
  setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userToken', token);
    notifyListeners();
  }

  setUserType(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userType', type);
    notifyListeners();
  }

  setUser(
      int id,int cityId, String first, String email, String mobile, String avatar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    prefs.setInt('cityId', cityId);
    prefs.setString('username', first);
    prefs.setString('email', email);
    prefs.setString('mobile', mobile);
    prefs.setString('avatar', avatar);
    notifyListeners();
  }

  clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userToken');
    prefs.remove('userType');
    prefs.remove('id');
    prefs.remove('username');
    prefs.remove('email');
    prefs.remove('mobile');
    prefs.remove('avatar');
    notifyListeners();
  }

  // setImage(String image) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('avatar', image);
  //   notifyListeners();
  // }

}
