import 'package:flutter/material.dart';
import 'package:harvest/customer/models/featured_product.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/helpers/color_converter.dart';

class SpecialItem extends StatelessWidget {
  final FeaturedProduct fruit;

  const SpecialItem({Key key, this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        height: 168,
        width: 125,
        child: Stack(
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 0,
              child: Container(
                height: 168,
                width: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: HexColor.fromHex(fruit.specialFoodBg != ''
                      ? fruit.specialFoodBg
                      : '#5ECC74'),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x17000000),
                      offset: Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -5,
              bottom: 5,
              child: Hero(
                tag: fruit.image,
                child: Container(
                  decoration: BoxDecoration(
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: const Color(0x1a000000),
                    //     offset: Offset(0, 4),
                    //     blurRadius: 10,
                    //   ),
                    // ],
                  ),
                  child: Image.network(
                    fruit.image,
                    fit: BoxFit.fitWidth,
                    width: 136.0,
                    height: 136.0,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fruit.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${fruit.price}\$/${fruit.typeName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
