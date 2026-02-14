import 'dart:io';

import 'package:flutter/material.dart';

abstract class Methods {

  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 2)); // Add a timeout
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// checks if the current screen size is that of tablet
  static bool isTabletScreen({required BuildContext context}) {
    // shortest side of the current screen in logical pixels
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    // tablet screen start from 600 logical pixels
    return shortestSide >= 600;
  }
}