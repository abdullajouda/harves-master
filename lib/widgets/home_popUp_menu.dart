import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_profile.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Wallet/wallet.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:provider/provider.dart';
import 'package:harvest/helpers/persistent_tab_controller_provider.dart';
import 'package:harvest/helpers/Localization/app_translations.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/find_us.dart';

class HomePopUpMenuModel {
  final String iconPath;
  final String title;
  final VoidCallback onPressed;

  HomePopUpMenuModel({
    @required this.iconPath,
    @required this.title,
    this.onPressed,
  });
}

class HomePopUpMenu extends StatefulWidget {
  HomePopUpMenu({
    Key key,
  }) : super(key: key);

  @override
  _HomePopUpMenuState createState() => _HomePopUpMenuState();
}

class _HomePopUpMenuState extends State<HomePopUpMenu> {
  @override
  Widget build(BuildContext context) {
    final List<HomePopUpMenuModel> _options = [
      HomePopUpMenuModel(
        iconPath: Constants.homeMenuIcon,
        title: 'Home',
        onPressed: () => context.read<PTVController>().jumbToTab(AppTabs.Home),
      ),
      HomePopUpMenuModel(
        iconPath: Constants.profileMenuIcon,
        title: 'Profile',
        onPressed: () {
          Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (context) => UserProfile(),
            ),
          );
        },
      ),
      HomePopUpMenuModel(
        iconPath: 'assets/icons/credit-card.svg',
        title: 'wallet',
        onPressed: () {
          Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (context) => Wallet(),
            ),
          );
        },
      ),
      HomePopUpMenuModel(
        iconPath: 'assets/icons/info.svg',
        title: 'About Us',
      ),
      HomePopUpMenuModel(
        iconPath: Constants.mailMenuIcon,
        title: 'Find Us',
        onPressed: () {
          Navigator.push(
            context,
            platformPageRoute(
              context: context,
              builder: (context) => FindUS(),
            ),
          );
        },
      ),
      HomePopUpMenuModel(
        iconPath: 'assets/icons/bell.svg',
        title: 'Notifications',
      ),
      HomePopUpMenuModel(
        iconPath: Constants.termsMenuIcon,
        title: 'Terms of use',
      ),
      HomePopUpMenuModel(
        iconPath: Constants.privacyMenuIcon,
        title: 'Privacy',
      ),
      HomePopUpMenuModel(
        iconPath: Constants.logoutMenuIcon,
        title: 'Sign out',
      ),
    ];
    return PopupMenuButton<int>(
      icon: SvgPicture.asset(Constants.menuIcon, width: 15, height: 15),
      padding: EdgeInsets.zero,
      offset: Offset(-50, 10),
      onSelected: (index) {
        final _item = _options[index];
        if (_item.onPressed != null) _item.onPressed();
      },
      onCanceled: null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => List.generate(
        _options.length,
        (index) {
          final _option = _options[index];
          return PopupMenuItem(
            height: 40,
            value: index,
            enabled: _option.onPressed != null,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_option.iconPath != null)
                    SvgPicture.asset(_option.iconPath,
                        color: Color(0x0ff525768), width: 15, height: 15),
                  SizedBox(width: 6),
                  Text(
                    _option.title.trs(context),
                    style: TextStyle(
                      fontSize: 16,
                      color: CColors.headerText,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
