import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/widgets/favorite_button.dart';

class FruitItem extends StatefulWidget {
  final Products fruit;
  final Color color;

  const FruitItem({Key key, this.fruit, this.color}) : super(key: key);

  @override
  _FruitItemState createState() => _FruitItemState();
}

class _FruitItemState extends State<FruitItem> {
  int _qty;

  @override
  void initState() {
    _qty = int.parse(widget.fruit.inCart);
    super.initState();
  }

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
            bottom: _qty != 0 ? 40 : 13,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.fruit.name ?? '',
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
                    color: widget.color != null
                        ? widget.color
                        : const Color(0xff3c984f),
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
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _qty = _qty + widget.fruit.unitRate;
                });
              },
              child: Container(
                height: 31,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(19.0),
                    bottomRight: Radius.circular(19.0),
                  ),
                  color:
                      widget.color != null ? widget.color : Color(0xff3c984f),
                ),
                child: Center(
                  child: SvgPicture.asset('assets/icons/add.svg'),
                ),
              ),
            ),
          ),
          _qty != 0
              ? Positioned(
                  bottom: 7,
                  child: Text(
                    '$_qty',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color(0xff3c4959),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                )
              : Container(),
          _qty != 0
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _qty = _qty - widget.fruit.unitRate;
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
                        child: SvgPicture.asset('assets/icons/remove.svg'),
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
