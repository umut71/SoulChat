import 'package:firebase_core/firebase_core.dart';

FirebaseOptions get currentPlatform => web;

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
