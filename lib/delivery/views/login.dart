import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/language_picker.dart';
import 'main_screen.dart';

class LoginDelivery extends StatefulWidget {
  @override
  _LoginDeliveryState createState() => _LoginDeliveryState();
}

class _LoginDeliveryState extends State<LoginDelivery> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0x0ffE6F2EA),
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset('assets/Dots.svg'),
            Positioned(
              top: 100,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'SF Pro Rounded',
                        fontSize: 22,
                        color: const Color(0xff3c4959),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 230.0,
                        height: 230.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.elliptical(9999.0, 9999.0)),
                          border: Border.all(
                              width: 15.0, color: const Color(0xfffec896)),
                        ),
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        child: SvgPicture.string(
                          '<svg viewBox="0.0 0.0 165.2 165.2" ><defs><filter id="shadow"><feDropShadow dx="0" dy="36" stdDeviation="24"/></filter></defs><path transform="translate(0.0, 0.0)" d="M 82.6219482421875 0 C 128.2527923583984 0 165.243896484375 36.99110794067383 165.243896484375 82.6219482421875 C 165.243896484375 128.2527923583984 128.2527923583984 165.243896484375 82.6219482421875 165.243896484375 C 36.99110794067383 165.243896484375 0 128.2527923583984 0 82.6219482421875 C 0 36.99110794067383 36.99110794067383 0 82.6219482421875 0 Z" fill="#f7fcf9" stroke="#ffffff" stroke-width="7.700000286102295" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SvgPicture.asset('assets/images/delivery_truck.svg'),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: LanguagePicker(),
                      )),
                  Container(
                    height: 300,
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 60,
                              width: 260,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: const Color(0xcce6f2ea),
                              ),
                              child: Center(
                                child: TextFormField(
                                  decoration: inputDecorationWithIcon(
                                      'User Name',
                                      Container(
                                          height: 20,
                                          width: 20,
                                          child: Center(
                                            child: SvgPicture.asset(
                                                'assets/icons/profile.svg'),
                                          ))),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Container(
                                height: 60,
                                width: 260,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: const Color(0xcce6f2ea),
                                ),
                                child: Center(
                                  child: TextFormField(
                                    decoration: inputDecorationWithIcon(
                                        'Password',
                                        Container(
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                  'assets/icons/lock.svg'),
                                            ))),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    CustomPageRoute(
                                      builder: (context) => MainScreen(),
                                    )),
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
