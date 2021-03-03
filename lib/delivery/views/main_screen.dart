import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:harvest/customer/components/home_tab.dart';
import 'package:harvest/delivery/models/order.dart';
import 'package:harvest/delivery/views/order_details.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/category_selector.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:harvest/delivery/widgets/order_card.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Order> _orders = [
    Order(
      id: 0,
      statusId: 1,
    ),
    Order(
      id: 1,
      statusId: 2,
    ),
    Order(
      id: 2,
      statusId: 3,
    ),
    Order(
      id: 3,
      statusId: 4,
    ),
    Order(
      id: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WaveAppBarBody(
        backgroundGradient: CColors.greenAppBarGradient(),
        bottomViewOffset: Offset(0, -10),
        topHeader: PinnedTopHeader(
          maxHeight: 45,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CategorySelector(
              // categories: [
              //   'All',
              //   'Pending',
              //   'Delivered',
              //   'Cancelled',
              //   'Rejected',
              // ],
            ),
          ),
        ),
        actions: [
          SvgPicture.asset(Constants.menuIcon),
        ],
        leading:
        // Container(
        //   height: 26,
        //   width: 26,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(7.0),
        //     color: const Color(0xffffffff),
        //   ),
        //   child: Center(
        //     child: SvgPicture.string(
        //       '<svg viewBox="48.5 33.5 3.9 7.7" ><path transform="translate(827.02, -332.54)" d="M -774.6773681640625 366.0396728515625 L -778.5523681640625 369.9146728515625 L -774.6773681640625 373.7896118164063" fill="none" stroke="#3c4959" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" /></svg>',
        //       allowDrawingOutsideViewBox: true,
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // )
        Container(),
        child: ListView.builder(
            itemCount: _orders.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      CustomPageRoute(
                        builder: (context) => OrderDetails(
                          order: _orders[index],
                        ),
                      )),
                  child: OrderCard(
                    order: _orders[index],
                  ),
                ))),
      ),
    );
  }
}

