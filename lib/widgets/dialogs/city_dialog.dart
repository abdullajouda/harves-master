import 'package:flutter/material.dart';
import 'package:harvest/customer/models/city.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:provider/provider.dart';
import 'package:harvest/helpers/Localization/localization.dart';
class CityDropDown extends StatefulWidget {
  @override
  _CityDropDownState createState() => _CityDropDownState();
}

class _CityDropDownState extends State<CityDropDown> {
  TextEditingController _search;
  List<City> _cities = [];

  search() {
    setState(() {
      _cities.clear();
    });
    var op = Provider.of<CityOperations>(context, listen: false);
    op.items.values.toList().forEach((element) {
      if (element.name.toLowerCase().contains(_search.text)) {
        _cities.add(element);
        setState(() {});
      }
    });
    // _cities.add(value);
  }

  @override
  void initState() {
    _search = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var op = Provider.of<CityOperations>(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 300,
        width: size.width * .75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                  controller: _search,
                  onChanged: (value) {
                    search();
                  },
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xff525768),
                  ),
                  cursorColor: CColors.darkOrange,
                  cursorWidth: 1,
                  decoration: locationFieldDecoration('city'.trs(context))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border:
                  Border.all(width: 1.0, color: const Color(0xffe3e7eb)),
                ),
                child: _search.text != ''
                    ? ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                  ),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _cities.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop({
                        'city': _cities[index],
                      });
                    },
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Text(
                              '${_cities[index].name}',
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(0xff525768),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop({
                                'city': _cities[index],
                              });
                            },
                            child: Text(
                              'pick'.trs(context),
                              style: TextStyle(
                                fontSize: 10,
                                color: CColors.darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    height: 0,
                  ),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: op.itemCount,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop({
                        'city': op.items.values.toList()[index],
                      });
                    },
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: Text(
                              '${op.items.values.toList()[index].name}',
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color(0xff525768),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop({
                                'city': op.items.values.toList()[index],
                              });
                            },
                            child: Text(
                              'pick'.trs(context),
                              style: TextStyle(
                                fontSize: 10,
                                color: CColors.darkGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}