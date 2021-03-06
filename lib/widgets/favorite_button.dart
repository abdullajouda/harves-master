import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FavoriteButton extends StatefulWidget {
  final Products fruit;
  final Color color;

  const FavoriteButton({Key key, this.fruit, this.color}) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool load = false;

  Future setFav() async {
    setState(() {
      load = true;
    });
    FavoriteOperations op =
        Provider.of<FavoriteOperations>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request =
        await get(ApiHelper.api + 'addFavorite/${widget.fruit.id}', headers: {
      'Accept': 'application/json',
      'Accept-Language': 'en',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    Fluttertoast.showToast(msg: response['message']);
    if (response['status'] == true) {
      setState(() {
        op.addItem(widget.fruit);
        widget.fruit.isFavorite = '1';
        load = false;
      });
    }
    setState(() {
      load = false;
    });
  }

  Future removeFav() async {
    FavoriteOperations op =
        Provider.of<FavoriteOperations>(context, listen: false);

    setState(() {
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(
        ApiHelper.api + 'deleteFromFavorit/${widget.fruit.id}',
        headers: {
          'Accept': 'application/json',
          'Accept-Language': 'en',
          'Authorization': 'Bearer ${prefs.getString('userToken')}'
        });
    var response = json.decode(request.body);
    Fluttertoast.showToast(msg: response['message']);
    if (response['status'] == true) {
      setState(() {
        widget.fruit.isFavorite = '0';
        op.removeFav(widget.fruit);
        load = false;
      });
    }
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    FavoriteOperations op = Provider.of<FavoriteOperations>(context);
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(19.0),
            bottomLeft: Radius.circular(19.0),
          ),
          color: Colors.white),
      child: Center(
        child: load
            ? SpinKitFadingCircle(
                size: 25,
                duration: Duration(milliseconds: 500),
                color: kPrimaryColor,
              )
            : GestureDetector(
                onTap: () {
                  if (widget.fruit.isFavorite == '1') {
                    removeFav();
                  } else {
                    setFav();
                  }
                },
                child: SvgPicture.asset(
                  widget.fruit.isFavorite == '1'
                      ? 'assets/icons/full_heart.svg'
                      : 'assets/icons/empty_heart.svg',
                  color: widget.fruit.isFavorite == '1'
                      ? widget.color != null
                          ? widget.color
                          : Color(0x0ffFF7C00)
                      : widget.color != null
                          ? widget.color
                          : Colors.grey,
                )),
      ),
    );
  }
}
