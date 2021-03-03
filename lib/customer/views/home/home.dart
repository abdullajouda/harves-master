import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:harvest/customer/models/category.dart';
import 'package:harvest/customer/models/fruit.dart';
import 'package:harvest/customer/models/offers_slider.dart';
import 'package:harvest/customer/models/products.dart';
import 'package:harvest/customer/views/Basket/basket.dart';
import 'package:harvest/customer/views/home/special_products_details.dart';
import 'package:harvest/customer/views/product_details.dart';
import 'package:harvest/customer/widgets/Fruit_item.dart';
import 'package:harvest/customer/widgets/slider_item.dart';
import 'package:harvest/customer/widgets/special_item.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/customer/components/WaveAppBar/wave_appbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:harvest/widgets/Loader.dart';
import 'package:harvest/widgets/category_selector.dart';
import 'package:harvest/widgets/favorite_button.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:harvest/widgets/my-opacity.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _current = 0;
  Category _selectedCategory;
  final CarouselController _carouselController = CarouselController();
  List _list = [];
  List<Offers> _offers = [];
  List<Category> _categories = [];
  List<Products> _products = [];
  List<Products> _featuredProducts = [];
  bool loadOffers = true;
  bool loadProducts = true;
  bool loadFeatured = true;
  bool loadCategories = true;

  getOffers() async {
    var request =
        await get(ApiHelper.api + 'getSliders', headers: ApiHelper.headers);
    var response = json.decode(request.body);
    var items = response['items'];
    // Fluttertoast.showToast(msg: response['message']);
    items.forEach((element) {
      Offers slider = Offers.fromJson(element);
      _offers.add(slider);
    });
    setState(() {
      loadOffers = false;
    });
  }

  getProductsByCategories(Category category) async {
    var request = await get(ApiHelper.api + 'getProductsByCategoryId/${category.id}',
        headers: ApiHelper.headers);
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      Products products = Products.fromJson(element);
      _products.add(products);
    });
    setState(() {
      loadProducts = false;
    });
  }

  getFeaturedProducts() async {
    var request = await get(ApiHelper.api + 'getFeaturedProducts',
        headers: ApiHelper.headers);
    var response = json.decode(request.body);
    List values = response['items'];
    values.forEach((element) {
      Products products = Products.fromJson(element);
      _featuredProducts.add(products);
    });
    setState(() {
      loadFeatured = false;
    });
  }

  @override
  void initState() {
    getOffers();
    ApiHelper().getCategories().then((value) {
      setState(() {
        _categories = value;
        loadCategories = false;
        _selectedCategory = _categories[0];
      });
      // ApiHelper helper = Provider.of<ApiHelper>(context);
    });
    getProductsByCategories(Category(id: 1));
    getFeaturedProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ApiHelper helper = Provider.of<ApiHelper>(context);
    return Scaffold(
      body: WaveAppBarBody(
        backgroundGradient: CColors.greenAppBarGradient(),
        bottomViewOffset: Offset(0, -10),
        bottomView: Container(
          width: 298.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                color: const Color(0x18000000),
                offset: Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          child: TextFormField(
            decoration: searchDecoration(
              'Search products',
              Container(
                height: 14,
                width: 14,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [HomePopUpMenu()],
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => Basket(),
                ),
              );
            },
            child: SvgPicture.asset(Constants.basketIcon)),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Offers',
              style: TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 18,
                color: const Color(0xff3c4959),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    MyOpacity(
                      load: loadOffers,
                      child: CarouselSlider.builder(
                        itemCount: _offers.length,
                        itemBuilder: (context, index, realIndex) {
                          return HomeSlider(
                            offers: _offers[index],
                          );
                        },
                        options: CarouselOptions(
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            height: 132,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            enableInfiniteScroll:
                                _list.length == 1 ? false : true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            }),
                        carouselController: _carouselController,
                      ),
                    ),
                    loadOffers
                        ? Loader()
                        : Container()
                  ],
                ),
                Positioned(
                  bottom: 15,
                  right: 15,
                  child: Container(
                    height: 20,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _offers.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: _current == index
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(9999.0, 9999.0)),
                                      color: CColors.darkOrange,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(9999.0, 9999.0)),
                                      color: CColors.white,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Special For You',
              style: TextStyle(
                fontFamily: 'SF Pro Rounded',
                fontSize: 18,
                color: const Color(0xff3c4959),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            height: 170,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: _featuredProducts.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductBundleDetails(
                          fruit: _featuredProducts[index],
                        ),
                      )),
                  child: SpecialItem(
                fruit: _featuredProducts[index],
              )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: MyOpacity(
              load: loadCategories,
              child: Container(
                  height: 30,
                  child: CategorySelector(
                    categories: _categories,
                  )),
            ),
          ),
          MyOpacity(
            load: loadProducts,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1,
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18),
              itemCount: _products.length,
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      products: _products[index],
                    ),
                  ),
                ),
                child: FruitItem(
                  product: _products[index],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          )
        ],
      ),
    );
  }
}
