import 'package:firebase_core/firebase_core.dart';

import 'firebase_config_io.dart' if (dart.library.html) 'firebase_config_web.dart' as impl;

class FirebaseConfig {
  static FirebaseOptions get currentPlatform => impl.currentPlatform;
}
