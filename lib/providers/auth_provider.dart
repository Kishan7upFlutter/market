import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  String? _token;
  String? get token => _token;

  String? _error;
  String? get error => _error;

  bool _biometricEnabled = false;
  bool get biometricEnabled => _biometricEnabled;

  final LocalAuthentication _localAuth = LocalAuthentication();

  AuthProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    _token = sp.getString('auth_token');
    _biometricEnabled = sp.getBool('biometric_enabled') ?? false;
    // optionally load cached user
    notifyListeners();
  }

  Future<void> _saveToken(String tok) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString('auth_token', tok);
    _token = tok;
  }

  Future<void> _clearToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('auth_token');
    _token = null;
  }

  Future<bool> signIn(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.login(email, password);
      if (res['success'] == true) {
        final simOk = await verifySim();
        if (!simOk) {
          _error = 'SIM verification failed';
          _loading = false;
          notifyListeners();
          return false;
        }
        _user = Map<String, dynamic>.from(res['user'] ?? {});
        final tok = res['token']?.toString() ?? 'dummy_token';
        await _saveToken(tok);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['message']?.toString() ?? 'Login failed';
      }
    } catch (e) {
      _error = 'Login error: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> signUp(Map<String, dynamic> formData, {bool enableBiometric = false}) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.signup(formData);
      if (res['success'] == true) {
        final simOk = await verifySim();
        if (!simOk) {
          _error = 'SIM verification failed';
          _loading = false;
          notifyListeners();
          return false;
        }
        _user = Map<String, dynamic>.from(res['user'] ?? {});
        final tok = res['token']?.toString() ?? 'dummy_token_signup';
        await _saveToken(tok);
        if (enableBiometric) await setBiometricEnabled(true);
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = res['message']?.toString() ?? 'Signup failed';
      }
    } catch (e) {
      _error = 'Signup error: $e';
    } finally {
      _loading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> signOut() async {
    _user = null;
    await _clearToken();
    notifyListeners();
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('biometric_enabled', enabled);
    _biometricEnabled = enabled;
    notifyListeners();
  }

  Future<bool> authenticateWithBiometrics({String reason = 'Authenticate'}) async {
    try {
      final can = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!can) return false;
      final did = await _localAuth.authenticate(localizedReason: reason, options: const AuthenticationOptions(biometricOnly: true));
      return did;
    } catch (e) {
      debugPrint('Biometric error: $e');
      return false;
    }
  }

  /// SIM verification placeholder. Real implementation: OTP or telephony plugin.
  Future<bool> verifySim() async {
    try {
      if (!Platform.isAndroid) {
        // iOS cannot reliably expose SIM; return true to not block iOS.
        return true;
      }
      final status = await Permission.phone.request();
      if (!status.isGranted) return false;

      // TODO: integrate mobile_number or telephony plugin to read SIM details here
      // For now return true as placeholder so flow works.
      return true;
    } catch (e) {
      debugPrint('SIM verify error: $e');
      return false;
    }
  }
}
