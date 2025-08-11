import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_textfield.dart';
import '../widgets/app_button.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../utils/validators.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  List<Map<String, dynamic>> cities = [];
  List<Map<String, dynamic>> talukas = [];
  List<Map<String, dynamic>> districts = [];

  String? selectedCityId;
  String? selectedTalukaId;
  String? selectedDistrictId;
  bool enableBiometric = false;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final res = await ApiService.getLocations();
    if (res['cities'] != null && res['cities'] is List) {
      setState(() {
        cities = List<Map<String, dynamic>>.from((res['cities'] as List).map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

  void onCityChange(String? cid) {
    setState(() {
      selectedCityId = cid;
      selectedTalukaId = null;
      selectedDistrictId = null;
      talukas = [];
      districts = [];
      final c = cities.firstWhere((e) => e['id'] == cid, orElse: () => {});
      if (c.isNotEmpty && c['talukas'] is List) {
        talukas = List<Map<String, dynamic>>.from((c['talukas'] as List).map((e) => Map<String, dynamic>.from(e)));
      }
    });
  }

  void onTalukaChange(String? tid) {
    setState(() {
      selectedTalukaId = tid;
      selectedDistrictId = null;
      districts = [];
      final t = talukas.firstWhere((e) => e['id'] == tid, orElse: () => {});
      if (t.isNotEmpty && t['districts'] is List) {
        districts = List<Map<String, dynamic>>.from((t['districts'] as List).map((e) => Map<String, dynamic>.from(e)));
      }
    });
  }

  Future<void> _onRegister() async {
    if (!_form.currentState!.validate()) return;
    if (selectedCityId == null || selectedTalukaId == null || selectedDistrictId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select City/Taluka/Jilla')));
      return;
    }
    final auth = context.read<AuthProvider>();
    final map = {
      "fullName": nameCtrl.text.trim(),
      "username": usernameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "password": passCtrl.text.trim(),
      "cityId": selectedCityId,
      "talukaId": selectedTalukaId,
      "districtId": selectedDistrictId,
    };
    final ok = await auth.signUp(map, enableBiometric: enableBiometric);
    if (ok) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(auth.error ?? 'Signup failed')));
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(children: [
            AppTextField(label: 'Full Name', controller: nameCtrl, validator: Validators.requiredField),
            const SizedBox(height: 12),
            AppTextField(label: 'Username', controller: usernameCtrl, validator: Validators.requiredField),
            const SizedBox(height: 12),
            AppTextField(label: 'Email', controller: emailCtrl, validator: Validators.validateEmail, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            AppTextField(label: 'Password', controller: passCtrl, validator: Validators.validatePassword, obscure: true),
            const SizedBox(height: 12),
            // city dropdown
            DropdownButtonFormField<String>(
              value: selectedCityId,
              items: cities.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name'].toString()))).toList(),
              onChanged: onCityChange,
              decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
              validator: (v) => v == null ? 'Select City' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedTalukaId,
              items: talukas.map((t) => DropdownMenuItem(value: t['id'].toString(), child: Text(t['name'].toString()))).toList(),
              onChanged: onTalukaChange,
              decoration: const InputDecoration(labelText: 'Taluka', border: OutlineInputBorder()),
              validator: (v) => v == null ? 'Select Taluka' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedDistrictId,
              items: districts.map((d) => DropdownMenuItem(value: d['id'].toString(), child: Text(d['name'].toString()))).toList(),
              onChanged: (v) => setState(() => selectedDistrictId = v),
              decoration: const InputDecoration(labelText: 'Jilla', border: OutlineInputBorder()),
              validator: (v) => v == null ? 'Select Jilla' : null,
            ),
            const SizedBox(height: 12),
            Row(children: [
              Checkbox(value: enableBiometric, onChanged: (v) => setState(() => enableBiometric = v ?? false)),
              const SizedBox(width: 6),
              const Expanded(child: Text('Enable biometric login (fingerprint)')),
            ]),
            const SizedBox(height: 12),
            AppButton(text: 'Register', onTap: _onRegister, loading: auth.loading),
          ]),
        ),
      ),
    );
  }
}
