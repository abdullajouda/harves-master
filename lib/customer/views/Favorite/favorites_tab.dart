import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/favorite_item.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product_details.dart';

class FavoritesTab extends StatefulWidget {
  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  bool load = true;
  bool loadButton = false;
  Products _selectedIndex;

  // List<FavoriteModel> _fruits = [];

  getFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FavoriteOperations op =
        Provider.of<FavoriteOperations>(context, listen: false);
    var request = await get(ApiHelper.api + 'getMyFavorites', headers: {
      'Accept': 'application/json',
      'Accept-Language': 'en',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      FavoriteModel products = FavoriteModel.fromJson(element);
      op.addItem(products.product);
      // _fruits.add(products);
    });
    setState(() {
      load = false;
    });
  }

  Future removeFav(Products fruit) async {
    setState(() {
      loadButton = true;
      _selectedIndex = fruit;
    });
    FavoriteOperations op =
        Provider.of<FavoriteOperations>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request =
        await get(ApiHelper.api + 'deleteFromFavorit/${fruit.id}', headers: {
      'Accept': 'application/json',
      'Accept-Language': 'en',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    Fluttertoast.showToast(msg: response['message']);
    if (response['status'] == true) {
      setState(() {
        fruit.isFavorite = '0';
        // _fruits.remove(fruit);
        op.removeFav(fruit);
        loadButton = false;
      });
    }
    setState(() {
      loadButton = false;
    });
  }

  @override
  void initState() {
    getFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FavoriteOperations op = Provider.of<FavoriteOperations>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        backgroundGradient: CColors.greenAppBarGradient(),
        actions: [HomePopUpMenu()],
        leading: SvgPicture.asset(Constants.basketIcon),
        bottomView: _buildSearchTextField(size),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "favorite_item".trs(context),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: CColors.headerText,
                fontSize: 16,
              ),
            ),
          ),
          load
              ? Center(child: Loader())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.only(top: 10, bottom: 40)
                      .add(EdgeInsets.symmetric(horizontal: 20)),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisCount: 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: op.items.length,
                  itemBuilder: (context, index) {
                    final bool _isSelected =
                        _isIndexSelected(op.items.values.toList()[index]);
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        FavoriteItem(
                          remove: () {
                            removeFav(op.items.values.toList()[index]);
                          },
                          fruit: op.items.values.toList()[index],
                        ),
                        _isSelected ? Loader() : Container()
                      ],
                    );
                  }),
        ],
      ),
    );
  }

  Widget _buildSearchTextField(Size size) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.13),
      elevation: 10,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.teal,
          borderRadius: BorderRadius.circular(999),
        ),
        padding: EdgeInsetsDirectional.only(end: 13),
        child: TextField(
          style: TextStyle(color: Colors.grey[300], fontSize: 13),
          decoration: InputDecoration(
            hintText: "Search Products",
            hintStyle: TextStyle(color: Colors.grey[350], fontSize: 13),
            contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 12),
            prefixIcon: Icon(Icons.search, color: Colors.grey[350], size: 18),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  bool _isIndexSelected(Products index) => _selectedIndex == index;
}
