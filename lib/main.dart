import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter notification",
      debugShowCheckedModeBanner: false,
      home: FlutterNotification(),
    );
  }
}

class FlutterNotification extends StatefulWidget {
  @override
  _FlutterNotificationState createState() => _FlutterNotificationState();
}

class _FlutterNotificationState extends State<FlutterNotification> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  String title = "Testing";
  String body = "onLauch";

  @override
  void initState() {
    // TODO: implement initState
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> messgae) async {
        print("Message (onMessage) $messgae");
        final notificationData = messgae["notification"];
        setState(() {
          title = notificationData["title"];
          body = notificationData["body"];
          print(title);
          print(body);
        });
      },
      onLaunch: (Map<String, dynamic> messgae) async {
        print("Message (onLaunch) $messgae");
        // final notificationData = messgae["data"];
        setState(() {
          title = messgae["data"]["title"];
          body = "notification come";
          print(" on launch $title");
          print("on launch $body");
        });
//        showDialog(
//            context: context,
//            builder: (_) {
//              return AlertDialog(
//                title: Text(notificationData["title"]),
//                content: Text(notificationData["body"]),
//                actions: <Widget>[
//                  FlatButton(
//                      onPressed: () => Navigator.pop(context),
//                      child: Text("ok"))
//                ],
//              );
//            });
      },
      onResume: (Map<String, dynamic> messgae) async {
        print("Message (onResume) $messgae");
        //final notificationData = messgae["data"];
        title = await messgae["data"]["title"];
        setState(() {
          print("---------------------------");
          print(title);
          body = "new notification comes from onResume callback";
        });
      },
    );
    super.initState();
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification in flutter"),
        elevation: 3,
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text(body),
          )
        ],
      ),
    );
  }
}
