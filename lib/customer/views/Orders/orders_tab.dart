import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/components/WaveAppBar/appBar_body.dart';
import 'package:harvest/customer/components/WaveAppBar/pinned_header.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/Orders/current_orders.dart';
import 'package:harvest/customer/views/Orders/old_orders.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';

enum _OrdersTabs { Current, Old }

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  _OrdersTabs _ordersTab = _OrdersTabs.Current;

  @override
  Widget build(BuildContext context) {
    final _orderTabsTitles = [
      "current_order",
      "old_order",
    ];
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, -10),
        backgroundGradient: CColors.greenAppBarGradient(),
        actions: [HomePopUpMenu()],
        leading: BasketButton(),
        topHeader: PinnedTopHeader(
          maxHeight: 46,
          margin: EdgeInsetsDirectional.only(start: 10)
              .add(EdgeInsets.symmetric(vertical: 10)),
          child: _buildTopSelector(_orderTabsTitles, context),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child:
              _ordersTab == _OrdersTabs.Current ? CurrentOrders() : OldOrders(),
        ),
      ),
    );
  }

  Widget _buildTopSelector(
      List<String> _orderTabsTitles, BuildContext context) {
    return Row(
      children: List.generate(
        _OrdersTabs.values.length,
        (index) {
          final bool _isSelected =
              index == _OrdersTabs.values.indexWhere((e) => e == _ordersTab);
          return GestureDetector(
            onTap: () {
              setState(() => _ordersTab = _OrdersTabs.values[index]);
            },
            child: Card(
              elevation: 0.0,
              color: _isSelected ? CColors.darkOrange : CColors.transparent,
              margin: const EdgeInsetsDirectional.only(end: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(13),
                  topEnd: Radius.circular(13),
                  bottomStart: Radius.circular(13),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
                child: Text(
                  _orderTabsTitles[index].trs(context),
                  style: TextStyle(
                    color: _isSelected ? CColors.white : CColors.boldBlack,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
