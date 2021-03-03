import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/customer/widgets/Orders/order_details_panel.dart';
import 'package:harvest/customer/widgets/Orders/order_list_tile.dart';
import 'dart:convert';

import 'package:harvest/customer/models/orders.dart';

import 'package:harvest/helpers/api.dart';
import 'package:http/http.dart';

class OldOrders extends StatefulWidget {
  @override
  _OldOrdersState createState() => _OldOrdersState();
}

class _OldOrdersState extends State<OldOrders> {
  bool loadOrders = true;
  List<Order> _orders = [];

  getOrders() async {
    var request = await get(ApiHelper.api + 'getProductsByCategoryId/2',
        headers: ApiHelper.headers);
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      Order orders = Order.fromJson(element);
      _orders.add(orders);
    });
    setState(() {
      loadOrders = false;
    });
  }

   _showButtonPanel(Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => OrderDetailsPanel(),
    );
  }

  @override
  void initState() {
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _orders.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => SizedBox(height: 20),
      itemBuilder: (context, index) {
        return OrderListTile(
          onTap: ()=>_showButtonPanel(_orders[index]),
          billNumber:_orders[index].id,
          billTotal: _orders[index].totalPrice,
          billDate: _orders[index].createdAt,
        );
      },
    );
  }
}
