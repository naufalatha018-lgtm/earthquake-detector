import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCl4o6ME1Qu3P30_9i8QIdZo5suUdF3THU',
      appId: '1:1062630885196:android:a2f9d3dba12380479831e9',
      messagingSenderId: '1062630885196',
      projectId: 'seismoguardeqalert',
      databaseURL: 'https://seismoguardeqalert-default-rtdb.asia-southeast1.firebasedatabase.app',
      storageBucket: 'seismoguardeqalert.firebasestorage.app',
    );
  }
}
