import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/helpers/AlertManager.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/alerts/added_to_cart.dart';
import 'package:harvest/widgets/alerts/removed_from_cart.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:harvest/widgets/favorite_button.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/services/local_notifications_service.dart';

class FruitItem extends StatefulWidget {
  final Products fruit;
  final Color color;

  const FruitItem({Key key, this.fruit, this.color}) : super(key: key);

  @override
  _FruitItemState createState() => _FruitItemState();
}

class _FruitItemState extends State<FruitItem> {
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
    if (response['status'] == true) {
      MyAlert.addedToCart(0, context);
      // showGeneralDialog(
      //   transitionDuration: Duration(milliseconds: 500),
      //   barrierColor: Colors.transparent,
      //   context: context,
      //   pageBuilder: (context, anim1, anim2) {
      //     return AddedToCartAlert();
      //   },
      //   transitionBuilder: (context, anim1, anim2, child) {
      //     return SlideTransition(
      //       position:
      //           Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
      //       child: child,
      //     );
      //   },
      // );
      //  await localNotificationsService.showNotification('title', 'message');

      var items = response['cart'];
      if (items != null) {
        cart.clearFav();
        items.forEach((element) {
          CartItem item = CartItem.fromJson(element);
          cart.addItem(item);
        });
        setState(() {
          widget.fruit.inCart = widget.fruit.inCart + widget.fruit.unitRate;
        });
      }
    }
    // Fluttertoast.showToast(msg: response['message']);
    setState(() {
      load = false;
    });
  }

  changeQnt(int type, int id) async {
    setState(() {
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
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
      cart.removeCartItem(widget.fruit.id);
      MyAlert.addedToCart(1, context);
      // showGeneralDialog(
      //   barrierDismissible: true,
      //   barrierLabel: '',
      //   barrierColor: Colors.black.withOpacity(0.1),
      //   transitionDuration: Duration(milliseconds: 500),
      //   context: context,
      //   pageBuilder: (context, anim1, anim2) {
      //     return RemovedFromCart();
      //   },
      //   transitionBuilder: (context, anim1, anim2, child) {
      //     return SlideTransition(
      //       position:
      //           Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
      //       child: child,
      //     );
      //   },
      // );
    }
    setState(() {
      load = false;
    });
  }

  showReceived(ReceiveNotification notification) {
    print('notification: ${notification.id}');
  }

  @override
  void initState() {
    super.initState();
    localNotificationsService.setOnNotificationReceived(showReceived);
  }

  @override
  Widget build(BuildContext context) {
    var lang = Provider.of<LangProvider>(context);
    return widget.fruit.qty == 0
        ? Container(
            height: 160,
            width: 160,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        height: 84,
                        width: 87,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.fruit.image,
                            ),
                            fit: BoxFit.fill,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: const Color(0x0f000000),
                          //     offset: Offset(0, 6),
                          //     blurRadius: 8,
                          //   ),
                          // ],
                        ),
                      ),
                      Text(
                        widget.fruit.name ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff3c4959),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Sold Out'.trs(context),
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff3c4959),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white38,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x17000000),
                        offset: Offset(0, 10),
                        blurRadius: 21,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x17000000),
                  offset: Offset(0, 10),
                  blurRadius: 21,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: 3,
                  child: Container(
                    height: 84,
                    width: 87,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.fruit.image),
                        fit: BoxFit.fill,
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: const Color(0x0f000000),
                      //     offset: Offset(0, 6),
                      //     blurRadius: 8,
                      //   ),
                      // ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: FavoriteButton(
                    fruit: widget.fruit,
                  ),
                ),
                widget.fruit.discount > 0
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          height: 22,
                          width: 53,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              bottomRight: Radius.circular(16.0),
                            ),
                            color: const Color(0xfff88518),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.fruit.discount}% ${'Off'.trs(context)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(0xffffffff),
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Positioned(
                  left: lang.getLocaleCode() == 'ar' ? null : 20,
                  right: lang.getLocaleCode() == 'ar' ? 20 : null,
                  bottom: widget.fruit.inCart != 0
                      ? 40
                      : lang.getLocaleCode() == 'ar'
                          ? 23
                          : 13,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.fruit.name ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xff3c4959),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      widget.fruit.description != null
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text(
                                widget.fruit.description,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color(0xffe3e7eb),
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            )
                          : Container(),
                      Row(
                        children: [
                          Text(
                            '${widget.fruit.discount > 0 ? widget.fruit.price - (widget.fruit.price*widget.fruit.discount/100) : widget.fruit.price}  ${'Q.R'.trs(context)}/${widget.fruit.typeName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.color != null
                                  ? widget.color
                                  : const Color(0xff3c984f),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          widget.fruit.discount > 0
                              ? Stack(
                            alignment: Alignment.center,
                                  children: [
                                    Text(
                                      '  ${widget.fruit.price}  ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: const Color(0xff7cba89),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SvgPicture.asset('assets/line.svg')
                                  ],
                                )
                              : Container(),
                        ],
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
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
                    child: Container(
                      height: 31,
                      width: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19.0),
                          bottomRight: Radius.circular(19.0),
                        ),
                        color: widget.color != null
                            ? widget.color
                            : Color(0xff3c984f),
                      ),
                      child: Center(
                        child: load
                            ? SpinKitFadingCircle(
                                color: CColors.white,
                                size: 15,
                              )
                            : SvgPicture.asset('assets/icons/add.svg'),
                      ),
                    ),
                  ),
                ),
                widget.fruit.inCart != 0
                    ? Positioned(
                        bottom: 7,
                        child: load
                            ? SpinKitFadingCircle(
                                color: CColors.darkGreen,
                                size: 15,
                              )
                            : Text(
                                '${widget.fruit.inCart}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xff3c4959),
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.left,
                              ),
                      )
                    : Container(),
                widget.fruit.inCart != 0
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            changeQnt(2, widget.fruit.id);
                            setState(() {
                              widget.fruit.inCart =
                                  widget.fruit.inCart - widget.fruit.unitRate;
                            });
                          },
                          child: Container(
                            height: 31,
                            width: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(19.0),
                                bottomLeft: Radius.circular(19.0),
                              ),
                              color: const Color(0xffe3e7eb),
                            ),
                            child: Center(
                              child:
                                  SvgPicture.asset('assets/icons/remove.svg'),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
  }
}
