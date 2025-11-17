// This file is manually generated using the Web configuration
// found in your Firebase console.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb; // kIsWeb added here

/// Default [FirebaseOptions] for specific platforms.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // CRITICAL web configuration (solves the JavaScriptObject error and the TargetPlatform.web error)
      return const FirebaseOptions(
        apiKey: 'AIzaSyDISDOu7_TbXV59yHgBcIwIbaHPMaVOK',
        authDomain: 'minecropsdb.firebaseapp.com',
        projectId: 'minecropsdb',
        storageBucket: 'minecropsdb.firebasestorage.app',
        messagingSenderId: '5436666819344',
        appId: '1:5436666819344:web:0e4e73e6faff90bc185595',
        measurementId: 'G-JC2C6C3QTV',
      );
    }

    // Configuration for platforms other than Web.
    // We can leave the switch statement for non-web platforms,
    // but the default will handle most cases now.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return const FirebaseOptions(
          apiKey: 'AIzaSyDISDOu7_TbXV59yHgBcIwIbaHPMaVOK',
          appId: '1:543666819344:android:efb226a090677b32185595',
          messagingSenderId: '5436666819344',
          projectId: 'minecropsdb',
          storageBucket: 'minecropsdb.firebaseapp.com',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}