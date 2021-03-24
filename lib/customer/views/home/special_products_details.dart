import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/featured_product.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/make_favorite_button.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/color_converter.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/alerts/removed_from_cart.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductBundleDetails extends StatefulWidget {
  final FeaturedProduct fruit;

  ProductBundleDetails({
    Key key,
    this.fruit,
  }) : super(key: key);

  @override
  _ProductBundleDetailsState createState() => _ProductBundleDetailsState();
}

class _ProductBundleDetailsState extends State<ProductBundleDetails> {

  bool _isFavorite = false;
  bool load = false;

  addToBasket(int id) async {
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'addProductToCart/$id}', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    print(response);
    if (response['status'] == true) {
      var items = response['cart'];
      if (items != null) {
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
        });
        setState(() {
          widget.fruit.inCart = widget.fruit.inCart+widget.fruit.unitRate;
        });
      }
    }
    Fluttertoast.showToast(msg: response['message']);
    setState(() {
      load = false;
    });
  }

  changeQnt(int type, int id) async {
    setState(() {
      load = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await post(ApiHelper.api + 'changeQuantity', body: {
      'type': type.toString(),
      'product_id': id.toString()
    }, headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    if (response['message'] == 'product deleted') {
      showGeneralDialog(
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black.withOpacity(0.1),
        transitionDuration: Duration(milliseconds: 500),
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return RemovedFromCart();
        },
        transitionBuilder: (context, anim1, anim2, child) {
          return SlideTransition(
            position:
            Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
            child: child,
          );
        },
      );
    }
    setState(() {
      load = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          color: HexColor.fromHex(widget.fruit.specialFoodBg != ''
              ? widget.fruit.specialFoodBg
              : '#5ECC74'),
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              SafeArea(
                child: Align(
                  alignment: AlignmentDirectional(-0.9, -1),
                  child: CBackButton(),
                ),
              ),
              Expanded(
                child: Hero(
                  tag: widget.fruit.image,
                  child: Image.network(
                    widget.fruit.image,
                    // height: size.width * 0.5,
                    // width: size.width * 0.5,
                    // fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              // SizedBox(height: 20),
              Expanded(
                flex: widget.fruit.basketItem.length != 0 ? 2 : 1,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
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
                        child: Row(
                          children: [
                            Text(
                              widget.fruit.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CColors.headerText,
                                fontSize: 20,
                              ),
                            ),
                            // SizedBox(width: 10),
                            // Text(
                            //   "${widget.fruit.qty} ${widget.fruit.typeName}",
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w400,
                            //     color: CColors.headerText.withAlpha(150),
                            //     fontSize: 15,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      widget.fruit.inCart != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                      CIconButton(
                                        onTap: () {
                                          changeQnt(2, widget.fruit.id);
                                          setState(() {
                                            widget.fruit.inCart =
                                                widget.fruit.inCart - widget.fruit.unitRate;
                                          });
                                        },
                                        icon: Icon(Icons.remove,
                                            color: CColors.headerText,
                                            size: 25),
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: size.width * 0.12,
                                        ),
                                        child: Center(
                                          child: Text(
                                            widget.fruit.inCart.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: CColors.headerText,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    CIconButton(
                                      onTap: () {
                                        widget.fruit.inCart == 0
                                            ? addToBasket(widget.fruit.id)
                                            : changeQnt(1, widget.fruit.id);
                                        setState(widget.fruit.inCart != 0
                                            ? () {
                                          widget.fruit.inCart =
                                              widget.fruit.inCart + widget.fruit.unitRate;
                                        }
                                            : () {});
                                      },
                                      icon: Icon(Icons.add,
                                          color: CColors.headerText, size: 25),
                                    ),
                                    // if (widget.fruit.minQty == 0)
                                    //   Text("add_to_basket".trs(context),
                                    //       style: TextStyle(
                                    //           fontSize: 13, color: CColors.grey)),
                                  ],
                                ),
                                Text(
                                  "${'Q.R'.trs(context)}${widget.fruit.price}",
                                  style: TextStyle(
                                    color: CColors.headerText,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(height: 10),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    widget.fruit.description??'',
                                    style: TextStyle(
                                      color: CColors.normalText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              widget.fruit.basketItem.length != 0
                                  ? Expanded(
                                      flex: 4,
                                      child: ListView.builder(
                                        itemCount:
                                            widget.fruit.basketItem.length,
                                        padding: EdgeInsets.zero,
                                        itemBuilder: (context, index) {
                                          return _BundleProduct(
                                            title: widget.fruit
                                                .basketItem[index].item.name,
                                            imagePath: widget.fruit
                                                .basketItem[index].item.image,
                                            numOfItems: widget
                                                .fruit.basketItem[index].qty
                                                .toString(),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MakeFavoriteButton(
                            activeColor: CColors.lightGreen,
                            inActiveColor: CColors.lightGreen,
                            padding: EdgeInsets.all(10.0),
                            onValueChanged: () {
                              setState(() => _isFavorite = !_isFavorite);
                            },
                            value: _isFavorite,
                          ),
                          SizedBox(width: 10),
                          widget.fruit.inCart != 0
                              ? Container()
                              : Expanded(
                                  child: load?Center(child: LoadingBtn()):MainButton(
                                    onTap: () {
                                      addToBasket(widget.fruit.id);

                                    },
                                    constraints: BoxConstraints(maxHeight: 45),
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

class _BundleProduct extends StatelessWidget {
  final String title;
  final String numOfItems;
  final String imagePath;

  const _BundleProduct({
    Key key,
    this.title,
    this.numOfItems,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.09,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: CColors.fadeGreen,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Row(
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          color: CColors.headerText,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "$numOfItems items",
                        style: TextStyle(
                          fontSize: 13,
                          color: const Color(0xcc3c4959),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            child: Image.network(
              imagePath,
              width: 60,
              height: 60,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}
