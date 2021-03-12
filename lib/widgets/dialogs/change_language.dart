
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harvest/helpers/Localization/localization.dart';
import 'package:harvest/helpers/colors.dart';
import 'package:harvest/main.dart';
import 'package:provider/provider.dart';


class ChangeLanguageDialog extends StatefulWidget {
  @override
  _ChangeLanguageDialogState createState() => _ChangeLanguageDialogState();
}

class _ChangeLanguageDialogState extends State<ChangeLanguageDialog> {
  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;
    var translate = Provider.of<LangProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 154,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 146,
                    width: 300,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.elliptical(9999.0, 9999.0)),
                            color: const Color(0xa3f88518),
                          ),
                          child: Center(
                              child: SvgPicture.asset(
                                  'assets/icons/alert-triangle.svg')),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            'Change Language?'.trs(context),
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xff3c4959),
                              letterSpacing: 0.14,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                height: 35,
                                width: 84,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  border: Border.all(color: CColors.darkOrange),
                                ),
                                child: Center(
                                    child: Text(
                                      'No'.trs(context),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: CColors.darkOrange,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                if (translate.getLocaleCode() == 'ar') {
                                  translate.setLocale(locale: Locales.en);
                                } else {
                                  translate.setLocale(locale: Locales.ar);
                                }
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                Navigator.of(context, rootNavigator: true)
                                    .pushReplacement(MaterialPageRoute(
                                  // context: context,
                                  builder: (context) => MyApp(),
                                ));
                              } ,
                              child: Container(
                                height: 35,
                                width: 84,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: CColors.darkOrange,
                                ),
                                child: Center(
                                  child:  Text(
                                    'Yes'.trs(context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                        color: Colors.white60,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x12000000),
                            offset: Offset(0, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: SvgPicture.asset('assets/icons/cancel.svg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
