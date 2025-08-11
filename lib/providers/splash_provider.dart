import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SplashProvider extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  Map<String, String> _colors = {};
  Map<String, String> get colors => _colors;

  String _serverVersion = '0.0.0';
  String get serverVersion => _serverVersion;

  String? _error;
  String? get error => _error;

  Future<void> loadConfig() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.fetchAppConfig();
      if (res['success'] == true && res['colors'] != null) {
        final raw = Map<String, dynamic>.from(res['colors']);
        _colors = raw.map((k, v) => MapEntry(k.toString(), v.toString()));
        _serverVersion = res['appVersion']?.toString() ?? '0.0.0';
      } else {
        _error = 'Invalid config';
      }
    } catch (e) {
      _error = 'Config load failed: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
