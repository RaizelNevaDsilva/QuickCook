// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  /// 🔹 WEB
  static FirebaseOptions get web => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY']!,
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId:
            dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'],
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
      );

  /// 🔹 ANDROID
  static FirebaseOptions get android => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId:
            dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
      );

  /// 🔹 IOS
  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId:
            dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
        iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'],
      );

  /// 🔹 MACOS
  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId:
            dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
        iosBundleId: dotenv.env['FIREBASE_IOS_BUNDLE_ID'],
      );

  /// 🔹 WINDOWS
  static FirebaseOptions get windows => FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
        appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
        messagingSenderId:
            dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'],
      );
}