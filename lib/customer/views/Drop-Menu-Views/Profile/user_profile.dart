import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harvest/helpers/persistent_tab_controller_provider.dart';
import 'package:harvest/helpers/variables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/customer/components/WaveAppBar/appBar_body.dart';
import 'package:harvest/customer/models/user.dart';
import 'package:harvest/customer/views/Drop-Menu-Views/Profile/user_addresses.dart';
import 'package:harvest/customer/widgets/custom_main_button.dart';
import 'package:harvest/customer/widgets/profile_text_field.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/api.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/helpers/constants.dart';
import 'dart:io';
import 'package:harvest/widgets/basket_button.dart';
import 'package:harvest/widgets/dialogs/change_language.dart';
import 'package:harvest/widgets/home_popUp_menu.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File selectedImage;
  TextEditingController _name, _mobile, _email;
  bool isChanged = false;
  bool load = false;

  updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var op = Provider.of<UserFunctions>(context, listen: false);
    Map<String, String> headers = {
      "Authorization": "Bearer ${prefs.getString('userToken')}",
      "Accept-Language": "${prefs.getString('language')}",
      "Accept": "application/json",
    };

    Map<String, String> body = {
      'name': _name.text,
      'email': _email.text,
      'mobile': _mobile.text,
      'device_type': 'android',
      'fcm_token': '5555',
    };

    var uri = Uri.parse(ApiHelper.api + 'editProfile');
    var request = new MultipartRequest("POST", uri);

    if (_formKey.currentState.validate()) {
      setState(() {
        load = true;
      });
      if (selectedImage != null) {
        var stream =
            new ByteStream(DelegatingStream.typed(selectedImage.openRead()));
        // get file length
        var length = await selectedImage.length();
        var multipartFile = new MultipartFile('image_profile', stream, length,
            filename: path.basename(selectedImage.path));
        request.files.add(selectedImage != null ? multipartFile : '');
      }
      request.headers.addAll(headers);
      request.fields.addAll(body);
      Response response = await Response.fromStream(await request.send());
      var output = json.decode(response.body);
      Fluttertoast.showToast(msg: output['message']);
      if (output['status'] == true) {
        User user = User.fromJson(output['user']);
        op.setUser(user);
        setState(() {
          isChanged = false;
        });
      }
      setState(() {
        load = false;
      });
    }
  }

  pickImageDialog() {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: CColors.lightOrange,
            ),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () =>
                      getImage().then((value) => Navigator.pop(context)),
                  child: Container(
                    height: 41,
                    width: 41,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: CColors.darkOrange,
                      border: Border.all(width: 4.0, color: Colors.white),
                    ),
                    child: Center(
                        child: SvgPicture.asset(
                      'assets/icons/camera.svg',
                      color: CColors.darkGreen,
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      getImageGallery().then((value) => Navigator.pop(context)),
                  child: Container(
                    height: 41,
                    width: 41,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: CColors.darkOrange,
                      border: Border.all(width: 4.0, color: Colors.white),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/folder.svg',
                        color: CColors.darkGreen,
                      ),
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        selectedImage = image;
        isChanged = true;
      });
    }

    //return image;
  }

  Future getImageGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
        isChanged = true;
      });
    }
    //return image;
  }

  @override
  void initState() {
    var op = Provider.of<UserFunctions>(context, listen: false);
    _name = new TextEditingController(text: op.user.name);
    _mobile = new TextEditingController(text: op.user.mobile);
    _email = new TextEditingController(text: op.user.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var op = Provider.of<UserFunctions>(context);
    final Size size = MediaQuery.of(context).size;
    final trs = AppTranslations.of(context);
    return Scaffold(
      body: WaveAppBarBody(
        bottomViewOffset: Offset(0, 10),
        leading: BasketButton(),
        // pinned: true,
        // hideActions: true,
        backgroundGradient: CColors.greenAppBarGradient(),
        actions: [HomePopUpMenu()],
        bottomView: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 73,
              width: 73,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 71,
                      width: 71,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CColors.lightOrange,
                        border: Border.all(color: CColors.white, width: 3),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: selectedImage != null
                              ? FileImage(selectedImage)
                              : op.user.imageProfile!= null?NetworkImage(op.user.imageProfile):AssetImage(''),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pickImageDialog(),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: CColors.darkGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                op.user.name??'',
                style: TextStyle(
                  color: CColors.headerText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                bottom: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "account_setting".trs(context),
                    style: TextStyle(
                      fontSize: 16,
                      color: CColors.headerText,
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        NoBGTextField(
                          hint: 'User Name',
                          validator: (value) =>
                              FieldValidator.validate(value, context),
                          onChanged: (value) {
                            setState(() {
                              isChanged = true;
                            });
                          },
                          controller: _name,
                          contentPadding: EdgeInsetsDirectional.only(
                              start: 20, top: 15, bottom: 15),
                        ),
                        NoBGTextField(
                          validator: (value) =>
                              FieldValidator.validate(value, context),
                          hint: 'Phone Number',
                          onChanged: (value) {
                            setState(() {
                              isChanged = true;
                            });
                          },
                          controller: _mobile,
                          textInputType: TextInputType.phone,
                          icon: Icon(FontAwesomeIcons.mobileAlt,
                              color: CColors.lightGreen),
                        ),
                        NoBGTextField(
                          hint: 'Email',
                          onChanged: (value) {
                            setState(() {
                              isChanged = true;
                            });
                          },
                          controller: _email,
                          textInputType: TextInputType.emailAddress,
                          icon: Icon(FontAwesomeIcons.envelope,
                              color: CColors.lightGreen),
                        ),
                      ],
                    ),
                  ),
                  // NoBGTextField(
                  //   hint: "Address",
                  //   textInputType: TextInputType.emailAddress,
                  //   icon: Container(
                  //       height: 20,
                  //       width: 15,
                  //       child: Center(
                  //           child: SvgPicture.asset(
                  //               'assets/icons/location_icon.svg',
                  //               color: CColors.lightGreen))),
                  // ),
                  isChanged
                      ? Center(
                          child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                          child: MainButton(
                            title: 'save'.trs(context),
                            loading: load,
                            onTap: () {
                              updateProfile();
                            },
                          ),
                        ))
                      : Container(),
                  UserAddresses(),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: CColors.fadeBlue,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(Constants.settingsIcon),
                                    Text(
                                      "app_setting".trs(context),
                                      style: TextStyle(
                                        color: CColors.headerText,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              _SettingsButton(
                                onTap: () {
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (context) =>
                                        ChangeLanguageDialog(),
                                  );
                                },
                                iconPath: Constants.languageIcon,
                                title: LangProvider().getLocaleCode() == 'ar'
                                    ? "العربية"
                                    : "English",
                              ),
                              _SettingsButton(
                                onTap: () {
                                  context.read<PTVController>().jumbToTab(AppTabs.Support);
                                },
                                iconPath: Constants.questionIcon,
                                title: "help".trs(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned.directional(
                        textDirection: trs.textDirection,
                        end: -10,
                        top: -10,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CColors.darkOrange,
                            border: Border.all(color: CColors.white, width: 3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
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
    );
  }
}

class _SettingsButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  final String title;
  final TextStyle textStyle;
  final Size iconSize;

  const _SettingsButton({
    Key key,
    @required this.iconPath,
    @required this.title,
    this.textStyle,
    this.iconSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: CColors.fadeBlueAccent,
        borderRadius: BorderRadius.circular(13),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath,
                height: iconSize?.height ?? 19,
                width: iconSize?.width ?? 19,
              ),
              SizedBox(width: 11),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xff3c4959),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
