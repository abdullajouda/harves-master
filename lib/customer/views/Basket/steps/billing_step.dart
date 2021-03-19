import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Wallet/wallet_amount_viewer.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';

import '../order_done.dart';


class PaymentMethod {
  final int id;
  final String title;
  final String iconPath;

  const PaymentMethod({
    this.id,
    this.title,
    this.iconPath,
  });
}

class BillingStep extends StatefulWidget {
  @override
  _BillingStepState createState() => _BillingStepState();
}

class _BillingStepState extends State<BillingStep> {
  int _chosenIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<PaymentMethod> _paymentMethods = [
      PaymentMethod(title: "Banck Account", iconPath: Constants.bankIcon),
      PaymentMethod(title: "Card", iconPath: Constants.creditCardIcon),
      PaymentMethod(title: "PayPal", iconPath: Constants.payPalIcon),
      PaymentMethod(title: "Cash", iconPath: Constants.cashIcon),
    ];

    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "choose_payment_method".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDone(),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: CColors.white,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(5),
                          offset: Offset(0, 5.0),
                          spreadRadius: 1,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "required_amount".trs(context) + "\t" * 2,
                            style: TextStyle(
                              color: CColors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: " \$",
                              style: TextStyle(
                                fontSize: 14,
                                color: CColors.lightOrange,
                              ),
                              children: [
                                TextSpan(
                                  text: "65.50",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: CColors.headerText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                WalletAmount(amount: '250.055'),
                SizedBox(height: 5),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    // primary: false,
                    // physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: _paymentMethods.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 135 / 137,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final _paymentMethod = _paymentMethods[index];
                      final _isSelected = _chosenIndex == index;
                      return GestureDetector(
                        onTap: () => setState(() => _chosenIndex = index),
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: _isSelected ? Border.all(color: CColors.lightGreen, width: 2) : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(5),
                                offset: Offset(0, 5.0),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(_paymentMethod.iconPath, width: 25, height: 25),
                                SizedBox(height: 10),
                                Text(
                                  _paymentMethod.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: CColors.headerText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        // BasketPagesControlles(
        //   enableContinue: _chosenIndex != -1,
        // ),
      ],
    );
  }
}
