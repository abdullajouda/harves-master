import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/Basket/free_shipping_slider.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_addresses.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/Widgets/remove_icon.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasketStep extends StatefulWidget {
  final VoidCallback onContinuePressed;

  const BasketStep({
    Key key,
    this.onContinuePressed,
  }) : super(key: key);

  @override
  _BasketStepState createState() => _BasketStepState();
}

class _BasketStepState extends State<BasketStep> {
  bool load = true;
  bool showFree = false;
  double total;
  List<int> _errorIndexes = [];
  City _city;
  double remains;
  List<City> _cities = [];

  getCart() async {
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'getMyCart', headers: {
      'Accept': 'application/json',
      'fcmToken': prefs.getString('fcm_token'),
      'Accept-Language': LangProvider().getLocaleCode(),
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });

    var response = json.decode(request.body);
    var items = response['items'];
    setState(() {
      total = double.parse(response['total']);
    });
    items.forEach((element) {
      CartItem item = CartItem.fromJson(element);
      cart.addItem(item);
    });
    setState(() {
      load = false;
    });
  }

  showFreeDelivery() async {
    // var op = Provider.of<UserFunctions>(context, listen: false);
    // var ci = Provider.of<CityOperations>(context, listen: false);
    var settings = await get(ApiHelper.api + 'getSetting', headers: {
      'Accept': 'application/json',
      'Accept-Language': LangProvider().getLocaleCode(),
    });
    var request =
        await get(ApiHelper.api + 'getCities', headers: ApiHelper.headers);
    var response = json.decode(request.body);
    var items = response['cities'];
    items.forEach((element) {
      City city = City.fromJson(element);
      _cities.add(city);
    });
    var set = json.decode(settings.body)['items'];
    // setState(() {
    //   for(var city in _cities){
    //     if(city.id == op.user.cityId){
    //       _city = city;
    //     }
    //   }
    //   print(_city);
    //   print(op.user.cityId);
    // });
    if (set['show_delivery_free_msg'] == 1) {
      setState(() {
        showFree = true;
      });
    }
  }

  @override
  void initState() {
    showFreeDelivery();
    getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "in_basket_now".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 5),
        Expanded(
          child: load ? Center(child: LoadingPhone()) : _buildItemsBody(size),
        ),
      ],
    );
  }

  ListView _buildItemsBody(Size size) {
    var cart = Provider.of<Cart>(context);
    return ListView.separated(
      itemCount: cart.items.length,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      separatorBuilder: (context, index) {
        final _hasError = _itemHasError(index + 1);
        if (_hasError) return SizedBox(height: 5);
        return SizedBox(height: 25);
      },
      itemBuilder: (context, index) {
        final bool _hasError = _itemHasError(index);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  if (cart.items.values.toList()[index].product.available <
                      cart.items.values.toList()[index].quantity) {
                    _errorIndexes.add(index);
                  }else{
                    _errorIndexes.remove(index);

                  }
                });
              },
              child: Column(
                children: [
                  if (_hasError)
                    Align(
                      alignment: AlignmentDirectional(-0.9, 0.0),
                      child: _buildRemainingItemsCard(context, index, cart),
                    ),
                  RemoveIcon(
                    onTap: () {
                      setState(() {

                        cart.removeFav(cart.items.values.toList()[index]);
                        if (cart.items.values.toList()[index].product.available <
                            cart.items.values.toList()[index].quantity) {
                          _errorIndexes.add(index);
                        }else{
                          _errorIndexes.remove(index);

                        }
                      });
                    },
                    iconAlignment: Alignment.topRight,
                    deocation: RemoveIconDecoration.copyWith(
                      iconColor: CColors.headerText,
                      iconSize: 16,
                      backgroundColor: CColors.white,
                      borderColor:
                          _hasError ? CColors.coldPaleBloodRed : CColors.white,
                      borderWidth: 2,
                      elevation: 1,
                      raduis: 2,
                    ),
                    shadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(15),
                        offset: Offset(0, 5.0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        border: Border.all(
                          color: _hasError
                              ? CColors.coldPaleBloodRed
                              : CColors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            offset: Offset(0, 5.0),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        leading: Image.network(
                            cart.items.values.toList()[index].product.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover),
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                cart.items.values.toList()[index].product.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xff3c984f),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                cart.items.values
                                        .toList()[index]
                                        .product
                                        .description ??
                                    '',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 10,
                                  color: const Color(0xff888a8d),
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "${cart.items.values.toList()[index].product.price}\$/${cart.items.values.toList()[index].product.typeName}",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color(0xff3c984f),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 10),
                                CIconButton(
                                  onTap: () {
                                    if (cart.items.values
                                            .toList()[index]
                                            .quantity !=
                                        0) {
                                      setState(() {
                                        cart.items.values
                                            .toList()[index]
                                            .quantity--;
                                        if (cart.items.values.toList()[index].product.available <
                                            cart.items.values.toList()[index].quantity) {
                                          _errorIndexes.add(index);
                                        }else{
                                          _errorIndexes.remove(index);

                                        }
                                      });
                                    }
                                  },
                                  color: CColors.darkOrange,
                                  icon: Icon(Icons.remove,
                                      color: CColors.white, size: 15),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: Text(
                                    "${cart.items.values.toList()[index].quantity}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: CColors.headerText,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                CIconButton(
                                  onTap: () {
                                    setState(() {
                                      cart.items.values
                                          .toList()[index]
                                          .quantity++;
                                      if (cart.items.values.toList()[index].product.available <
                                          cart.items.values.toList()[index].quantity) {
                                        _errorIndexes.add(index);
                                      }else{
                                        _errorIndexes.remove(index);

                                      }
                                    });
                                  },
                                  color: CColors.darkOrange,
                                  icon: Icon(Icons.add,
                                      color: CColors.white, size: 15),
                                ),
                              ],
                            ),
                            Text.rich(
                              TextSpan(
                                text: " \$",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: const Color(0xfff88518),
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        "${cart.items.values.toList()[index].quantity * cart.items.values.toList()[index].product.price}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xff3c4959),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            index == cart.items.length - 1
                ? Column(
                    children: [
                      SizedBox(height: 40),
                      Align(
                        alignment: AlignmentDirectional(-.8, 0.0),
                        child: _AdditionalNotes(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 46),
                        child: Column(
                          children: [
                            showFree
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Card(
                                              color: CColors.darkOrange,
                                              elevation: 0.0,
                                              margin: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .only(
                                                  bottomEnd:
                                                      Radius.circular(13),
                                                  topStart: Radius.circular(13),
                                                  topEnd: Radius.circular(13),
                                                ),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                child: Text(
                                                  "${remains.toString()}\$",
                                                  style: TextStyle(
                                                      color: CColors.white),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              "remains_for_free_shipping"
                                                  .trs(context),
                                              style: TextStyle(
                                                color: CColors.grey,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: FreeShippingSlider(
                                            persentage: 0.5,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.13)
                                  .add(EdgeInsets.only(bottom: 15, top: 15)),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x14000000),
                                      offset: Offset(0, 6),
                                      blurRadius: 21,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 15),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Total" + "\t" * 2,
                                            style: TextStyle(
                                              color: CColors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              text: "\$",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: CColors.darkOrange,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: "$total",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: CColors.headerText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: widget.onContinuePressed,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: CColors.lightGreen,
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(5),
                                              offset: Offset(0, 5.0),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30, vertical: 13),
                                          child: Text(
                                            "continue".trs(context),
                                            style: TextStyle(
                                              color: CColors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        );
      },
    );
  }

  bool _itemHasError(int index) => _errorIndexes.contains(index);

  Widget _buildRemainingItemsCard(BuildContext context, index, cart) {
    return Card(
      color: CColors.coldPaleBloodRed,
      elevation: 0.0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(11.5))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Text(
          "${cart.items.values.toList()[index].product.available}\t" +
              "item_remains".trs(context),
          style: TextStyle(
            color: CColors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _AdditionalNotes extends StatefulWidget {
  final ValueChanged<String> onAddNote;

  const _AdditionalNotes({
    Key key,
    this.onAddNote,
  }) : super(key: key);

  @override
  __AdditionalNotesState createState() => __AdditionalNotesState();
}

class __AdditionalNotesState extends State<_AdditionalNotes> {
  TextEditingController _textEditingController;
  double _textFieldHeight = 0;
  final double _finalValue = 100.0;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
    super.dispose();
  }

  void _toggleTextFieldHeight() {
    if (_textFieldHeight == _finalValue)
      _textFieldHeight = 0;
    else
      _textFieldHeight = _finalValue;
  }

  bool get _isNormalNotesHeight => _textFieldHeight == _finalValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () => setState(_toggleTextFieldHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CColors.headerText,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          _isNormalNotesHeight ? Icons.remove : Icons.add,
                          color: CColors.white,
                          size: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: 7),
                    Text(
                      "additional_note".trs(context),
                      style: TextStyle(
                        color: CColors.headerText,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _textFieldHeight,
                decoration: BoxDecoration(
                  color: CColors.brightLight,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: _textEditingController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    isDense: true,
                    focusColor: CColors.brightLight,
                    fillColor: CColors.brightLight,
                    contentPadding: EdgeInsetsDirectional.only(
                        start: 10, top: 9, bottom: 9),
                    hintStyle: TextStyle(fontSize: 12),
                    border: _buildBorder(),
                    focusedBorder: _buildBorder(),
                    enabledBorder: _buildBorder(),
                  ),
                ),
              ),
              Positioned(
                  right: 6,
                  bottom: 6,
                  child: SvgPicture.asset('assets/icons/additional_icon.svg'))
            ],
          ),
        ],
      ),
    );
  }

  ShapeBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide.none,
    );
  }
}
