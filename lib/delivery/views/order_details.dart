import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/delivery/models/order.dart';
import 'package:harvest/delivery/widgets/dialogs/confirm_dialog.dart';
import 'package:harvest/delivery/widgets/dialogs/send_money_dialog.dart';
import 'package:harvest/delivery/widgets/order_details_card.dart';
import 'package:harvest/delivery/widgets/order_item.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:harvest/delivery/widgets/order_card.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  const OrderDetails({Key key, this.order}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  onConfirm() {
    showCupertinoDialog(
      context: context,
      builder: (context) => Center(child: ConfirmDialog()),
    );
  }

  onAdd() {
    showCupertinoDialog(
      context: context,
      builder: (context) => Center(child: SendMoneyDialog()),
    );
  }

  LinearGradient gradient(){
    switch(widget.order.statusId){
      case 1:
        return CColors.orangeAppBarGradient();
        break;
      case 2:
        return CColors.greenAppBarGradient();
        break;
      case 3:
        return CColors.blueAppBarGradient();
        break;
      case 4:
        return CColors.blackAppBarGradient();
        break;
      default:
        return CColors.greenAppBarGradient();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WaveAppBarBody(
            backgroundGradient: gradient(),
            bottomViewOffset: Offset(0, -10),
            actions: [
              SvgPicture.asset(Constants.menuIcon),
            ],
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: const Color(0xffffffff),
                ),
                child: Center(
                  child: SvgPicture.string(
                    '<svg viewBox="48.5 33.5 3.9 7.7" ><path transform="translate(827.02, -332.54)" d="M -774.6773681640625 366.0396728515625 L -778.5523681640625 369.9146728515625 L -774.6773681640625 373.7896118164063" fill="none" stroke="#3c4959" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Text(
                  'Order Details ',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 14,
                    color: const Color(0xff3c4959),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: OrderDetailsCard(
                  order: widget.order,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 20,
                ),
                child: Text(
                  'Order Items ',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 12,
                    color: const Color(0xff3c4959),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: OrderItem(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Text(
                  'Add Money to Customer Wallet',
                  style: TextStyle(
                    fontFamily: 'SF Pro Rounded',
                    fontSize: 12,
                    color: const Color(0xff3c4959),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 227.0,
                    height: 33.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color: const Color(0x0d2c2c2c),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => onAdd(),
                    child: Container(
                      width: 65,
                      height: 33,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11.0),
                        color: const Color(0xfffdaa5c),
                      ),
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 12,
                            color: const Color(0xff3c4959),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 36,
                      width: 124,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xffe4f0e6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/mobile.svg',
                            color: CColors.darkGreen,
                          ),
                          Text(
                            ' Call Hala',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 12,
                              color: CColors.darkGreen,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Container(
                      height: 36,
                      width: 124,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color(0xffe4f0e6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/map-pin.svg',
                            color: CColors.darkGreen,
                          ),
                          Text(
                            '  Go To Map',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 12,
                              color: CColors.darkGreen,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 118,
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 118,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(21.0),
                  topRight: Radius.circular(21.0),
                ),
                color: const Color(0xffffffff),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x17000000),
                    offset: Offset(0, -5),
                    blurRadius: 11,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => onConfirm(),
                    child: Container(
                      height: 40,
                      width: 147,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Color(0xff3c984f))),
                      child: Center(
                          child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'SF Pro Rounded',
                          fontSize: 16,
                          color: const Color(0xff3c984f),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => onConfirm(),
                    child: Container(
                      height: 40,
                      width: 147,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: const Color(0xff3c984f),
                      ),
                      child: Center(
                        child: Text(
                          'Delivered',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 16,
                            color: const Color(0xffffffff),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
