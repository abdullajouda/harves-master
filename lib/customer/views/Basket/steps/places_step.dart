import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/edit_address_dialog.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/add_new_address_dialog.dart';
import 'package:harvest/widgets/address_list_tile.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceStep extends StatefulWidget {
  @override
  _PlaceStepState createState() => _PlaceStepState();
}

class _PlaceStepState extends State<PlaceStep> {
  bool load = false;
  List<DeliveryAddresses> addresses = [];
  DeliveryAddresses _selected;
  BitmapDescriptor customIcon;
  List<Marker> markers = [];
  GoogleMapController _controller;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future getAddresses() async {
    setState(() {
      addresses = [];
      load = true;
    });
    var cart = Provider.of<Cart>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var request = await get(ApiHelper.api + 'allAddressForUser', headers: {
      'Accept': 'application/json',
      'Accept-Language': '${prefs.getString('language')}',
      'Authorization': 'Bearer ${prefs.getString('userToken')}'
    });
    var response = json.decode(request.body);
    List locations = response['items'];
    locations.forEach((element) {
      DeliveryAddresses deliveryAddress = DeliveryAddresses.fromJson(element);
      addresses.add(deliveryAddress);
      addMarker(deliveryAddress.lat, deliveryAddress.lan, () {
        setState(() {
          _selected = deliveryAddress;
        });
      });
    });
    setState(() {
      _selected = addresses[0];
      cart.setAddress(_selected);
      load = false;
    });
  }

  addMarker(double lat, double lng, onTap) async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/Pin.png', 100);
    setState(() {
      // markers = [];
      markers.add(
        Marker(
          position: LatLng(lat, lng),
          markerId: MarkerId('$lat'),
          icon: BitmapDescriptor.fromBytes(markerIcon), // icon: customIcon
          onTap: onTap,
        ),
      );
    });
  }

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 12,
  // );

  @override
  void initState() {
    getAddresses().then(
        (value) => WidgetsBinding.instance.addPostFrameCallback((_) async {
              // await Future.delayed(Duration(milliseconds: 100));
              if (mounted)
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => _AddressConfirmationDialog(
                    address: _selected,
                    onTapNewOne: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      backgroundColor: Colors.transparent,
                      builder: (_) => AddNewAddressDialog(
                      ),
                    ).then((value) => getAddresses()),
                  ),
                );
            }));
    // addMarker(_kGooglePlex.target.latitude, _kGooglePlex.target.longitude);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    final size = MediaQuery.of(context).size;
    return load
        ? LoadingPhone()
        : Column(
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
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
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
                                    onMapCreated: (controller) {
                                      setState(() {
                                        _controller = controller;
                                      });
                                    },
                                    myLocationButtonEnabled: false,
                                    myLocationEnabled: false,
                                    initialCameraPosition: CameraPosition(
                                      target:
                                          LatLng(_selected.lat, _selected.lan),
                                      zoom: 12,
                                    ),
                                    markers: markers.toSet(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.1),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: size.width * .6,
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
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 90,
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: addresses.length,
                                          itemBuilder: (context, index) {
                                            final bool _isSelected =
                                                _isAddressSelected(
                                                    addresses[index]);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() => _selected =
                                                      addresses[index]);
                                                  _controller.animateCamera(
                                                      CameraUpdate.newLatLng(
                                                          LatLng(_selected.lat,
                                                              _selected.lan)));
                                                  cart.setAddress(_selected);
                                                },
                                                child: AddressListTile(
                                                  onEdit: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      enableDrag: false,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      builder: (_) =>
                                                          EditAddressDialog(
                                                        path: 1,
                                                        deliveryAddresses:
                                                            _selected,
                                                      ),
                                                    ).then((value) =>
                                                        getAddresses());
                                                  },
                                                  color: _isSelected
                                                      ? CColors.darkOrange
                                                      : CColors.grey,
                                                  title:
                                                      "${addresses[index].city.name}, ${addresses[index].street != null ? addresses[index].street : ''}",
                                                  subTitle:
                                                      "${addresses[index].buildingNumber}, ${addresses[index].unitNumber}",
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        "or_add_new_adress".trs(context),
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
                                          enableDrag: false,
                                          backgroundColor: Colors.transparent,
                                          builder: (_) => AddNewAddressDialog(
                                          ),
                                        ).then((value) => getAddresses());
                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   isScrollControlled: true,
                                        //   // enableDrag: true,
                                        //   shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius.vertical(
                                        //         top: Radius.circular(25)),
                                        //   ),
                                        //   builder: (_) =>
                                        //       _OrderDetailsConfirmationPanel(),
                                        // );
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: CColors.fadeBlue,
                                      child: Text(
                                        "add_new_adress".trs(context),
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.07),
            ],
          );
  }

  bool _isAddressSelected(DeliveryAddresses index) => _selected == index;
}

class _AddressConfirmationDialog extends StatelessWidget {
  final VoidCallback onTapContinue;
  final VoidCallback onTapNewOne;
  final DeliveryAddresses address;

  const _AddressConfirmationDialog({
    Key key,
    this.onTapContinue,
    this.onTapNewOne,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: CColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "order_will_be_delivered_to".trs(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: CColors.headerText,
              ),
            ),
            SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxHeight: 150,
                maxWidth: size.width * 0.6,
              ),
              decoration: BoxDecoration(
                color: CColors.lightOrange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                leading:
                    SvgPicture.asset(Constants.mapPin, width: 40, height: 40),
                title: Text(
                  "${address.city.name}, ${address.street}",
                  style: TextStyle(
                    fontSize: 13,
                    color: CColors.headerText,
                  ),
                ),
                subtitle: Text(
                  "${address.buildingNumber}, ${address.unitNumber}",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "or_add_new_adress".trs(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CColors.grey,
                  fontSize: 11,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onTapNewOne != null) onTapNewOne();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: CColors.lightGreen, width: 2),
                  ),
                  color: CColors.transparent,
                  child: Text(
                    "new_one_address".trs(context),
                    style: TextStyle(
                      color: CColors.lightGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.grey[200],
                  child: Text(
                    "continue".trs(context),
                    style: TextStyle(
                      color: CColors.lightGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
