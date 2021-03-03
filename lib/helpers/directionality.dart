import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Direction extends StatefulWidget {
  final Widget child;

  const Direction({Key key, this.child}) : super(key: key);
  @override
  _DirectionState createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  bool isArabic = false;

  checkLang() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString('language')=='ar'){
      setState(() {
        isArabic = true;
      });
    }else{
      setState(() {
        isArabic = false;
      });
    }
  }

  @override
  void initState() {
    checkLang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic?TextDirection.rtl:TextDirection.ltr,
      child: widget.child,
    );
  }
}
