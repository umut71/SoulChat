import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return ios;
    } else {
      return web;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:123456789:android:xxxxxxxxxxxxx',
    messagingSenderId: '123456789',
    projectId: 'soulchat',
    storageBucket: 'soulchat.appspot.com',
    databaseURL: 'https://soulchat-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:123456789:ios:xxxxxxxxxxxxx',
    messagingSenderId: '123456789',
    projectId: 'soulchat',
    storageBucket: 'soulchat.appspot.com',
    iosClientId: 'com.googleusercontent.apps.xxxxxxxxxxxxx',
    iosBundleId: 'com.soulchat.app',
    databaseURL: 'https://soulchat-default-rtdb.firebaseio.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:123456789:web:xxxxxxxxxxxxx',
    messagingSenderId: '123456789',
    projectId: 'soulchat',
    storageBucket: 'soulchat.appspot.com',
    authDomain: 'soulchat.firebaseapp.com',
    databaseURL: 'https://soulchat-default-rtdb.firebaseio.com',
    measurementId: 'G-XXXXXXXXXX',
  );
}
