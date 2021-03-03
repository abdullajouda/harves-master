import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/fruit.dart';

class FavoriteItem extends StatelessWidget {
  final Fruit fruit;

  const FavoriteItem({Key key, this.fruit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
        clipBehavior: Clip.none, alignment: Alignment.center,
        children: [
          Positioned(
            top: 3,
            child: Hero(
              tag: fruit,
              child: Container(
                height: 84,
                width: 87,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(fruit.image),
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
          ),
          Positioned(
            right: -7,
            top: -7,
            child: Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x12000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Center(child: SvgPicture.asset('assets/icons/cancel.svg')),
            ),
          ),
          fruit.isOnSale
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
                  '25% Off',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
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
            left: 20,
            bottom: fruit.inCart ? 40 : 13,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fruit.title,
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 12,
                    color: const Color(0xff3c4959),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    fruit.description,
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      fontSize: 10,
                      color: const Color(0xffe3e7eb),
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  '${fruit.price}\$/kilo',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 12,
                    color: const Color(0xff3c984f),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 31,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(19.0),
                  bottomRight: Radius.circular(19.0),
                ),
                color: const Color(0xff3c984f),
              ),
              child: Center(child: SvgPicture.asset('assets/icons/add.svg'),),
            ),
          ),
          fruit.inCart
              ? Positioned(
            bottom: 7,
            child: Text(
              fruit.quantity.toString(),
              style: TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 16,
                color: const Color(0xff3c4959),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
          )
              : Container(),
          fruit.inCart
              ? Positioned(
            bottom: 0,
            left: 0,
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
              child: Center(child: SvgPicture.asset('assets/icons/remove.svg'),),
            ),
          )
              : Container()
        ],
      ),
    );
  }
}
