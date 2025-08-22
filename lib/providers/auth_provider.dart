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
  String? updatedtoken;

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

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    updatedtoken = prefs.getString('token');
    notifyListeners();
  }

  Future<void> saveToken(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    updatedtoken = newToken;
    await prefs.setString('token', newToken);
    notifyListeners();
  }
  Future<void> _clearToken() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove('token');
    updatedtoken = null;
    _token = null;
  }

  Future<bool> signIn(String mobileNo) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await ApiService.login(mobileNo);
      if (res['success'] == true) {

        _user = Map<String, dynamic>.from(res['user'] ?? {});
        final tok = res['token']?.toString() ?? 'dummy_token';

        print("sdfdsf" + tok.toString());
        //await saveToken(tok);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", tok.toString());
        updatedtoken = tok.toString();
        _token = tok.toString();
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

        _user = Map<String, dynamic>.from(res['user'] ?? {});
        final tok = res['token']?.toString() ?? 'dummy_token_signup';

        print("TOKFGKFGKFG" + res['token']!.toString() );
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("token", tok.toString());
        updatedtoken = tok.toString();
        _token = tok.toString();
       // if (enableBiometric) await setBiometricEnabled(true);
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
