import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;

FirebaseOptions get currentPlatform {
  if (Platform.isAndroid) {
    return android;
  } else if (Platform.isIOS) {
    return ios;
  } else {
    return web;
  }
}

const android = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:android:xxxxxxxxxxxxx',
  messagingSenderId: '123456789',
  projectId: 'soulchat-pro',
  storageBucket: 'soulchat-pro.appspot.com',
  databaseURL: 'https://soulchat-pro-default-rtdb.firebaseio.com',
);

const ios = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:ios:xxxxxxxxxxxxx',
  messagingSenderId: '123456789',
  projectId: 'soulchat-pro',
  storageBucket: 'soulchat-pro.appspot.com',
  iosClientId: 'com.googleusercontent.apps.xxxxxxxxxxxxx',
  iosBundleId: 'com.soulchat.app',
  databaseURL: 'https://soulchat-pro-default-rtdb.firebaseio.com',
);

const web = FirebaseOptions(
  apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  appId: '1:123456789:web:xxxxxxxxxxxxx',
  messagingSenderId: '123456789',
  projectId: 'soulchat-pro',
  storageBucket: 'soulchat-pro.appspot.com',
  authDomain: 'soulchat-pro.firebaseapp.com',
  databaseURL: 'https://soulchat-pro-default-rtdb.firebaseio.com',
  measurementId: 'G-XXXXXXXXXX',
);
