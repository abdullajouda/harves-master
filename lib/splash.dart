import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/splash_screen.dart';
import 'package:harvest/widgets/animated_splash.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer/models/city.dart';
import 'helpers/Localization/lang_provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', LangProvider().getLocaleCode());
    var _duration = new Duration(seconds: 2);
    return Timer(_duration, setLandingPage);
  }

  setLandingPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var op = Provider.of<UserFunctions>(context, listen: false);
    String token = prefs.getString('userToken');
    if (token != null) {
      op.setUser(User(
          id: prefs.getInt('id'),
          name: prefs.getString('username'),
          mobile: prefs.getString('mobile'),
          email: prefs.getString('email'),
          cityId: prefs.getInt('cityId'),
          imageProfile: prefs.getString('avatar')));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SplashScreen(),
          ));
    }
  }

  getCities() async {
    var op = Provider.of<CityOperations>(context, listen: false);
    var request = await get(ApiHelper.api + 'getCities', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    });
    var response = json.decode(request.body);
    var items = response['cities'];
    items.forEach((element) {
      City city = City.fromJson(element);
      op.addItem(city);
    });
  }

  @override
  void initState() {
    // ApiServices().getSettings();
    startTime();
    getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: CColors.lightOrange,
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: AnimatedSplash(),
          ),
        ),
      ),
    );
  }
}
