import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';

class WalletAmount extends StatelessWidget {
  final double amount;
  final EdgeInsetsGeometry margin;
  const WalletAmount({
    Key key,
    @required this.amount,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 20),
      // height: 50,
      decoration: BoxDecoration(
        color: CColors.white,
        borderRadius: BorderRadius.circular(12),
        gradient: CColors.walletGradient(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            offset: Offset(0, 5.0),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.wallet,
                  color: CColors.white.withOpacity(0.5),
                  size: 18,
                ),
                SizedBox(width: 7),
                Text(
                  "wallet_amount".trs(context),
                  style: TextStyle(
                    color: CColors.white,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            Text(
              "\$" + (amount ?? 250.00).toStringAsFixed(2),
              style: TextStyle(
                color: CColors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
