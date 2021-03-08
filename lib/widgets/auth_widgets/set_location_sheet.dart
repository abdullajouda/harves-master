import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/terms.dart';
import 'package:harvest/customer/views/root_screen.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'dart:ui' as ui;

import 'package:harvest/helpers/variables.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';

class SetLocationSheet extends StatefulWidget {
  final String name;
  final String mobile;

  const SetLocationSheet({Key key, this.name, this.mobile}) : super(key: key);

  @override
  _SetLocationSheetState createState() => _SetLocationSheetState();
}

class _SetLocationSheetState extends State<SetLocationSheet> {
  City city;
  GoogleMapController _controller;
  List<Marker> markers = [];
  CameraPosition _initialCameraPosition;
  BitmapDescriptor customIcon;
  bool _visible = false;
  bool _load = true;
  bool _expand = false;
  Coordinates coordinates;

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
        coordinates = new Coordinates(position.latitude, position.longitude);
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

  save() async {
    try {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      if (addresses.first.addressLine != null) {
        if(city != null){
          Navigator.of(context).pop({
            'addressLine': addresses.first.addressLine,
            'latitude': markers[0].position.latitude,
            'longitude': markers[0].position.longitude,
            'city': city
          });
        }else{
          Fluttertoast.showToast(msg: 'Select your city from extra details');
        }

      } else {
        if(city != null){
          Navigator.of(context).pop({
            'latitude': markers[0].position.latitude,
            'longitude': markers[0].position.longitude,
            'city': city
          });
        }else{
          Fluttertoast.showToast(msg: 'Select your city from extra details');
        }

      }
    } on Exception catch (e) {
      if(city != null){
        Navigator.of(context).pop({
          'latitude': markers[0].position.latitude,
          'longitude': markers[0].position.longitude,
          'city': city
        });
      }else{
        Fluttertoast.showToast(msg: 'Select your city from extra details');
      }

    }
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
    var op = Provider.of<CityOperations>(context);
    return Container(
      // width: size.width,
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
        mainAxisAlignment: MainAxisAlignment.start,
        // alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Container(
              height: size.height*.6,
              width: size.width * .8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: size.height*.57,
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
                            // scrollGesturesEnabled: false,
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
                          height: _expand ? 400 : 64,
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
                                          vertical: 15, horizontal: 20),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      const Color(0xffe3e7eb)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    city != null
                                                        ? city.name
                                                        : 'City',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SF Pro Rounded',
                                                      fontSize: 8,
                                                      color: const Color(
                                                          0xff525768),
                                                    ),
                                                  ),
                                                  SvgPicture.asset(
                                                      'assets/icons/arrow-down.svg')
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: 50,
                                            width: size.width * .75,
                                            child: DropdownButton<City>(
                                              icon: Container(),
                                              underline: Container(),
                                              items: op.items.values
                                                  .toList()
                                                  .map((City value) {
                                                return DropdownMenuItem<City>(
                                                  value: value,
                                                  child: Text(
                                                    value.name,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'SF Pro Rounded',
                                                      fontSize: 8,
                                                      color: const Color(
                                                          0xff525768),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  city = value;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        child: TextFormField(
                                            cursorColor: CColors.darkOrange,
                                            cursorWidth: 1,
                                            decoration: locationFieldDecoration(
                                                'Full address')),
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
                                            width: size.width * .25,
                                            child: Center(
                                              child: TextFormField(
                                                  cursorColor:
                                                      CColors.darkOrange,
                                                  cursorWidth: 1,
                                                  decoration:
                                                      locationFieldDecoration(
                                                          'Unit No.')),
                                            ),
                                          ),
                                          Container(
                                            width: size.width * .25,
                                            child: Center(
                                              child: TextFormField(
                                                  cursorColor:
                                                      CColors.darkOrange,
                                                  cursorWidth: 1,
                                                  decoration:
                                                      locationFieldDecoration(
                                                          'Building No.')),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Container(
                                        child: Stack(
                                          children: [
                                            TextFormField(
                                                maxLines: 5,
                                                cursorColor: CColors.darkOrange,
                                                cursorWidth: 1,
                                                decoration:
                                                    locationFieldDecoration(
                                                        'Additional Notes')),
                                            Positioned(
                                                bottom: 5,
                                                right: 5,
                                                child: SvgPicture.asset(
                                                    'assets/icons/additional_icon.svg'))
                                          ],
                                        ),
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
                                                  color:
                                                      const Color(0xffffffff),
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
                                        save();
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
                // onTap: () => Navigator.push(
                //     context,
                //     CustomPageRoute(
                //       builder: (context) => LoginDelivery(),
                //     )),
                child: Container(
                  height: 60,
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0x0ff3C984F),
                  ),
                  child: Center(
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
                padding: const EdgeInsets.only(top: 28, bottom: 50),
                child: Container(
                  width: size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'By Continuing you agree to our',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 10,
                              color: const Color(0xff888a8d),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                    builder: (context) => Terms(
                                      path: 'this',
                                    ),
                                  ));
                            },
                            child: Text(
                              'Terms Of Use',
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
                        onPressed: () {
                          Navigator.push(
                              context,
                              CustomPageRoute(
                                builder: (context) => RootScreen(),
                              ));
                        },
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
