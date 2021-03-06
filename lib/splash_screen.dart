import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:harvest/customer/components/slider_item.dart';
import 'package:harvest/customer/models/slider.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/custom_page_transition.dart';

import 'package:harvest/widgets/my-opacity.dart';
import 'package:http/http.dart';

import 'customer/views/auth/login.dart';
import 'customer/views/root_screen.dart';
import 'widgets/my_animation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final CarouselController _carouselController = CarouselController();
  List<SliderModel> _list = [];
  bool load = true;
  int _current = 0;

  getSplash() async {
    var request =
        await get(ApiHelper.api + 'getAds', headers: ApiHelper.headers);
    var response = json.decode(request.body);
    var items = response['items'];
    // Fluttertoast.showToast(msg: response['message']);
    items.forEach((element) {
      SliderModel slider = SliderModel.fromJson(element);
      _list.add(slider);
    });
    setState(() {
      load = false;
    });
  }

  // getCities() async {
  //   var op = Provider.of<CityOperations>(context, listen: false);
  //   var request =
  //       await get(ApiHelper.api + 'getCities', headers: ApiHelper.headers);
  //   var response = json.decode(request.body);
  //   var items = response['cities'];
  //   items.forEach((element) {
  //     City city = City.fromJson(element);
  //     op.addItem(city);
  //   });
  // }

  @override
  void initState() {
    getSplash();
    // getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // alignment: Alignment.center,
            children: [
              load
                  ? Center(
                      child: Container(
                          height: 180, width: 180, child: LoadingPhone()))
                  : Column(
                      children: [
                        MyOpacity(
                          load: load,
                          child: Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CarouselSlider.builder(
                                  itemCount: _list.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return SliderItem(
                                      slider: _list[index],
                                    );
                                  },
                                  options: CarouselOptions(
                                      viewportFraction: 1.0,
                                      enlargeCenterPage: false,
                                      autoPlayAnimationDuration:
                                          Duration(milliseconds: 800),
                                      // height: 400,
                                      enlargeStrategy:
                                          CenterPageEnlargeStrategy.height,
                                      enableInfiniteScroll:
                                          _list.length == 1 ? false : true,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                  carouselController: _carouselController,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                onPressed: null,
                                child: Text(
                                  '   ',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Rounded',
                                    fontSize: 17,
                                    color: const Color(0xfffdaa5c),
                                    letterSpacing: 0.4999999904632568,
                                    height: 1.588235294117647,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                height: 15,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _list.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: _current == index
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                height: 9,
                                                width: 18,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color:
                                                      const Color(0xff3c4959),
                                                ),
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Container(
                                                height: 8,
                                                width: 8,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color: const Color(
                                                        0x333c4959)),
                                              ),
                                            ),
                                    );
                                  },
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    CustomPageRoute(
                                      builder: (context) => RootScreen(),
                                    )),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Rounded',
                                    fontSize: 17,
                                    color: const Color(0xfffdaa5c),
                                    letterSpacing: 0.4999999904632568,
                                    height: 1.588235294117647,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          height: 300,
                          width: size.width,
                          child: Image.asset(
                            'assets/images/home/3.0x/splash_backGround.png',
                            fit: BoxFit.fill,
                          )),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 48,
                              width: 290,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: const Color(0xffffffff),
                              ),
                              child: Center(
                                child: Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontFamily: 'SF Pro Rounded',
                                    fontSize: 18,
                                    color: const Color(0xff313131),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(CustomPageRoute(
                                  builder: (context) {
                                    return Login();
                                  },
                                ));
                              },
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Rounded',
                                  fontSize: 18,
                                  color: const Color(0xffffffff),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
