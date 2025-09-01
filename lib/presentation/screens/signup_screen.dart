import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:market/presentation/providers/auth_provider.dart';
import 'package:market/services/api_service.dart';
import 'package:market/utils/validators.dart';
import 'package:market/widgets/app_button.dart';
import 'package:market/widgets/app_textfield.dart';
import 'package:provider/provider.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final mobileNoCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final shopCtrl = TextEditingController();


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
    final auth = context.read<ApiProvider>();
    final map = {
      /*"fullName": nameCtrl.text.trim(),
      "mobileNo":mobileNoCtrl.text.trim(),
      "address":addressCtrl.text.trim(),
      "cityId": selectedCityId,
      "talukaId": selectedTalukaId,
      "districtId": selectedDistrictId,*/

     /* "fcm_token":"fcm_token123",
      "device_id":"device_id123",*/
      "shopName": shopCtrl.text.toString(),
      "contactNumber": mobileNoCtrl.text,
      "fullName": nameCtrl.text.toString(),
      "address": addressCtrl.text.toString(),
      "taluka": selectedTalukaId.toString(),
      "jilla": selectedDistrictId.toString(),
      "city": selectedCityId.toString(),
      "state": selectedDistrictId.toString()
    };
    final ok = await auth.registerUser(map, enableBiometric: enableBiometric);
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
    addressCtrl.clear();
    shopCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(title: const Text('Sign Up')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(children: [

              const SizedBox(height: 12),
              Container(
                height: 124.h,
                width: 124.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // poora gol
                  border: Border.all(
                    color: Color(0xFF000000), // black border
                    width: 3.w, // border ki motai
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/logo.png"),
                    fit: BoxFit.cover, // image ko circle ke andar fit karega
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text("Sign Up",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24.sp)),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Full Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              AppTextField(label: 'Full Name', controller: nameCtrl, validator: Validators.requiredField),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Mobile No.",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              AppTextField(label: 'Enter Mobile No.', controller: mobileNoCtrl, validator: Validators.maxdigit , keyboardType:TextInputType.number ,),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Address",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              AppTextField(label: 'Address', controller: addressCtrl),
              const SizedBox(height: 12),

             /* Align(
                alignment: Alignment.centerLeft,
                child: Text("Select State",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              // city dropdown
              DropdownButtonFormField<String>(
                value: selectedCityId,
                items: cities.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name'].toString()))).toList(),
                onChanged: onCityChange,
                decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Select City' : null,
              ),
              const SizedBox(height: 12),*/

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Select City",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              // city dropdown
              DropdownButtonFormField<String>(
                value: selectedCityId,
                items: cities.map((c) => DropdownMenuItem(value: c['id'].toString(), child: Text(c['name'].toString()))).toList(),
                onChanged: onCityChange,
                decoration: const InputDecoration(hintText: 'City', border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Select City' : null,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Taluka",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedTalukaId,
                items: talukas.map((t) => DropdownMenuItem(value: t['id'].toString(), child: Text(t['name'].toString()))).toList(),
                onChanged: onTalukaChange,
                decoration: const InputDecoration(hintText: 'Taluka', border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Select Taluka' : null,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Select Jilla",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: selectedDistrictId,
                items: districts.map((d) => DropdownMenuItem(value: d['id'].toString(), child: Text(d['name'].toString()))).toList(),
                onChanged: (v) => setState(() => selectedDistrictId = v),
                decoration: const InputDecoration(hintText: 'Jilla', border: OutlineInputBorder()),
                validator: (v) => v == null ? 'Select Jilla' : null,
              ),
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text("Shop Name",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              AppTextField(label: 'Shop Name', controller: shopCtrl),
              const SizedBox(height: 24),
             /* Row(children: [
                Checkbox(value: enableBiometric, onChanged: (v) => setState(() => enableBiometric = v ?? false)),
                const SizedBox(width: 6),
                const Expanded(child: Text('Enable biometric login (fingerprint)')),
              ]),
              const SizedBox(height: 12),*/
              AppButton(text: 'Register', onTap: _onRegister, loading: auth.loading),
            ]),
          ),
        ),
      ),
    );
  }
}
