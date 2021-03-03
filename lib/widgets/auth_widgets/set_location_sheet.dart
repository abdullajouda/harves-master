import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/delivery/views/login.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'dart:ui' as ui;

import 'package:harvest/helpers/variables.dart';

class SetLocationSheet extends StatefulWidget {
  @override
  _SetLocationSheetState createState() => _SetLocationSheetState();
}

class _SetLocationSheetState extends State<SetLocationSheet> {
  GoogleMapController _controller;
  List<Marker> markers = [];
  CameraPosition _initialCameraPosition;
  BitmapDescriptor customIcon;
  bool _visible = false;
  bool _load = true;
  bool _expand = false;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  addMarker() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/Pin.png', 50);
    markers.add(
      Marker(
        position: LatLng(30, 30),
        markerId: MarkerId('0'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        onTap: () {},
        // icon: customIcon
      ),
    );
  }

  Future<Position> _determinePosition() async {
    final Uint8List markerIcon = await getBytesFromAsset('assets/Pin.png', 100);
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _controller.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude), 15));
      setState(() {
        markers = [];
        markers.add(Marker(
            icon: BitmapDescriptor.fromBytes(markerIcon),
            position: LatLng(position.latitude, position.longitude),
            markerId: MarkerId('0')));
        _load = false;
        _visible = true;
      });
    } else {
      Navigator.pop(context);
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    _determinePosition();
    _initialCameraPosition = CameraPosition(
      target: LatLng(31, 31),
      zoom: 14.4746,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(33.0),
          topRight: Radius.circular(33.0),
        ),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1a000000),
            offset: Offset(0, -5),
            blurRadius: 51,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Container(
              height: 400,
              width: size.width * .8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 342,
                      width: size.width * .8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x24000000),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            trafficEnabled: false,
                            compassEnabled: false,
                            scrollGesturesEnabled: false,
                            initialCameraPosition: _initialCameraPosition,
                            markers: markers.toSet(),
                            onMapCreated: (controller) {
                              setState(() {
                                _controller = controller;
                              });
                            },
                            onTap: (latLng) {
                              _controller.animateCamera(
                                  CameraUpdate.newLatLng(latLng));
                            },
                          ),
                          _load
                              ? Container(
                                  color: Colors.black26,
                                  child: SpinKitFadingCircle(
                                    color: kPrimaryColor,
                                    size: 25,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: AnimatedOpacity(
                        opacity: _visible ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 600),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: _expand ? 340 : 64,
                          width: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            color: const Color(0xffffffff),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x14000000),
                                offset: Offset(0, 4),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: _expand
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Container(
                                        height: 38,
                                        width: 220,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              width: 1.0,
                                              color: const Color(0xffe3e7eb)),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 38,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xffe3e7eb)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 38,
                                            width: 104,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xffe3e7eb)),
                                            ),
                                          ),
                                          Container(
                                            height: 38,
                                            width: 104,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xffe3e7eb)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 90,
                                      width: 220,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            width: 1.0,
                                            color: const Color(0xffe3e7eb)),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 25, right: 20),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _expand = false;
                                            });
                                          },
                                          child: Container(
                                            height: 31,
                                            width: 58,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: const Color(0xfff88518),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                  fontFamily: 'SF Pro Rounded',
                                                  fontSize: 12,
                                                  color: const Color(0xffffffff),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _expand = true;
                                        });
                                      },
                                      child: Container(
                                        height: 31,
                                        width: 167,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: const Color(0xffe4f0e6),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Add Extra Details ',
                                            style: TextStyle(
                                              fontFamily: 'SF Pro Rounded',
                                              fontSize: 11,
                                              color: const Color(0xff3c984f),
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 58,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: const Color(0xfff88518),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Done',
                                          style: TextStyle(
                                            fontFamily: 'SF Pro Rounded',
                                            fontSize: 12,
                                            color: const Color(0xffffffff),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.left,
                                        )),
                                      ),
                                    )
                                  ],
                                ),
                        )),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context, CustomPageRoute(builder: (context) => LoginDelivery(),)),
                child: Container(
                  height: 60,
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0x0ff3C984F),
                  ),
                  child: // Adobe XD layer: 'Continue' (text)
                      Center(
                    child: Text(
                      'Continue ',
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontSize: 16,
                        color: const Color(0xffffffff),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'If You Don\'t Have An Existed Account?',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 10,
                              color: const Color(0xff888a8d),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontFamily: 'SF Pro Rounded',
                                fontSize: 10,
                                color: const Color(0xff3c984f),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'SF Pro Rounded',
                            fontSize: 10,
                            color: const Color(0xfffdaa5c),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
