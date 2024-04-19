// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAkOqGOqiYSzL3oraoKbyIdJWDpIdO7qg0',
    appId: '1:809265672060:web:c9888fe4bcec6d107c3ef9',
    messagingSenderId: '809265672060',
    projectId: 'notification-dada12',
    authDomain: 'notification-dada12.firebaseapp.com',
    storageBucket: 'notification-dada12.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAqSGdMnHuqfvL8WZLFy0YPekAsRhwJWtU',
    appId: '1:809265672060:android:77e62e90c6145f2c7c3ef9',
    messagingSenderId: '809265672060',
    projectId: 'notification-dada12',
    storageBucket: 'notification-dada12.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXuibd2I_WYqj2UepgkGGKS5Xe1LaK-Us',
    appId: '1:809265672060:ios:65fce1448ae633277c3ef9',
    messagingSenderId: '809265672060',
    projectId: 'notification-dada12',
    storageBucket: 'notification-dada12.appspot.com',
    iosBundleId: 'com.example.notifications',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAXuibd2I_WYqj2UepgkGGKS5Xe1LaK-Us',
    appId: '1:809265672060:ios:5ff421fd0e5dc40d7c3ef9',
    messagingSenderId: '809265672060',
    projectId: 'notification-dada12',
    storageBucket: 'notification-dada12.appspot.com',
    iosBundleId: 'com.example.notifications.RunnerTests',
  );
}