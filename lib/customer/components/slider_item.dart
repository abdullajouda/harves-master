import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/models/slider.dart';
import 'package:harvest/helpers/colors.dart';
class SliderItem extends StatelessWidget {
  final SliderModel slider;

  const SliderItem({Key key, this.slider}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      // height: size.height * 0.5,
      width: size.width,
      child: Column(
        children: [
          // SizedBox(height: size.height * 0.1),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: size.width * 0.7,
              width: size.width * 0.7,
              child: SvgPicture.asset(slider.image, fit: BoxFit.fitWidth),
            ),
          ),
          // SizedBox(height: size.height * 0.02),
          Expanded(
            child: Column(
              children: [
                Text(
                  slider.title??'',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CColors.headerText,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  slider.details,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CColors.headerText,
                    fontSize: 15,
                    // fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
