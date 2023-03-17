import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasepage/storagepage.dart';
import 'package:firebasepage/viewpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'mobileotp.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: viewpage(),
  ));
}
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class firebassepage extends StatefulWidget {
  const firebassepage({Key? key}) : super(key: key);

  @override
  State<firebassepage> createState() => _firebassepageState();
}

class _firebassepageState extends State<firebassepage> {
  TextEditingController Email = TextEditingController();
  TextEditingController Password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(margin: EdgeInsets.all(20),
                  child: TextField(
                    controller: Email,
                  )),
              Container(
                  margin: EdgeInsets.all(20),
                  child: TextField(
                    controller: Password,
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: Email.text,
                        password: Password.text,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }

                  }, child: Text("Submit")), SizedBox( width: 10,

                  ), ElevatedButton(onPressed: () async {

                    try {
                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: Email.text,
                          password: Password.text
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  }, child: Text("Login"))
                ],
              ),



            ],
          ),
        ),
    );
  }
}
