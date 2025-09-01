import 'dart:math';
import 'package:flutter/material.dart';
import 'package:market/services/api_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DashboardProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> get items => _items;

  bool _forceUpdate = false;
  bool get forceUpdate => _forceUpdate;

  String? _updateUrl;
  String? get updateUrl => _updateUrl;

  String _serverVersion = '0.0.0';
  String get serverVersion => _serverVersion;

  String? _error;
  String? get error => _error;

  Future<void> fetchDashboardList() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.getDashboardList();
      if (res['items'] != null && res['items'] is List) {
        final raw = List<Map<String, dynamic>>.from((res['items'] as List).map((e) => Map<String, dynamic>.from(e)));
        _items = raw;
      } else {
        _error = 'Invalid dashboard response';
      }
    } catch (e) {
      _error = 'Dashboard error: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> checkAppVersionAndMaybeForce() async {
    try {
      final res = await ApiService.getAppVersion();
      _serverVersion = res['version']?.toString() ?? '0.0.0';
      final serverForce = (res['forceUpdate'] == true);
      _updateUrl = res['updateUrl']?.toString();

      final pkg = await PackageInfo.fromPlatform();
      final local = pkg.version;

      final cmp = _compareVersions(_serverVersion, local);
      if (serverForce || cmp == 1) {
        _forceUpdate = true;
      } else {
        _forceUpdate = false;
      }
    } catch (e) {
      debugPrint('Version check err: $e');
    } finally {
      notifyListeners();
    }
  }

  int _compareVersions(String v1, String v2) {
    final a = v1.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final b = v2.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final n = max(a.length, b.length);
    for (var i = 0; i < n; i++) {
      final ai = i < a.length ? a[i] : 0;
      final bi = i < b.length ? b[i] : 0;
      if (ai > bi) return 1;
      if (ai < bi) return -1;
    }
    return 0;
  }
}
