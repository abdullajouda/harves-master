import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/cart_items.dart';

// import 'package:harvest/customer/views/Basket/pages_controlles.dart';
import 'package:harvest/widgets/address_list_tile.dart';
import 'package:intl/intl.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:provider/provider.dart';

@immutable
class _DeliveryTimeModel {
  final String day;
  final String dayNum;
  final String month;
  final String minTime;
  final String maxTime;

  const _DeliveryTimeModel({
    this.day,
    this.dayNum,
    this.month,
    this.minTime,
    this.maxTime,
  });

  factory _DeliveryTimeModel.fromTime(DateTime time) {
    final String _fromTime = DateFormat("h:mm a").format(time);
    final String _day = DateFormat("EEE").format(time);
    final String _dayNum = DateFormat("d").format(time);
    final String _month = DateFormat("MMMM").format(time);
    return _DeliveryTimeModel(
      day: _day,
      dayNum: _dayNum,
      maxTime: _fromTime,
      minTime: _fromTime,
      month: _month,
    );
  }
}

class DeliveryTimeStep extends StatefulWidget {
  @override
  _DeliveryTimeStepState createState() => _DeliveryTimeStepState();
}

class _DeliveryTimeStepState extends State<DeliveryTimeStep> {
  _DeliveryTimeModel _deliveryTime;
  DateTime _currentDateTime;

  @override
  void initState() {
    // var cart = Provider.of<Cart>(context,listen: false);
    _currentDateTime = DateTime.now();
    _deliveryTime = _DeliveryTimeModel.fromTime(_currentDateTime);
    super.initState();
  }

  Set<Marker> _markers = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "delivery_place".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: SizedBox(
            height: size.height * 0.2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: CColors.white,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(10),
                                offset: Offset(0, 5.0),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: GoogleMap(
                              myLocationButtonEnabled: false,
                              myLocationEnabled: false,
                              initialCameraPosition:_kGooglePlex,
                              markers: _markers,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.06),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: size.width*.6,
                      decoration: BoxDecoration(
                        color: CColors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(10),
                            offset: Offset(0, 7.0),
                            spreadRadius: 1,
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(10),
                      child: AddressListTile(
                        title: "AlQahera, Jamal 43st",
                        subTitle: "CD 43, 4 floor",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            "delivery_date_time".trs(context),
            style: TextStyle(
              color: CColors.headerText,
              fontSize: 15,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: CColors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(7),
                      offset: Offset(0, 5.0),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50,
                        width: 5,
                        color: CColors.lightGreen,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Column(
                              children: [
                                Text(
                                  _deliveryTime.month,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: CColors.lightGreen,
                                  ),
                                ),
                                Text(
                                  _deliveryTime.dayNum,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: CColors.lightGreen,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_deliveryTime.day}, ${_deliveryTime.minTime} to ${_deliveryTime.minTime}",
                                  style: TextStyle(
                                    color: CColors.headerText,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "at_this_time".trs(context),
                                  style: TextStyle(
                                    color: CColors.normalText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "pickup_new_suitable_date".trs(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: CColors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: CColors.transparent,
                    enableDrag: true,
                    builder: (context) => Container(
                      width: size.width,
                      decoration: BoxDecoration(
                          color: CColors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Card(
                              elevation: 0.0,
                              color: Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(99)),
                              child:
                                  SizedBox(width: size.width * 0.35, height: 6),
                            ),
                          ),
                          Text(
                            'Select an available Date/Time',
                            style: TextStyle(
                              fontSize: 18,
                              color: const Color(0xff3c4959),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: CColors.lightGreen,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                "done".trs(context),
                                style: TextStyle(
                                  color: CColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  // DatePicker.showDateTimePicker(
                  //   context,
                  //   onConfirm: (time) {
                  //     setState(() {
                  //       _deliveryTime = _DeliveryTimeModel.fromTime(time);
                  //     });
                  //   },
                  //   onChanged: (time) {
                  //     final String _time = DateFormat("h:mm a").format(time);
                  //     // ignore: unused_local_variable
                  //     final String _date = DateFormat("d").format(time);
                  //     // ignore: unused_local_variable
                  //     final String _month = DateFormat("MMMM").format(time);
                  //     // ignore: unused_local_variable
                  //     final _timeFormated2 = DateFormat("EE, MMMM d, h:mm aaa").format(time);
                  //     print(_time);
                  //     setState(() {
                  //       _deliveryTime = _DeliveryTimeModel.fromTime(time);
                  //     });
                  //   },
                  //   currentTime: DateTime.now(),
                  //   maxTime: DateTime.now().add(Duration(days: 30)),
                  //   minTime: DateTime.now().subtract(Duration(days: 30)),
                  //   locale: LocaleType.ar,
                  // );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                color: CColors.fadeBlue,
                child: Text(
                  "change_date_time".trs(context),
                  style: TextStyle(
                    color: CColors.darkGreen,
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        // BasketPagesControlles(),
      ],
    );
  }
}
