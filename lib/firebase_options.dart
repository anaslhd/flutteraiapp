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
    apiKey: 'AIzaSyAGGjon7Ab7xeVOMCbzkTR0PMDCEFjR560',
    appId: '1:770615535808:web:ade1c30403755b61a22525',
    messagingSenderId: '770615535808',
    projectId: 'flutterappaim2',
    authDomain: 'flutterappaim2.firebaseapp.com',
    storageBucket: 'flutterappaim2.firebasestorage.app',
    measurementId: 'G-X6VB24M2ZH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAUapIShR0gprMCONGDIMllCw2DmrA0avI',
    appId: '1:770615535808:android:3632c8df344ba97ca22525',
    messagingSenderId: '770615535808',
    projectId: 'flutterappaim2',
    storageBucket: 'flutterappaim2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNbbL2ZAS6y-teoNlank7l8NwPxV9og78',
    appId: '1:770615535808:ios:7c3e71f4c88ddd99a22525',
    messagingSenderId: '770615535808',
    projectId: 'flutterappaim2',
    storageBucket: 'flutterappaim2.firebasestorage.app',
    iosBundleId: 'com.example.flutteraiapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNbbL2ZAS6y-teoNlank7l8NwPxV9og78',
    appId: '1:770615535808:ios:7c3e71f4c88ddd99a22525',
    messagingSenderId: '770615535808',
    projectId: 'flutterappaim2',
    storageBucket: 'flutterappaim2.firebasestorage.app',
    iosBundleId: 'com.example.flutteraiapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAGGjon7Ab7xeVOMCbzkTR0PMDCEFjR560',
    appId: '1:770615535808:web:5441edbd00acef07a22525',
    messagingSenderId: '770615535808',
    projectId: 'flutterappaim2',
    authDomain: 'flutterappaim2.firebaseapp.com',
    storageBucket: 'flutterappaim2.firebasestorage.app',
    measurementId: 'G-EGKMMMVLDF',
  );
}
