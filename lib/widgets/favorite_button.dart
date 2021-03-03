import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoriteButton extends StatefulWidget {
  final Fruit fruit;

  const FavoriteButton({Key key, this.fruit}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool load = false;

  Future setFav() async {
    setState(() {
      load = true;
    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var request =
    // await post(api + 'addTicketToFavorite/${widget.fruit.id}', headers: {
    //   'Accept-Language': prefs.getString('language'),
    //   'Accept': 'application/json',
    //   'Authorization': 'Bearer ${prefs.getString('userToken')}'
    // });
    // var response = json.decode(request.body);
    // Fluttertoast.showToast(msg: response['message']);
    // if (response['status'] == true) {
    setState(() {
      widget.fruit.isFavorite = true;
      load = false;
    });
    // }
    setState(() {
      load = false;
    });
  }

  Future removeFav() async {
    setState(() {
      load = true;
    });
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var request = await post(
    //     api + 'deleteTicketFromFavorite/${widget.ticket.id}',
    //     headers: {
    //       'Accept-Language': prefs.getString('language'),
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer ${prefs.getString('userToken')}'
    //     });
    // var response = json.decode(request.body);
    // Fluttertoast.showToast(msg: response['message']);
    // if (response['status'] == true) {
    setState(() {
      widget.fruit.isFavorite = false;
      load = false;
    });
    // }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? SpinKitFadingCircle(
            size: 25,
            duration: Duration(milliseconds: 500),
            color: kPrimaryColor,
          )
        : GestureDetector(
            onTap: () {
              if (widget.fruit.isFavorite == true) {
                removeFav();
              } else {
                setFav();
              }
            },
            child: widget.fruit.isFavorite!= null ?SvgPicture.asset(
              widget.fruit.isFavorite
                  ? 'assets/icons/full_heart.svg'
                  : 'assets/icons/empty_heart.svg',
              color: widget.fruit.isFavorite
                  ? Color(0x0ffFF7C00)
                  : Colors.grey,
            ):Container(),
          );
  }
}
