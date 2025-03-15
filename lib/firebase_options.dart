// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDX_GgSgs7x8WF-WXkZILbnbiF8fz7YWEg',
    appId: '1:558421044130:web:4883694a5351eb9fbee0fb',
    messagingSenderId: '558421044130',
    projectId: 'press2safety',
    authDomain: 'press2safety.firebaseapp.com',
    storageBucket: 'press2safety.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDtnLyoQaiVCYqtrsHsKJP_DZbGe-xaTTY',
    appId: '1:558421044130:android:1a6a837dcac94589bee0fb',
    messagingSenderId: '558421044130',
    projectId: 'press2safety',
    storageBucket: 'press2safety.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDtzft-eGKEQoUfmEFjDeS6_Mn9lABMNAg',
    appId: '1:558421044130:ios:6f074716851ead4bbee0fb',
    messagingSenderId: '558421044130',
    projectId: 'press2safety',
    storageBucket: 'press2safety.firebasestorage.app',
    iosBundleId: 'com.example.press2safety',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDtzft-eGKEQoUfmEFjDeS6_Mn9lABMNAg',
    appId: '1:558421044130:ios:6f074716851ead4bbee0fb',
    messagingSenderId: '558421044130',
    projectId: 'press2safety',
    storageBucket: 'press2safety.firebasestorage.app',
    iosBundleId: 'com.example.press2safety',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDX_GgSgs7x8WF-WXkZILbnbiF8fz7YWEg',
    appId: '1:558421044130:web:591823ccfd7cfec9bee0fb',
    messagingSenderId: '558421044130',
    projectId: 'press2safety',
    authDomain: 'press2safety.firebaseapp.com',
    storageBucket: 'press2safety.firebasestorage.app',
  );
}
