import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/helpers/colors.dart';

// import 'services/app_localization.dart';

const String api = 'http://plus.plr.sa/api/V1/';

const String appName = 'Harvest';
const String appStoreId = 'com.example.harvest';

const kPrimaryColor = Color(0xff3C984F);
const kSecondaryColor = Color(0xffc99200);
const kDarkPrimaryColor = Color(0xffecb7bf);
const kFontRoboto = 'Roboto';
const kFontNeoSans = 'NeoSans';

const deviceType = 'android';
const fcmToken = '1111';
const userToken = 'userToken';

// String translateText(BuildContext context, String key) {
//   return AppLocalization.of(context).translate(key);
// }

//getLang()async{
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  return prefs.getString('language');
//}

// class FieldValidator {
//   static String validate(String value, context) {
//     if (value.isEmpty) {
//       return translateText(context, 'field_cant_be_empty');
//     }
//     return null;
//   }
// }

InputDecoration searchDecoration(hint, icon) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontFamily: 'SF Pro Rounded',
      fontSize: 16,
      color: const Color(0xffe3e3e3),
      letterSpacing: -0.256,
      height: 1.25,
    ),
    prefixIcon: icon,
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}

InputDecoration inputDecoration(hint) {
  return InputDecoration(
    filled: true,
    contentPadding: EdgeInsets.symmetric(vertical: 20),
    hintText: hint,
    fillColor: CColors.fadeBlue,
    hintStyle: TextStyle(
        color: CColors.grey, fontWeight: FontWeight.w400, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
  );
}

InputDecoration inputDecorationWithIcon(hint, icon) {
  return InputDecoration(
    filled: true,
    prefixIcon: Container(
        width: 20,
        child: Center(
          child: icon,
        )),
    contentPadding: EdgeInsets.symmetric(vertical: 20),
    hintText: hint,
    fillColor: CColors.fadeBlue,
    hintStyle: TextStyle(
        color: CColors.grey, fontWeight: FontWeight.w400, fontSize: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Colors.red, width: 1),
    ),
  );
}

InputDecoration fatInputDecoration(title) {
  return InputDecoration(
    contentPadding: new EdgeInsets.only(top: 5.0, left: 10.0, right: 10),
    hintStyle: TextStyle(
      fontSize: 16,
      color: const Color(0xff717171),
    ),
    hintText: title,
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}

InputDecoration hintInputDecoration(title) {
  return InputDecoration(
    contentPadding: new EdgeInsets.symmetric(horizontal: 10.0),
    hintStyle: TextStyle(
      fontSize: 16,
      color: const Color(0xff717171),
    ),
    hintText: title,
    border: InputBorder.none,
    errorBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );
}
