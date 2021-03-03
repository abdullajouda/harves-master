import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/delivery/models/order.dart';
import 'package:harvest/helpers/colors.dart';

class OrderCard extends StatefulWidget {
  final Order order;

  OrderCard({Key key, this.order}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1c000000),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: barColor(),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          color: color(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Date',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 10,
                                  color: const Color(0xff3c4959),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                widget.order.date ?? '',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 8,
                                  color: const Color(0xff3c4959),
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/clock.svg',
                          height: 18,
                          color: color(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Order Time',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 10,
                                  color: const Color(0xff3c4959),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                widget.order.buyer ?? '',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 8,
                                  color: const Color(0xff3c4959),
                                ),
                                textAlign: TextAlign.left,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 24,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: color(),
                      ),
                      child: Center(
                        child: Text(
                          widget.order.status ?? 'Unknown',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 10,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/bill.svg',
                    color: color(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill No.',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 10,
                            color: const Color(0xff3c4959),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          widget.order.billNo ?? '',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 8,
                            color: const Color(0xff3c4959),
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/profile.svg',
                    height: 18,
                    color: color(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.buyer ?? 'hala ahmed',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 10,
                            color: const Color(0xff3c4959),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          widget.order.buyer ?? '',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 8,
                            color: const Color(0xff3c4959),
                          ),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/money-bill-solid.svg',
                    color: color(),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '  Cash',
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          fontSize: 10,
                          color: const Color(0xff3c4959),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Row(
                        children: [
                          Text(
                            '  \$',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 8,
                              color: color(),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            widget.order.price ?? '',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 8,
                              color: const Color(0xff3c4959),
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/map-pin.svg',
                  color: color(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Egypt ,AlQahera, Jamal 43st',
                    style: TextStyle(
                      fontFamily: 'SF Pro Rounded',
                      fontSize: 10,
                      color: const Color(0xff3c4959),
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Text(
                  'CD 43, 4 floor',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 8,
                    color: const Color(0xff888a8d),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color color() {
    switch (widget.order.statusId) {
      case 1:
        return CColors.darkOrange;
        break;
      case 2:
        return CColors.darkGreen;
        break;
      case 3:
        return CColors.skyBlue;
        break;
      case 4:
        return CColors.grey;
        break;
      default:
        return CColors.darkOrange;
    }
  }

  Color barColor() {
    switch (widget.order.statusId) {
      case 1:
        return CColors.fadeOrange;
        break;
      case 2:
        return CColors.fadeGreen;
        break;
      case 3:
        return CColors.fadeBlue;
        break;
      case 4:
        return CColors.fadeBeige;
        break;
      default:
        return CColors.fadeOrange;
    }
  }
}
