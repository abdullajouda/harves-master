import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/widgets/favorite_item.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import '../product_details.dart';

class FavoritesTab extends StatefulWidget {
  @override
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  List<Fruit> _fruits = [
    Fruit(
        isFavorite: true,
        isOnSale: true,
        title: 'Orange',
        description: 'description',
        image: 'assets/images/orange.png',
        inCart: true,
        price: 10,
        quantity: 5,
        sale: '25'),
    Fruit(
        isFavorite: true,
        isOnSale: false,
        title: 'Kiwi',
        description: 'description',
        image: 'assets/images/kiwi.png',
        inCart: false,
        price: 10,
        quantity: 0,
        sale: ''),
    Fruit(
        isFavorite: false,
        isOnSale: true,
        title: 'BlueBerry',
        description: 'description',
        image: 'assets/images/blueb.png',
        inCart: false,
        price: 10,
        quantity: 0,
        sale: '10'),
    Fruit(
        isFavorite: false,
        isOnSale: false,
        title: 'BlueBerry',
        description: 'description',
        image: 'assets/images/blueb.png',
        inCart: false,
        price: 10,
        quantity: 0,
        sale: ''),
    Fruit(
        isFavorite: false,
        isOnSale: false,
        title: 'Orange',
        description: 'description',
        image: 'assets/images/orange.png',
        inCart: false,
        price: 15,
        quantity: 0,
        sale: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        backgroundGradient: CColors.greenAppBarGradient(),
        actions: [
          HomePopUpMenu()
        ],
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
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(top: 10, bottom: 40)
                .add(EdgeInsets.symmetric(horizontal: 20)),
            child: Wrap(
              runSpacing: 30,
              spacing: 30,
              children: List.generate(_fruits.length, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(platformPageRoute(
                      context: context,
                      builder: (context) => ProductDetails(
                        // product: _fruits[index],
                      ),
                    ));
                  },
                  child: FavoriteItem(
                    fruit: _fruits[index],
                  ),
                );
              }),
            ),
          ),
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
}
