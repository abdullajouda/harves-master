import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/delivery/views/login.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/widgets/auth_widgets/set_location_sheet.dart';

class LocationSheet extends StatefulWidget {
  @override
  _LocationSheetState createState() => _LocationSheetState();
}

class _LocationSheetState extends State<LocationSheet> {
  openMap() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SetLocationSheet(),
    );
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
              // height: 160,
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      height: 68,
                      width: 218,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: const Color(0xfffff7ef),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SvgPicture.asset('assets/images/Pin.svg'),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'AlQahera, Jamal 43st',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro Rounded',
                                          fontSize: 13,
                                          color: const Color(0xff3c4959),
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      Text(
                                        'CD 43, 4 floor',
                                        style: TextStyle(
                                          fontFamily: 'SF Pro Rounded',
                                          fontSize: 10,
                                          color: const Color(0xff888a8d),
                                          fontWeight: FontWeight.w300,
                                        ),
                                        textAlign: TextAlign.left,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => openMap(),
                              child: Container(
                                height: 18,
                                width: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(9999.0, 9999.0)),
                                  color: const Color(0xfff88518),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color(0xffffffff)),
                                ),
                                child: Center(
                                  child:
                                      SvgPicture.asset('assets/icons/edit.svg'),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      'Add new specific address\ndetails for your home',
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontSize: 12,
                        color: const Color(0xff888a8d),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: GestureDetector(
                      onTap: () =>openMap(),
                      child: Container(
                        height: 31,
                        width: 147,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: const Color(0xffe4f0e6),
                        ),
                        child: Center(
                          child: Text(
                            'Add New Address',
                            style: TextStyle(
                              fontFamily: 'SF Pro Rounded',
                              fontSize: 12,
                              color: const Color(0xff3c984f),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ),
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
