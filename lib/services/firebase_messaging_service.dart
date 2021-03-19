import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:harvest/helpers/app_shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_notifications_service.dart';
class LocalNotification {
  final String type;
  final Map data;

  LocalNotification(this.type, this.data);
}

// class NotificationsBloc {
//   NotificationsBloc._internal();
//
//   static final NotificationsBloc instance = NotificationsBloc._internal();
//
//   final BehaviorSubject<LocalNotification> _notificationsStreamController = BehaviorSubject<LocalNotification>();
//
//   Stream<LocalNotification> get notificationsStream {
//     return _notificationsStreamController;
//   }
//
//   void newNotification(LocalNotification notification) {
//     _notificationsStreamController.sink.add(notification);
//   }
//
//   void dispose() {
//     _notificationsStreamController?.close();
//   }
// }
class FirebaseMessagingService {
  static FirebaseMessagingService _instance;
  FirebaseMessaging _fcm;
  LocalNotificationsService _localNotificationsService;

  FirebaseMessagingService._() {
    _fcm = FirebaseMessaging();
    _localNotificationsService = LocalNotificationsService.instance;
  }

  FirebaseMessagingService(this._fcm);


  // ||.. singleton pattern ..||
  static FirebaseMessagingService get instance {
    if (_instance != null) return _instance;
    return _instance = FirebaseMessagingService._();
  }

  Future<String> getToken() async {
    return _fcm.getToken();
  }

  Future<void> _onMessage(Map<String, dynamic> message) async {
    print("onMessage $message");
    if (message['notification'] != null) {
      final notification = LocalNotification("notification", message['notification'] as Map);
      // NotificationsBloc.instance.newNotification(notification);
      if (AppShared.notification['notification'] == null) {
        _localNotificationsService.showNotification(
          message['title'],
          message['body'],
          payload: jsonEncode(AppShared.notification),
        );
      } else {
        if ((AppShared.notification['notification'] as Map).isEmpty)
          _localNotificationsService.showNotification(
            message['title'],
            message['body'],
          );
        else
          _localNotificationsService.showNotification(
            message['notification']['title'],
            message['notification']['body'],
            payload: jsonEncode(AppShared.notification),
          );
      }
      return null;
    }
    if (message['data'] != null) {
      final notification = LocalNotification("data", message['data'] as Map);
      // NotificationsBloc.instance.newNotification(notification);
      if (AppShared.notification['notification'] == null) {
        _localNotificationsService.showNotification(
          message['title'],
          message['body'],
          payload: jsonEncode(AppShared.notification),
        );
      } else {
        if ((AppShared.notification['notification'] as Map).isEmpty)
          _localNotificationsService.showNotification(
            message['title'],
            message['body'],
          );
        else
          _localNotificationsService.showNotification(
            message['notification']['title'],
            message['notification']['body'],
            payload: jsonEncode(AppShared.notification),
          );
      }
      return null;
    }
  }
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
    }

    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");

    _fcm.configure(
      onMessage:_onMessage,
//           (Map<String, dynamic> message) async {
// //         print("onMessage: $message");
// // //        appNotifiers.notificationsCount = ++appNotifiers.notificationsCount;
// // //        AppShared.sharedPreferencesController
// // //            .setNotificationsCount(appNotifiers.notificationsCount);
// //         AppShared.notification = message;
// //         String msgType;
// //         msgType = AppShared.notification['data']['msgType'];
// //         if (msgType == '3' &&
// //             (message['data']['target_id'] == AppShared.chat.id.toString())) {
// //           // var op = Provider.of<Messaging>(context,listen: false);
// //           // op.addItem(
// //           //     Random().toString(),
// //           //     message['data']['body'],
// //           //     Sender(
// //           //         avatar: AppShared.chat.user.avatar,
// //           //         fullName: AppShared.chat.user.fullName,
// //           //         id: AppShared.chat.user.id),
// //           //     AppShared.chat.dateAgo);
// //           // Messaging().addReceived(AppShared.notification['data']['body']);
// //           // AppShared.navKey.currentState
// //           //     .pushReplacement(MaterialPageRoute(
// //           //   builder: (context) => ChatPage(
// //           //     chat: AppShared.chat,
// //           //   ),
// //           // ));
// //         }
// //         if (AppShared.notification['notification'] == null) {
// //           _localNotificationsService.showNotification(
// //             message['title'],
// //             message['body'],
// //             payload: jsonEncode(AppShared.notification),
// //           );
// //         } else {
// //           if ((AppShared.notification['notification'] as Map).isEmpty)
// //             _localNotificationsService.showNotification(
// //               message['title'],
// //               message['body'],
// //             );
// //           else
// //             _localNotificationsService.showNotification(
// //               message['notification']['title'],
// //               message['notification']['body'],
// //               payload: jsonEncode(AppShared.notification),
// //             );
// //         }
//       },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        AppShared.notification = message;
      },
      onResume: (Map<String, dynamic> message) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("onResume: $message");
        try {
          AppShared.notification = message;
          String token = prefs.getString('userToken');
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
          //             AppShared.navKey.currentState
          //                 .pushReplacement(MaterialPageRoute(
          //               builder: (context) => CustomSideMenu(
          //                 id: 2,
          //               ),
          //             ));
          //           } else if (msgType == '3') {
          //             AppShared.navKey.currentState
          //                 .pushReplacement(MaterialPageRoute(
          //               builder: (context) => CustomSideMenu(
          //                 id: 5,
          //               ),
          //             ));
          //           } else if (msgType == '4') {
          //             AppShared.navKey.currentState
          //                 .pushReplacement(MaterialPageRoute(
          //               builder: (context) => CustomSideMenu(
          //                 id: 6,
          //               ),
          //             ));
          //           } else {
          //             AppShared.navKey.currentState
          //                 .pushReplacement(MaterialPageRoute(
          //               builder: (context) => CustomSideMenu(
          //                 id: 4,
          //               ),
          //             ));
          //           }
          //         } else if (prefs.getString('userType') == 'customer') {
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
      },
    );
  }

//   Future<void> init() async {
//     _fcm.requestNotificationPermissions(IosNotificationSettings(sound: true,
//         badge: true,
//         alert: true));
// //    _fcm.subscribeToTopic('');
//     _fcm.configure(
//
//
//
//     );
//   }
}
