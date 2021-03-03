import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/customer/components/WaveAppBar/appBar_body.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_addresses.dart';
import 'package:harvest/customer/widgets/profile_text_field.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _image =
      r'''https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fimages.hellogiggles.com%2Fuploads%2F2017%2F06%2F13074112%2Fgal.jpg&f=1&nofb=1''';

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final trs = AppTranslations.of(context);
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        leading: SvgPicture.asset(Constants.basketIcon),
        // pinned: true,
        // hideActions: true,
        backgroundGradient: CColors.greenAppBarGradient(),
        actions: [HomePopUpMenu()],
        bottomView: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CColors.lightOrange,
                    border: Border.all(color: CColors.white, width: 3),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_image),
                    ),
                  ),
                ),
                Positioned.directional(
                  textDirection: trs.textDirection,
                  end: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CColors.darkGreen,
                      border: Border.all(color: CColors.white, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              "Hala Ahmed",
              style: TextStyle(
                color: CColors.headerText,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            )
          ],
        ),
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: size.height * 0.1,
              left: 25,
              right: 25,
              bottom: 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "account_setting".trs(context),
                  style: TextStyle(
                    fontSize: 16,
                    color: CColors.headerText,
                  ),
                ),
                NoBGTextField(
                  hint: "Name",
                  contentPadding: EdgeInsetsDirectional.only(
                      start: 20, top: 15, bottom: 15),
                ),
                NoBGTextField(
                  hint: "Phone Number",
                  textInputType: TextInputType.phone,
                  icon: Icon(FontAwesomeIcons.mobileAlt,
                      color: CColors.lightGreen),
                ),
                NoBGTextField(
                  hint: "E-mail",
                  textInputType: TextInputType.emailAddress,
                  icon: Icon(FontAwesomeIcons.envelope,
                      color: CColors.lightGreen),
                ),
                NoBGTextField(
                  hint: "Address",
                  textInputType: TextInputType.emailAddress,
                  icon: Container(
                      height: 20,
                      width: 15,
                      child: Center(
                          child: SvgPicture.asset(
                              'assets/icons/location_icon.svg',
                              color: CColors.lightGreen))),
                ),
                UserAddresses(),
                Stack(
                  clipBehavior: Clip.none, children: [
                    Container(
                      decoration: BoxDecoration(
                        color: CColors.fadeBlue,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  SvgPicture.asset(Constants.settingsIcon),
                                  Text(
                                    "app_setting".trs(context),
                                    style: TextStyle(
                                      color: CColors.headerText,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            _SettingsButton(
                              iconPath: Constants.languageIcon,
                              title: "English",
                            ),
                            _SettingsButton(
                              iconPath: Constants.questionIcon,
                              title: "help".trs(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned.directional(
                      textDirection: trs.textDirection,
                      end: -10,
                      top: -10,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CColors.darkOrange,
                          border: Border.all(color: CColors.white, width: 3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String title;
  final TextStyle textStyle;
  final Size iconSize;

  const _SettingsButton({
    Key key,
    @required this.iconPath,
    @required this.title,
    this.textStyle,
    this.iconSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: CColors.fadeBlueAccent,
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: iconSize?.height ?? 19,
                width: iconSize?.width ?? 19,
              ),
              SizedBox(width: 11),
              Text(
                title,
                style: TextStyle(
                  color: CColors.headerText,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ).merge(textStyle),
              )
            ],
          ),
        ),
      ),
    );
  }
}
