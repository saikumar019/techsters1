import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

// final InitializationSettings initializationSettings =
//     InitializationSettings(android: initializationSettingsAndroid);

// class NotificationApi {
//   static final _notification = FlutterLocalNotificationsPlugin();
//   static Future _notificationDetails() async {
//     return NotificationDetails(
//       android: AndroidNotificationDetails('channel id', 'channel name',
//           priority: Priority.high,
//           playSound: true,
//           importance: Importance.high),
//     );
//   }

// AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

//   static Future showNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _notification.show(id, title, body, await _notificationDetails(),
//           payload: payload);
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

// final _messageStreamController = BehaviorSubject<RemoteMessage>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD4FJVc1jvamctrrOqmI0AZqdQKvug6PT0",
          appId: "1:786843198745:android:c8a58ec9ce2fe810d35188",
          messagingSenderId: "786843198745",
          projectId: "untitle-f48c2",
          storageBucket: "untitle-f48c2.appspot.com"));
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging messaging = FirebaseMessaging.instance;

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    '0',
    'channel name',
    playSound: true,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('arrive'),
    importance: Importance.high,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.notification!.title.toString()}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification.toString()}');
      await flutterLocalNotificationsPlugin.show(
        1,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _lastMessage = "";

  // _MyHomePageState() {
  //   _messageStreamController.listen((message) {
  //     setState(() {
  //       if (message.notification != null) {
  //         NotificationApi.showNotification(
  //           title: message.notification!.title,
  //           body: message.notification!.body,
  //         );
  //         // _lastMessage = 'Received a notification message:'
  //         //     '\nTitle=${message.notification?.title},'
  //         //     '\nBody=${message.notification?.body},'
  //         //     '\nData=${message.data}';
  //       } else {
  //         _lastMessage = 'Received a data message: ${message.data}';
  //       }
  //     });
  //   });
  // }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Last message from Firebase Messaging:',
                style: Theme.of(context).textTheme.titleLarge),
            Text(_lastMessage, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseMessaging _firebaseMessaging =
              FirebaseMessaging.instance; // Change here
          _firebaseMessaging.getToken().then((token) {
            print("token is $token");
          });
          // NotificationApi.showNotification(
          //     title: "aKASH",
          //     body: " B HXSN XJN NX ZNX NZ",
          //     payload: "AZASA.ABSÍ");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
