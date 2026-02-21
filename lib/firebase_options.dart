// Firebase yapılandırması – soulchat-pro projesi.
// Cloud Firestore API: soulchat-pro için Firebase Console > Build > Firestore Database'de etkin olmalı.
// PERMISSION_DENIED alırsanız: Firestore kurallarını ve proje adının soulchat-pro olduğunu kontrol edin.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const String _projectId = 'soulchat-pro';
  static const String _apiKey = 'AIzaSyB69cg48Z_t6gWeLVNr1MMplCceellFu2o';
  static const String _storageBucket = 'soulchat-pro.appspot.com';
  static const String _databaseUrl = 'https://soulchat-pro-default-rtdb.firebaseio.com';
  static const String _messagingSenderId = '830675250033';

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        return web;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYoClExu4mohcdNO-9iV-9Ac3yQt5M98Q',
    appId: '1:830675250033:android:42ef59a874a6cbf71f64d0',
    messagingSenderId: '830675250033',
    projectId: 'soulchat-pro',
    storageBucket: 'soulchat-pro.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDsHrwJ0Jzc7jiGZWiN6mKiUaIkHXYgXLM',
    appId: '1:830675250033:ios:3d1a03df3da629c01f64d0',
    messagingSenderId: '830675250033',
    projectId: 'soulchat-pro',
    storageBucket: 'soulchat-pro.firebasestorage.app',
    androidClientId: '830675250033-bp6m9ap294036c9ee771jfcbdibmteq0.apps.googleusercontent.com',
    iosClientId: '830675250033-tt8iivs2k5djd32akjtvh5tti52m0242.apps.googleusercontent.com',
    iosBundleId: 'e',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: _apiKey,
    appId: '1:830675250033:web:732f79687d5ecf891f64d0',
    messagingSenderId: _messagingSenderId,
    projectId: _projectId,
    storageBucket: _storageBucket,
    iosBundleId: 'com.soulchat.app',
    databaseURL: _databaseUrl,
  );

  /// Web (canlı): Firebase Console > Project settings > Your apps > Web app ile %100 aynı olmalı.
  /// apiKey, authDomain, projectId, storageBucket eksiksiz; yanlışsa logo ekranında takılma olabilir.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDdoumU381rxtyKD5t7HLqTaYI_RwT3cwM',
    appId: '1:830675250033:web:732f79687d5ecf891f64d0',
    messagingSenderId: '830675250033',
    projectId: 'soulchat-pro',
    authDomain: 'soulchat-pro.firebaseapp.com',
    storageBucket: 'soulchat-pro.firebasestorage.app',
    measurementId: 'G-GJ6MXBE5M1',
    databaseURL: 'https://soulchat-pro-default-rtdb.firebaseio.com',
  );

}