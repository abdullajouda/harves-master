import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:provider/provider.dart';


class UseWallet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    var cart = Provider.of<Cart>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: const Color(0xffffffff),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.elliptical(9999.0, 9999.0)),
                      color: const Color(0xa3f88518),
                    ),
                    child: Center(
                        child: SvgPicture.asset(
                            'assets/calender.svg')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Text(
                          '${'You Have a Wallet Balance Of'.trs(context)} ${cart.walletBalance} \n${'Use Wallet For This Purchase?'.trs(context)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xff3c4959),
                            letterSpacing: 0.14,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          cart.setUseWallet(0);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Container(
                            height: 35,
                            width: 82,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              border: Border.all(color: CColors.darkOrange),
                            ),
                            child: Center(
                              child: Text(
                                'No'.trs(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: CColors.darkOrange,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          cart.setUseWallet(1);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Container(
                            height: 35,
                            width: 82,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.0),
                              color: CColors.darkOrange,
                            ),
                            child: Center(
                              child: Text(
                                'Yes'.trs(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
