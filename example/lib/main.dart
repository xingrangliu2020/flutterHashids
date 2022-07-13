/*
 * QR.Flutter
 * Copyright (c) 2019 the QR.Flutter authors.
 * See LICENSE for distribution and usage details.
 */
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:android_path_provider/android_path_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main_screen.dart';

void main() => runApp(ExampleApp());

/// The example application class
class ExampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'QR.Flutter',
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}
