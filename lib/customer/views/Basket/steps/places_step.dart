import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'package:harvest/widgets/address_list_tile.dart';

class PlaceStep extends StatefulWidget {
  final VoidCallback onTapContinue;

  const PlaceStep({
    Key key,
    this.onTapContinue,
  }) : super(key: key);

  @override
  _PlaceStepState createState() => _PlaceStepState();
}

class _PlaceStepState extends State<PlaceStep> {
  Marker _mapPin;

  //TODO: [fix] map icon isn't showing right
  Future<BitmapDescriptor> _bitmapDescriptorFromSvgAsset(
      BuildContext context, String assetName) async {
    String svgString =
        await DefaultAssetBundle.of(context).loadString(assetName);
    //Draws string representation of svg to DrawableRoot
    DrawableRoot svgDrawableRoot = await svg.fromSvgString(svgString, null);
    ui.Picture picture = svgDrawableRoot.toPicture();
    ui.Image image = await picture.toImage(200, 200);
    ByteData bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  Set<Marker> _markers = {};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 12,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mapPin == null)
      _bitmapDescriptorFromSvgAsset(context, Constants.mapPin).then((value) {
        _mapPin = Marker(
          markerId: MarkerId("initial"),
          position: LatLng(37.42796133580664, -122.085749655962),
          icon: value,
        );
        setState(() => _markers.add(_mapPin));
      });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 2000));
      if (mounted)
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _AddressConfirmationDialog(
            onTapContinue: () {
              return showModalBottomSheet(
                context: context,
                isDismissible: false,
                enableDrag: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: _OrderDetailsConfirmationPanel(
                      onTapContinue: () {
                        if (widget.onTapContinue != null)
                          widget.onTapContinue();
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
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
          child: IgnorePointer(
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
                                myLocationButtonEnabled: false,
                                myLocationEnabled: false,
                                initialCameraPosition: _kGooglePlex,
                                markers: _markers,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.1),
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
                                offset: Offset(0, 5.0),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              AddressListTile(
                                title: "AlQahera, Jamal 43st",
                                subTitle: "CD 43, 4 floor",
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  "or_add_new_adress".trs(context),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: CColors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (_) => AddNewAddressDialog(),
                                  // );
                                  return showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    enableDrag: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25)),
                                    ),
                                    builder: (_) =>
                                        _OrderDetailsConfirmationPanel(),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.07),
      ],
    );
  }
}

class _OrderDetailsConfirmationPanel extends StatefulWidget {
  final VoidCallback onTapContinue;

  const _OrderDetailsConfirmationPanel({
    Key key,
    this.onTapContinue,
  }) : super(key: key);

  @override
  _DateTimePickerSheetState createState() => _DateTimePickerSheetState();
}

class _DateTimePickerSheetState extends State<_OrderDetailsConfirmationPanel> {
  String _voucher;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final List<Widget> _options = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "bill_total".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
          Text(
            "\$35.00",
            style: TextStyle(
              fontSize: 14,
              color: CColors.headerText,
            ),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "delivery_charge".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
          Text(
            "\$1.99",
            style: TextStyle(
              fontSize: 12,
              color: CColors.headerText,
            ),
          ),
        ],
      ),
      _buildVoucherField(context, size),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "total".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "\$36.99",
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
        ],
      ),
    ];
    return Container(
      width: size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Card(
              elevation: 0.0,
              color: Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(99)),
              child: SizedBox(width: size.width * 0.35, height: 6),
            ),
          ),
          Text(
            "order_description".trs(context),
            style: TextStyle(
              fontSize: 18,
              color: CColors.headerText,
            ),
          ),
          ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemCount: _options.length,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 35),
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: _options[index]),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.onTapContinue != null) widget.onTapContinue();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)),
            color: CColors.lightGreen,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "continue".trs(context),
                style: TextStyle(
                  color: CColors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherField(BuildContext context, ui.Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "voucher".trs(context),
            style: TextStyle(
              fontSize: 15,
              color: CColors.headerText,
            ),
          ),
        ),
        if (_voucher == null)
          Expanded(
            child: SizedBox(
              height: size.height * 0.05,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsetsDirectional.only(
                            start: 10, top: 9, bottom: 9),
                        hintStyle: TextStyle(fontSize: 12),
                        hintText: "code".trs(context),
                        border: _buildVoucherTextFieldBorder(),
                        focusedBorder: _buildVoucherTextFieldBorder(),
                        enabledBorder: _buildVoucherTextFieldBorder(),
                      ),
                      onChanged: (value) => _voucher = value,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: FlatButton(
                      onPressed: () {
                        setState(() {});
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: CColors.darkOrange,
                      child: Text(
                        "apply".trs(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: CColors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          GestureDetector(
            onTap: () => setState(() => _voucher = null),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999)),
              color: CColors.fadeBlue,
              margin: EdgeInsets.zero,
              elevation: 0.0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: CColors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(Icons.close, size: 12),
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "#$_voucher",
                      style: TextStyle(
                        color: CColors.headerText,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  ShapeBorder _buildVoucherTextFieldBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.grey[300], width: 1),
    );
  }
}

class _AddressConfirmationDialog extends StatelessWidget {
  final VoidCallback onTapContinue;
  final VoidCallback onTapNewOne;

  const _AddressConfirmationDialog({
    Key key,
    this.onTapContinue,
    this.onTapNewOne,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Dialog(
      backgroundColor: CColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "order_will_be_delivered_to".trs(context),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: CColors.headerText,
              ),
            ),
            SizedBox(height: 10),
            Container(
              constraints: BoxConstraints(
                maxHeight: 150,
                maxWidth: size.width * 0.6,
              ),
              decoration: BoxDecoration(
                color: CColors.lightOrange,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
                leading:
                    SvgPicture.asset(Constants.mapPin, width: 40, height: 40),
                title: Text(
                  "AlQahera, Jamal 43st",
                  style: TextStyle(
                    fontSize: 13,
                    color: CColors.headerText,
                  ),
                ),
                subtitle: Text(
                  "AlQahera, Jamal 43st",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                "or_add_new_adress".trs(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CColors.grey,
                  fontSize: 11,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onTapNewOne != null) onTapNewOne();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: CColors.lightGreen, width: 2),
                  ),
                  color: CColors.transparent,
                  child: Text(
                    "new_one_address".trs(context),
                    style: TextStyle(
                      color: CColors.lightGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onTapContinue != null) onTapContinue();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: Colors.grey[200],
                  child: Text(
                    "continue".trs(context),
                    style: TextStyle(
                      color: CColors.lightGreen,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
