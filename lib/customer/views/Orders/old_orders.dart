import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/customer/widgets/Orders/order_details_panel.dart';
import 'package:harvest/customer/widgets/Orders/order_list_tile.dart';
import 'dart:convert';

import 'package:harvest/customer/models/orders.dart';

import 'package:harvest/helpers/api.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/dialogs/signup_first.dart';
import 'package:harvest/widgets/no_data.dart';
import 'package:harvest/widgets/not_authenticated.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OldOrders extends StatefulWidget {
  @override
  _OldOrdersState createState() => _OldOrdersState();
}

class _OldOrdersState extends State<OldOrders> {
  bool loadOrders = true;
  List<Order> _orders = [];

  getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        loadOrders = true;
      });
      var request =
          await get(ApiHelper.api + 'getMyOrdersByStatus/2', headers: {
        'Accept': 'application/json',
        'Accept-Language': 'en',
        'Authorization': 'Bearer ${prefs.getString('userToken')}'
      });
      var response = json.decode(request.body);
      List values = response['items'];
      values.forEach((element) {
        Order orders = Order.fromJson(element);
        _orders.add(orders);
      });
      setState(() {
        loadOrders = false;
      });
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => SignUpFirst(),
      );
    }
  }

  _showButtonPanel(Order order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => OrderDetailsPanel(
        order: order,
      ),
    );
  }

  bool isAuthenticated = false;

  isAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userToken') != null) {
      setState(() {
        isAuthenticated = true;
      });
    }
  }

  @override
  void initState() {
    isAuth();
    getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loadOrders
        ? Container(height: 200, child: Center(child: Loader()))
        :  !isAuthenticated
        ? NotAuthPage()
        : _orders.length == 0
            ? NoData()
            : ListView.separated(
                itemCount: _orders.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 20, bottom: 30),
                separatorBuilder: (context, index) => SizedBox(height: 20),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: OrderListTile(
                      onTap: () => _showButtonPanel(_orders[index]),
                      billNumber: _orders[index].id,
                      billTotal: _orders[index].totalPrice,
                      billDate: _orders[index].createdAt,
                    ),
                  );
                },
              );
  }
}
