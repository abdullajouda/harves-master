import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/cart_items.dart';
import 'package:harvest/customer/models/delivery-data.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/widgets/my_animation.dart';
import 'package:harvest/widgets/sheets/order_description.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaceStep extends StatefulWidget {
  final VoidCallback onContinue;

  const PlaceStep({Key key, this.onContinue}) : super(key: key);
  @override
  _PlaceStepState createState() => _PlaceStepState();
}

class _PlaceStepState extends State<PlaceStep> {
  bool load = false;

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
    showModalBottomSheet(
        context: context,
        backgroundColor: CColors.transparent,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => OrderDescription(
          onTap: () {
            widget.onContinue.call();
          },
        ),
        isScrollControlled: true);
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
                                          LatLng(cart.deliveryAddresses.lat, cart.deliveryAddresses.lan),
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
                      // Positioned(
                      //   left: 0,
                      //   right: 0,
                      //   bottom: 0,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Center(
                      //         child: Container(
                      //           width: size.width * .6,
                      //           decoration: BoxDecoration(
                      //             color: CColors.white,
                      //             borderRadius: BorderRadius.circular(13),
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.black.withAlpha(10),
                      //                 offset: Offset(0, 5.0),
                      //                 spreadRadius: 1,
                      //                 blurRadius: 10,
                      //               ),
                      //             ],
                      //           ),
                      //           padding: EdgeInsets.all(10),
                      //           child: Column(
                      //             children: [
                      //               Container(
                      //                 height: 90,
                      //                 child: ListView.builder(
                      //                     shrinkWrap: true,
                      //                     itemCount: addresses.length,
                      //                     itemBuilder: (context, index) {
                      //                       final bool _isSelected =
                      //                           _isAddressSelected(
                      //                               addresses[index]);
                      //                       return Padding(
                      //                         padding:
                      //                             const EdgeInsets.all(8.0),
                      //                         child: GestureDetector(
                      //                           onTap: () {
                      //                             setState(() => _selected =
                      //                                 addresses[index]);
                      //                             _controller.animateCamera(
                      //                                 CameraUpdate.newLatLng(
                      //                                     LatLng(_selected.lat,
                      //                                         _selected.lan)));
                      //                             cart.setAddress(_selected);
                      //                           },
                      //                           child: AddressListTile(
                      //                             onEdit: () {
                      //                               showModalBottomSheet(
                      //                                 context: context,
                      //                                 isScrollControlled: true,
                      //                                 enableDrag: false,
                      //                                 backgroundColor:
                      //                                     Colors.transparent,
                      //                                 builder: (_) =>
                      //                                     EditAddressDialog(
                      //                                   path: 1,
                      //                                   deliveryAddresses:
                      //                                       _selected,
                      //                                 ),
                      //                               ).then((value) =>
                      //                                   getAddresses());
                      //                             },
                      //                             color: _isSelected
                      //                                 ? CColors.darkOrange
                      //                                 : CColors.grey,
                      //                             title:
                      //                                 "${addresses[index].city.name}, ${addresses[index].street != null ? addresses[index].street : ''}",
                      //                             subTitle:
                      //                                 "${addresses[index].buildingNumber}, ${addresses[index].unitNumber}",
                      //                           ),
                      //                         ),
                      //                       );
                      //                     }),
                      //               ),
                      //               // Padding(
                      //               //   padding: const EdgeInsets.symmetric(
                      //               //       vertical: 5),
                      //               //   child: Text(
                      //               //     "or_add_new_adress".trs(context),
                      //               //     textAlign: TextAlign.center,
                      //               //     style: TextStyle(
                      //               //       color: CColors.grey,
                      //               //       fontSize: 11,
                      //               //     ),
                      //               //   ),
                      //               // ),
                      //               // FlatButton(
                      //               //   onPressed: () {
                      //               //     showModalBottomSheet(
                      //               //       context: context,
                      //               //       isScrollControlled: true,
                      //               //       enableDrag: false,
                      //               //       backgroundColor: Colors.transparent,
                      //               //       builder: (_) => AddNewAddressDialog(
                      //               //       ),
                      //               //     ).then((value) => getAddresses());
                      //               //     // showModalBottomSheet(
                      //               //     //   context: context,
                      //               //     //   isScrollControlled: true,
                      //               //     //   // enableDrag: true,
                      //               //     //   shape: RoundedRectangleBorder(
                      //               //     //     borderRadius: BorderRadius.vertical(
                      //               //     //         top: Radius.circular(25)),
                      //               //     //   ),
                      //               //     //   builder: (_) =>
                      //               //     //       _OrderDetailsConfirmationPanel(),
                      //               //     // );
                      //               //   },
                      //               //   shape: RoundedRectangleBorder(
                      //               //       borderRadius:
                      //               //           BorderRadius.circular(5)),
                      //               //   color: CColors.fadeBlue,
                      //               //   child: Text(
                      //               //     "add_new_adress".trs(context),
                      //               //     style: TextStyle(
                      //               //       color: CColors.darkGreen,
                      //               //       fontWeight: FontWeight.w400,
                      //               //       fontSize: 10,
                      //               //     ),
                      //               //   ),
                      //               // ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.07),
            ],
          );
  }

}

