import 'package:flutter/material.dart';
import 'package:harvest/helpers/Localization/lang_provider.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';


class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: CColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          LangProvider().getLocaleCode() == 'ar'?Icons.chevron_left: Icons.chevron_right,
          color: CColors.headerText,
        ),

      ),
    );
  }
}
