import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x17000000),
            offset: Offset(0, 2),
            blurRadius: 11,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 55,width: 55,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/orange.png'),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x2b000000),
                  offset: Offset(0, 3),
                  blurRadius: 7,
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Orange',
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      fontSize: 16,
                      color: const Color(0xff3c984f),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '10\$/kilo',
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      fontSize: 10,
                      color: const Color(0xff3c984f),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  '2 Items',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 12,
                    color: const Color(0xff3c4959),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '\$',
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontSize: 11,
                  color: const Color(0xfff88518),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                '7.90',
                style: TextStyle(
                  fontFamily: 'SF Pro Rounded',
                  fontSize: 16,
                  color: const Color(0xff3c4959),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              )
            ],
          )
        ],
      ),
    );
  }
}
