import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';

class AddressListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final TextStyle titleStyle;
  final String subTitle;
  final TextStyle subTitleStyle;
  final Color color;
  const AddressListTile({
    Key key,
    this.onTap,
    @required this.title,
    this.titleStyle,
    @required this.subTitle,
    this.subTitleStyle,
    this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: _ListTile(
          leading: SvgPicture.asset(Constants.mapPin, width: 40, height: 40),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: CColors.headerText,
            ).merge(titleStyle),
          ),
          subtitle: Text(
            subTitle,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ).merge(subTitleStyle),
          ),
        ),
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Color color;
  final RoundedRectangleBorder shape;
  final EdgeInsetsGeometry contentPadding;
  const _ListTile({
    Key key,
    @required this.leading,
    @required this.title,
    @required this.subtitle,
    this.color,
    this.shape,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? CColors.lightOrange,
        borderRadius: shape?.borderRadius ?? BorderRadius.circular(15),
      ),
      child: Padding(
        padding: contentPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leading,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                subtitle,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
