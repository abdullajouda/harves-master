import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/customer/views/auth/login2.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/custom_page_transition.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/button_loader.dart';
import 'package:harvest/widgets/countdown.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../root_screen.dart';

class AccountActivation extends StatefulWidget {
  final String mobile;

  const AccountActivation({Key key, this.mobile}) : super(key: key);

  @override
  _AccountActivationState createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AnimationController _controller;
  Timer _timer;
  int _start = 120;
  bool load = false;
  String code;

  void startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  sendCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      load = true;
    });
    if (_formKey.currentState.validate()) {
      var request = await post(ApiHelper.api + 'verifyCode',
          body: {
            'code': code,
            'mobile': widget.mobile,
            'device_type': 'android',
            'fcm_token': '78654132687'
          },
          headers: ApiHelper.headers);
      var response = json.decode(request.body);
      Fluttertoast.showToast(msg: response['message']);
      if (response['status'] == true) {
        if (response['user'] != null) {
          prefs.setString('userToken', response['user']['access_token']);
          Navigator.push(
              context,
              CustomPageRoute(
                builder: (context) => RootScreen(),
              ));
        }

        // Navigator.push(
        //     context,
        //     CustomPageRoute(
        //       builder: (context) => Login2(),
        //     ));
      }else if (response['code'] == 203) {
        Navigator.pushReplacement(
            context,
            CustomPageRoute(
              builder: (context) => Login2(
                mobile: widget.mobile,
              ),
            ));

      } else {
        setState(() {
          load = false;
        });
      }
    }

    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    startTimer();
    _controller =
        AnimationController(vsync: this, duration: Duration(minutes: 2));
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0x0ffE6F2EA),
      body: Container(
        height: size.height,
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
                      'Account Activation',
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
                              width: 15.0, color: const Color(0xffAAE1AC)),
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
                      Container(
                          height: 150,
                          child: Center(
                              child: SvgPicture.asset(
                                  'assets/images/strawberry.svg'))),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                            height: 33,
                            width: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11.0),
                              color: const Color(0xffebf4ee),
                            ),
                            child: Center(
                              child: Countdown(
                                animation: StepTween(
                                  begin: 2 * 60,
                                  end: 0,
                                ).animate(_controller),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Form(
                            key: _formKey,
                            child: Container(
                              width: 260,
                              child: Center(
                                child: TextFormField(
                                    onChanged: (newValue) {
                                      setState(() {
                                        code = newValue;
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "* Required";
                                      } else
                                        return null;
                                    },
                                    decoration:
                                        inputDecoration(' Activation Code')),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => sendCode(),
                          child: Container(
                            height: 60,
                            width: 260,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0x0ff3C984F),
                            ),
                            child: Center(
                              child: load
                                  ? LoadingBtn()
                                  : Text(
                                      'Activate ',
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
                          padding: const EdgeInsets.only(top: 10, bottom: 15),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Return ',
                              style: TextStyle(
                                fontFamily: 'SF Pro Rounded',
                                fontSize: 12,
                                color: const Color(0xfffdaa5c),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
