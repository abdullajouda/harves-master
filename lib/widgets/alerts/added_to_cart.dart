import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/dialogs/alert_builder.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class AddedToCartAlert extends StatefulWidget {
  @override
  _AddedToCartAlertState createState() => _AddedToCartAlertState();
}

class _AddedToCartAlertState extends State<AddedToCartAlert> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: AlertBuilder(
        title: 'Added Successfully To Cart'.trs(context),
        subTitle: 'You can find it in your cart  screen'.trs(context),
        color: CColors.lightGreen,
        icon: Icon(
          Icons.check,
          color: CColors.white,
          size: 25,
        ),
      ),
    );
  }
}
