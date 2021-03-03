import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:harvest/customer/components/WaveAppBar/appBar_body.dart';
import 'package:harvest/customer/widgets/profile_text_field.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/address_list_tile.dart';

import 'home_popUp_menu.dart';


class AddNewAddressDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
        backgroundColor: CColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(15),
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, size: 23),
              ),
            ),
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 10),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                NoBGTextField(
                  hint: "city".trs(context),
                  textStyle: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                NoBGTextField(
                  hint: "region_address".trs(context),
                  textStyle: TextStyle(fontSize: 13),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: NoBGTextField(
                        hint: "unit_no".trs(context),
                        textStyle: TextStyle(fontSize: 13),
                        textInputType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: NoBGTextField(
                        hint: "zone_no".trs(context),
                        textStyle: TextStyle(fontSize: 13),
                        textInputType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                NoBGTextField(
                  linesNum: 5,
                  hint: "additional_note".trs(context),
                  textStyle: TextStyle(fontSize: 13),
                  textInputType: TextInputType.multiline,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.15, vertical: 10),
                  child: FlatButton.icon(
                    minWidth: 50,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      Navigator.push(
                          context,
                          platformPageRoute(
                            context: context,
                            builder: (context) => MapAddressPickDialog(),
                          ));
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    icon: Icon(FontAwesomeIcons.mapMarkerAlt, size: 15, color: CColors.lightGreen),
                    label: Text(
                      "pick_from_map".trs(context),
                      style: TextStyle(
                        color: CColors.darkGreen,
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: FlatButton(
                    minWidth: 50,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {},
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
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
                ),
              ],
            ),
          ],
        ),
      );
  }
}

class MapAddressPickDialog extends StatefulWidget {
  @override
  _MapAddressPickDialogState createState() => _MapAddressPickDialogState();
}

class _MapAddressPickDialogState extends State<MapAddressPickDialog> {
  Set<Marker> _markers = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: WaveAppBarBody(
        hideActions: true,
        backgroundGradient: CColors.greenAppBarGradient(),
        leading: SvgPicture.asset(Constants.basketIcon),
        actions: [HomePopUpMenu()],
        scrollPhysics: NeverScrollableScrollPhysics(),
        contentPadding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: size.height * 0.7,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                  myLocationButtonEnabled: false,
                                  myLocationEnabled: false,
                                  initialCameraPosition: _kGooglePlex,
                                  markers: _markers,
                                  onTap: (position) {
                                    _markers.clear();
                                    setState(() {
                                      _markers.add(Marker(
                                        markerId: MarkerId(position.toString()),
                                        position: position,
                                      ));
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.06),
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
                          Container(
                            decoration: BoxDecoration(
                              color: CColors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(10),
                                  offset: Offset(0, 7.0),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                            child: AddressListTile(
                              title: "AlQahera, Jamal 43st",
                              subTitle: "CD 43, 4 floor",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
              child: FlatButton(
                minWidth: 50,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                color: CColors.fadeBlue,
                child: Text(
                  "add_new_adress".trs(context),
                  style: TextStyle(
                    color: CColors.darkGreen,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
