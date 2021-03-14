import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/make_favorite_button.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:harvest/widgets/favorite_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  final Products fruit;

  ProductDetails({Key key, this.fruit}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final color = const Color(0xffFDAA5C);
  bool load = false;
  int _qty = 0;

  addToBasket(int id) async {
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'addProductToCart/$id}', headers: {
      'Accept': 'application/json',
      'fcmToken': '5555',
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    if (response['status'] == true) {
      var items = response['cart'];
      if (items != null) {
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
        });
        setState(() {
          _qty = _qty+widget.fruit.unitRate;
        });
      }
    }
    Fluttertoast.showToast(msg: response['message']);
    setState(() {
      load = false;
    });
  }

  // bool _isFavorite = false;
  @override
  void initState() {
    setState(() {
      _qty = int.parse(widget.fruit.inCart);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          // child: CBackButton(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Container(
          color: color,
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  widget.fruit.image,
                  height: 320,
                  width: 320,
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                flex: 3,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -1.5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.fruit.name ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CColors.headerText,
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              "${widget.fruit.available} ${widget.fruit.typeName}",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: CColors.headerText.withAlpha(150),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      _qty == 0
                          ? Container()
                          :Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CIconButton(
                                onTap: () {
                                  if (_qty == 0) return;
                                  setState(() {
                                    _qty = _qty - widget.fruit.unitRate;
                                  });
                                },
                                icon: Icon(Icons.remove,
                                    color: CColors.headerText, size: 25),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: size.width * 0.12,
                                ),
                                child: Center(
                                  child: Text(
                                    _qty.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: CColors.headerText,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              CIconButton(
                                onTap: () => setState(() {
                                  _qty = _qty + widget.fruit.unitRate;
                                }),
                                icon: Icon(Icons.add,
                                    color: CColors.headerText, size: 25),
                              ),
                              // if (_qty == 0)
                              //   Text("add_to_basket".trs(context),
                              //       style: TextStyle(
                              //           fontSize: 13, color: CColors.grey)),
                            ],
                          ),
                          Text(
                            "\$${widget.fruit.price}",
                            style: TextStyle(
                              color: CColors.headerText,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "product_description".trs(context),
                                style: TextStyle(
                                  color: CColors.headerText,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 5),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    widget.fruit.description ?? '',
                                    style: TextStyle(
                                      color: CColors.normalText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 56.0,
                            height: 52.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(
                                  width: 2.0, color: const Color(0xff3c984f)),
                            ),
                            child: Center(
                                child: FavoriteButton(
                              color: CColors.darkGreen,
                              fruit: widget.fruit,
                            )),
                          ),
                          SizedBox(width: 10),
                          _qty != 0
                              ? Container()
                              :Expanded(
                            child: load
                                ? Center(child: LoadingBtn())
                                :MainButton(
                                        onTap: () {
                                          addToBasket(widget.fruit.id);

                                        },
                                        constraints:
                                            BoxConstraints(maxHeight: 50),
                                        titleTextStyle: TextStyle(fontSize: 15),
                                        title: 'add_to_basket'.trs(context),
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
