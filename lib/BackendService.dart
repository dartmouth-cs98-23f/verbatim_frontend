import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class BackendService {
  static String _backendUrl = '';

  static Future<void> loadProperties(String environment) async {
    String content = await rootBundle.loadString('assets/config.properties');
    final properties = content.split('\n');

    for (var property in properties) {
      final keyVal = property.split('=');
      if (keyVal.length == 2 && keyVal[0] == 'backendUrl.$environment') {
        _backendUrl = keyVal[1];
        break;
      }
    }
  }

  static String getBackendUrl() {
    return _backendUrl;
  }
}