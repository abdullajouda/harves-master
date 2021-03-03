import 'package:flutter/material.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/make_favorite_button.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';

class ProductBundleDetails extends StatefulWidget {
  final Products fruit;

  ProductBundleDetails({
    Key key,
    this.fruit,
  }) : super(key: key);

  @override
  _ProductBundleDetailsState createState() => _ProductBundleDetailsState();
}

class _ProductBundleDetailsState extends State<ProductBundleDetails> {
  final color = const Color(0xffEAF4FF);
  final _productDescription =
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.";
  bool _isFavorite = false;
  int _qty = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Container(
          color: color,
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
                flex: 4,
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
                              "Fruit Basket",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CColors.headerText,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "1 Kilo",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              if (_qty > 0) ...[
                                CIconButton(
                                  onTap: () {
                                    if (_qty == 0) return;
                                    setState(() => _qty--);
                                  },
                                  icon: Icon(Icons.remove, color: CColors.headerText, size: 25),
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
                              ],
                              CIconButton(
                                onTap: () => setState(() => _qty++),
                                icon: Icon(Icons.add, color: CColors.headerText, size: 25),
                              ),
                              if (_qty == 0)
                                Text("add_to_basket".trs(context), style: TextStyle(fontSize: 13, color: CColors.grey)),
                            ],
                          ),
                          Text(
                            "\$10.5",
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
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    _productDescription,
                                    style: TextStyle(
                                      color: CColors.normalText,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    return _BundleProduct();
                                  },
                                ),
                              ),
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
                          Expanded(
                            child: MainButton(
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
    return SizedBox(
      height: size.height * 0.09,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: CColors.brightLight,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SizedBox(width: size.width * 0.15),
                    Text(
                      "Banana",
                      style: TextStyle(
                        color: CColors.headerText,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "3 items",
                      style: TextStyle(
                        color: CColors.headerText,
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Image.asset(
              "assets/images/blueb.png",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
