import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:harvest/helpers/app_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationsService {
  static LocalNotificationsService _instance;
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  int _id = 0;

  // ||.. private constructor ..||
  LocalNotificationsService._() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  // ||.. singleton pattern ..||
  static LocalNotificationsService get instance {
    if (_instance != null) return _instance;
    return _instance = LocalNotificationsService._();
  }

  //init.
  Future<void> init() async {
    await _initLocalNotifications();
  }

  // local notifications init.
  Future<void> _initLocalNotifications() async {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//    var initializationSettingsAndroid =
//        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/appicon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _selectNotification);
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
//    showDialog(
//      context: _context,
//      builder: (BuildContext context) => CupertinoAlertDialog(
//        title: Text(title),
//        content: Text(body),
//        actions: [
//          CupertinoDialogAction(
//            isDefaultAction: true,
//            child: Text('Ok'),
//            onPressed: () async {
//              NS.back();
////              await Navigator.push(
////                context,
////                MaterialPageRoute(
////                  builder: (context) => SecondScreen(payload),
////                ),
////              );
//            },
//          )
//        ],
//      ),
//    );
  }

  // ||... on local notification clicked ...||
  Future _selectNotification(String payload) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('userToken');
    try {
      Map<String, dynamic> notification =
          await jsonDecode(payload) as Map<String, dynamic>;
      // if (token != null) {
      //   if (AppShared.notification != null) {
      //     String msgType;
      //     if (AppShared.notification['data'] == null) {
      //       msgType = AppShared.notification['msgType'];
      //     } else {
      //       msgType = AppShared.notification['data']['msgType'];
      //       if (token != null) {
      //         if (prefs.getString('userType') == 'provider') {
      //           if (msgType == '2') {
      //             AppShared.navKey.currentState.pushReplacement(MaterialPageRoute(
      //               builder: (context) => CustomSideMenu(
      //                 id: 2,
      //               ),
      //             ));
      //           } else if (msgType == '3') {
      //             AppShared.navKey.currentState.pushReplacement(MaterialPageRoute(
      //               builder: (context) =>CustomSideMenu(
      //                 id: 5,
      //               ),
      //             ));
      //           } else if (msgType == '4') {
      //             AppShared.navKey.currentState.pushReplacement(MaterialPageRoute(
      //               builder: (context) =>CustomSideMenu(
      //                 id: 6,
      //               ),
      //             ));
      //           } else {
      //             AppShared.navKey.currentState.pushReplacement(MaterialPageRoute(
      //               builder: (context) => CustomSideMenu(
      //                 id: 4,
      //               ),
      //             ));
      //           }
      //         }
      //         else if (prefs.getString('userType') == 'customer') {
      //           if (msgType == '2') {
      //             AppShared.navKey.currentState
      //                 .pushReplacement(MaterialPageRoute(
      //               builder: (context) => CustomerSideMenu(
      //                 id: 2,
      //               ),
      //             ));
      //           } else if (msgType == '3') {
      //             AppShared.navKey.currentState
      //                 .pushReplacement(MaterialPageRoute(
      //               builder: (context) => CustomerSideMenu(
      //                 id: 5,
      //               ),
      //             ));
      //           } else {
      //             AppShared.navKey.currentState
      //                 .pushReplacement(MaterialPageRoute(
      //               builder: (context) => CustomerSideMenu(
      //                 id: 4,
      //               ),
      //             ));
      //           }
      //         } else {
      //           AppShared.navKey.currentState.pushReplacement(
      //               MaterialPageRoute(
      //                   builder: (context) => GuestSideMenu()));
      //         }
      //       }
      //       AppShared.notification = null;
      //     }
      //   } else {
      //     if (prefs.getString('userType') == 'provider') {
      //       AppShared.navKey.currentState.pushReplacement(MaterialPageRoute(
      //         builder: (context) => CustomSideMenu(),
      //       ));
      //     } else {
      //       AppShared.navKey.currentState.pushReplacement(MaterialPageRoute(
      //         builder: (context) => CustomerSideMenu(),
      //       ));
      //     }
      //   }
      // }
      AppShared.notification = null;
    } catch (error) {
      print(error.toString());
    }
  }

  // ||... show local notification ...||
  void showNotification(String title, String message, {String payload}) {
    _flutterLocalNotificationsPlugin.show(
      ++_id,
      title,
      message,
      NotificationDetails(
        AndroidNotificationDetails(
          title,
          'Harvest',
          message,
          enableVibration: true,
          enableLights: true,
          playSound: true,
          importance: Importance.Max,
          priority: Priority.High,
        ),
        IOSNotificationDetails(),
      ),
      payload: payload,
    );
  }
}
