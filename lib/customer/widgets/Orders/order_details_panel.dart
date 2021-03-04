import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/customer/models/order-details.dart';
import 'package:harvest/customer/models/orders.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/Loader.dart';
import 'order_item_list_tile.dart';
import 'package:http/http.dart';

class OrderDetailsPanel extends StatefulWidget {
  final Order order;

  const OrderDetailsPanel({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _OrderDetailsPanelState createState() => _OrderDetailsPanelState();
}

class _OrderDetailsPanelState extends State<OrderDetailsPanel> {
  OrderDetails _order;
  bool loadOrder = true;

  int step() {
    switch (widget.order.status) {
      case 1:
        return 0;
        break;
      case 2:
        return 1;
        break;
      case 3:
        return 2;
        break;
      default:
        return 0;
    }
  }

  getOrderDetails() async {
    var request = await get(ApiHelper.api + 'getOrderDetail/${widget.order.id}',
        headers: ApiHelper.headersWithAuth);
    var response = json.decode(request.body);
    var value = response['Order Details'];
    OrderDetails order = OrderDetails.fromJson(value);
    setState(() {
      _order = order;
      loadOrder = false;
    });
  }

  @override
  void initState() {
    getOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.65,
      width: size.width,
      child: loadOrder
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: size.height * 0.3,
                width: size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Center(
                  child: Loader(),
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.8, 0),
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: Color.alphaBlend(
                        CColors.darkOrange.withOpacity(0.95),
                        CColors.boldBlack),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        "${_order.myOrder.deliveryTime.from} - ${_order.myOrder.deliveryTime.to}",
                        style: TextStyle(
                          color: CColors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: size.height * 0.61,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 20)
                          .add(
                        EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15, bottom: 5),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99)),
                              child:
                                  SizedBox(width: size.width * 0.35, height: 6),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9),
                            child: _OrderStepper(
                              currentStep: step(),
                              titles: [
                                "DPreparing".trs(context),
                                "DOn_my_way".trs(context),
                                "DDelivered".trs(context),
                              ],
                            ),
                          ),
                          _buildPanelHeader(),
                          Expanded(
                            child: Container(
                              // color: Colors.teal,
                              child: ListView.separated(
                                itemCount: _order.orderProduct.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 7),
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  return OrderItemListTile(
                                    name:
                                        _order.orderProduct[index].product.name,
                                    itemsNum:
                                        _order.orderProduct[index].quantity,
                                    image: _order
                                        .orderProduct[index].product.image,
                                    price: _order
                                        .orderProduct[index].product.price
                                        .toDouble(),
                                    pricePerKilo: _order
                                        .orderProduct[index].product.price
                                        .toDouble(),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildPanelFooter(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildPanelHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Bill No.",
              style: TextStyle(
                fontSize: 13,
                color: CColors.headerText,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              widget.order.id.toString(),
              style: TextStyle(
                fontSize: 12,
                color: CColors.headerText,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        Text(
          '${_order.myOrder.deliveryDate}',
          style: TextStyle(
            fontSize: 13,
            color: CColors.headerText,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildPanelFooter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "delivery_charge".trs(context),
                  style: TextStyle(
                    color: CColors.headerText,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "\$${_order.myOrder.deliveryCost}",
                  style: TextStyle(
                    color: CColors.headerText,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "promotion_code".trs(context),
                    style: TextStyle(
                      color: CColors.headerText,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "#A48C",
                    style: TextStyle(
                      color: CColors.headerText,
                      fontWeight: FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "Total" + "\t" * 2,
                  style: TextStyle(
                    color: CColors.headerText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: "\$",
                    style: TextStyle(
                      fontSize: 12,
                      color: CColors.darkOrange,
                    ),
                    children: [
                      TextSpan(
                        text: "${_order.myOrder.totalPrice}",
                        style: TextStyle(
                          fontSize: 15,
                          color: CColors.headerText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        widget.order.status == 3 || widget.order.status == 4
            ? FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                color: CColors.lightGreen,
                icon:
                    Icon(FontAwesomeIcons.redo, size: 13, color: CColors.white),
                label: Text(
                  "re_order".trs(context),
                  style: TextStyle(
                    color: CColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}

class _OrderStepper extends StatelessWidget {
  final int currentStep;
  final List<String> titles;

  const _OrderStepper({
    Key key,
    this.currentStep = 0,
    @required this.titles,
  })  : assert(titles != null),
        assert(currentStep >= 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int _step = currentStep;
    int _totalSteps = titles.length;
    final size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 35,
        maxWidth: size.width,
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              _totalSteps,
              (index) {
                final _isLast = index == (_totalSteps) - 1;
                final _isDotSelected = index <= _step;
                final _isLineSelected = index <= _step - 1;
                return _buildSection(
                  hideLine: _isLast,
                  isDotSelected: _isDotSelected,
                  isLineSelected: _isLineSelected,
                  steps: _totalSteps,
                  context: context,
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _totalSteps,
                    (index) {
                      final _isDotSelected = index <= _step;
                      return Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            titles[index],
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  _isDotSelected ? Colors.orange : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    bool hideLine = false,
    bool isDotSelected = false,
    bool isLineSelected = false,
    int steps = 0,
    BuildContext context,
  }) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
            radius: 4.5,
            backgroundColor: isDotSelected ? Colors.orange : CColors.fadeBlue),
        if (!hideLine)
          Container(
            width: (size.width * 0.9) / steps,
            height: 3,
            color: isLineSelected ? Colors.orange : CColors.fadeBlue,
          ),
      ],
    );
  }
}
