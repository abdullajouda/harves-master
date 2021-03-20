import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/models/category.dart';
import 'package:harvest/customer/models/favorite.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/home/special_products_details.dart';
import 'package:harvest/customer/widgets/Fruit_item.dart';
import 'package:harvest/helpers/color_converter.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:provider/provider.dart';

import '../product_details.dart';

class OffersPage extends StatefulWidget {
  final Category category;
  final String color;

  const OffersPage({Key key, this.category, this.color}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  @override
  Widget build(BuildContext context) {
    FavoriteOperations op = Provider.of<FavoriteOperations>(context);
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        backgroundGradient: CColors.gradientGenerator(
            color1: HexColor.fromHex(widget.color),
            color2: HexColor.fromHex(widget.color)),
        shadowColor: HexColor.fromHex(widget.color),
        // topHeader: PinnedTopHeader(
        //   maxHeight: 45,
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 10),
        //     child: CategorySelector(),
        //   ),
        // ),
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CustomPageRoute(
                  // context: context,
                  builder: (context) => Basket(),
                ),
              );
            },
            child: BasketButton()),
        actions: [Container()],
        bottomView: Card(
          // margin: EdgeInsets.symmetric(horizontal: size.width * 0.13),
          elevation: 10,
          shadowColor: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.teal,
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text.rich(
              TextSpan(
                text: "Save Up to 50%" + "\t\t",
                style: TextStyle(
                  color: HexColor.fromHex(widget.color),
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  TextSpan(
                    text: "April Offers",
                    style: TextStyle(
                      color: CColors.normalText,
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        children: [
          // FlatButton(
          //   onPressed: () {
          //     Navigator.of(context, rootNavigator: true).push(platformPageRoute(
          //       context: context,
          //       builder: (context) => ProductBundleDetails(),
          //     ));
          //
          //     // AlertManager.showDropDown(
          //     //   alertBody: AlertBody(
          //     //     title: "added successfully to Cart",
          //     //     message: "You can find it in your cart  screen",
          //     //     icon: Icon(
          //     //       Icons.check,
          //     //     ),
          //     //   ),
          //     // );
          //   },
          //   child: Text("Go to Bundle"),
          // ),
          GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18),
              itemCount: op.homeItems.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                if (op.homeItems.values.toList()[index].categoryId ==
                    widget.category.id) {
                  return GestureDetector(
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      CupertinoPageRoute(
                        builder: (context) => ProductDetails(
                          fruit: op.homeItems.values.toList()[index],
                        ),
                      ),
                    ),
                    child: FruitItem(
                      fruit: op.homeItems.values.toList()[index],
                      color: HexColor.fromHex(widget.color),
                    ),
                  );
                }
                return null;
              })
        ],
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
  }
}
