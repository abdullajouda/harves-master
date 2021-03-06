import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/views/product_details.dart';

class FavoriteItem extends StatefulWidget {
  final Products fruit;
  final VoidCallback remove;

  const FavoriteItem({Key key, this.fruit, this.remove}) : super(key: key);

  @override
  _FavoriteItemState createState() => _FavoriteItemState();
}

class _FavoriteItemState extends State<FavoriteItem> {
  bool load = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          CupertinoPageRoute(
            builder: (context) => ProductDetails(
              fruit: widget.fruit,
            ),
          ),
        );
      },
      child: Container(
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
          clipBehavior: Clip.none,
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
              right: -18,
              top: -18,
              child: GestureDetector(
                onTap: widget.remove,
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                        color: const Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x12000000),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                          child: SvgPicture.asset('assets/icons/cancel.svg')),
                    ),
                  ),
                ),
              ),
            ),
            widget.fruit.discount != 0
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
                          '${widget.fruit.discount}% Off',
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
              bottom: widget.fruit.inCart == '1' ? 40 : 13,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fruit.name,
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
                      widget.fruit.description ?? '',
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
                    '${widget.fruit.price}\$/kilo',
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
                child: Center(
                  child: SvgPicture.asset('assets/icons/add.svg'),
                ),
              ),
            ),
            widget.fruit.inCart == '1'
                ? Positioned(
                    bottom: 7,
                    child: Text(
                      widget.fruit.qty.toString(),
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
            widget.fruit.inCart == '1'
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
                      child: Center(
                        child: SvgPicture.asset('assets/icons/remove.svg'),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
