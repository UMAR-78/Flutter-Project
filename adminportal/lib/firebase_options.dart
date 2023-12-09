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
    apiKey: 'AIzaSyCgEfnRda2IeZIaefrswocQMzGEIAxWYtQ',
    appId: '1:718492132529:web:528225b8b618139613ee90',
    messagingSenderId: '718492132529',
    projectId: 'saucy-eats',
    authDomain: 'saucy-eats.firebaseapp.com',
    storageBucket: 'saucy-eats.appspot.com',
    measurementId: 'G-XY5C37VYNL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBx0YaLIvZrP8kP8jp0iAVyOrEw3EM3aa4',
    appId: '1:718492132529:android:1c3e98f31aed7df213ee90',
    messagingSenderId: '718492132529',
    projectId: 'saucy-eats',
    storageBucket: 'saucy-eats.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCO_H-3H6d18wgzxi7oxHgT4c4m5XjsXaI',
    appId: '1:718492132529:ios:030a4cf3f36d328413ee90',
    messagingSenderId: '718492132529',
    projectId: 'saucy-eats',
    storageBucket: 'saucy-eats.appspot.com',
    iosBundleId: 'com.example.adminportal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCO_H-3H6d18wgzxi7oxHgT4c4m5XjsXaI',
    appId: '1:718492132529:ios:35540602623fced713ee90',
    messagingSenderId: '718492132529',
    projectId: 'saucy-eats',
    storageBucket: 'saucy-eats.appspot.com',
    iosBundleId: 'com.example.adminportal.RunnerTests',
  );
}
