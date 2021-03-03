import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:harvest/customer/models/orders.dart';
import 'package:harvest/customer/widgets/Orders/order_details_panel.dart';
import 'package:harvest/customer/widgets/Orders/order_current_list_tile.dart';
import 'package:harvest/helpers/api.dart';
import 'package:http/http.dart';

class CurrentOrders extends StatefulWidget {
  @override
  _CurrentOrdersState createState() => _CurrentOrdersState();
}

class _CurrentOrdersState extends State<CurrentOrders> {
  bool loadOrders = true;
  List<Order> _orders = [];

  getOrders() async {
    var request = await get(ApiHelper.api + 'getProductsByCategoryId/1',
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
      builder: (context) => OrderDetailsPanel(order: order,),
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
        return OrderCurrentListTile(
          onTap: ()=>_showButtonPanel(_orders[index]),
          billNumber:_orders[index].id,
          billTotal: _orders[index].totalPrice,
          billDate: _orders[index].createdAt,
        );
      },
    );
  }
}
