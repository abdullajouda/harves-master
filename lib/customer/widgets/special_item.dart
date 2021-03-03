import 'package:flutter/material.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';

class SpecialItem extends StatelessWidget {
  final Products fruit;

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
          children: [
            Positioned(
              left: 0,
              child: Container(
                height: 168,
                width: 115,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: const Color(0xfffdaa5c),
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
              right: 0,
              bottom: 10,
              child: Hero(
                tag: fruit.image,
                child: Container(
                  width: 108.0,
                  height: 104.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                       NetworkImage(fruit.image),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1a000000),
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 8,
              top: 15,
              child: Column(
                mainAxisSize: MainAxisSize.min,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fruit.name,
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      fontSize: 16,
                      color: const Color(0xffffffff),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${fruit.price}\$/${fruit.typeName}',
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
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
