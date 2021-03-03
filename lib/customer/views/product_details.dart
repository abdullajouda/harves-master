import 'package:flutter/material.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/widgets/custom_icon_button.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/make_favorite_button.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';


class ProductDetails extends StatefulWidget {
  final Products products;
  ProductDetails({Key key, this.products}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final color = const Color(0xffFDAA5C);
  final _productDescription =
      "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal";

  int _qty = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    setState(() {
      _qty = widget.products.minQty;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
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
                child: Hero(
                  tag: widget.products,
                  child: Image.network(
                    widget.products.image,
                    height: 320,
                    width: 320,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                flex: 3,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -1.5),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.products.name??'',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: CColors.headerText,
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              "${widget.products.available} ${widget.products.typeName}",
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
                                    _productDescription,
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
                              constraints: BoxConstraints(maxHeight: 50),
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
