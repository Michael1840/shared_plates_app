import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static Future<bool> isConnectedToNetwork() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi)) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isOnline() async {
    if (!await isConnectedToNetwork()) return false;
    return await hasInternetAccess();
  }
}
