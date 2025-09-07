import 'package:dropdown_search/dropdown_search.dart';
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
  List<Map<String, dynamic>> jilla = [];
  List<Map<String, dynamic>> state = [];

/*  Map<String, dynamic>? selectedState;
  Map<String, dynamic>? selectedDistrict;
  Map<String, dynamic>? selectedSubDistrict;
  Map<String, dynamic>? selectedCity;*/


  String? selectedCityId;
  String? selectedTalukaId;
  String? selectedJillaId;
  String? selectedStateId;

  bool enableBiometric = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ApiProvider>().getStates();
    });
   // Provider.of<ApiProvider>(context, listen: false).getStates();

    // _loadLocations();
  }

  Future<void> _loadLocations() async {
    final res = await ApiService.getLocations();
    if (res['cities'] != null && res['cities'] is List) {
      setState(() {
        cities = List<Map<String, dynamic>>.from((res['cities'] as List).map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

 /* void onCityChange(String? cid) {
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
  }*/

  Future<void> _onRegister() async {
    if (!_form.currentState!.validate()) return;
   /* if (selectedCityId == null || selectedTalukaId == null || selectedDistrictId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select City/Taluka/Jilla')));
      return;
    }*/
    final auth = context.read<ApiProvider>();



// 🔽 State
    final state = auth.selectedState;
    if (state != null && state.isNotEmpty) {
      print("State ID: ${state['_id']}");
      print("State Name: ${state['name']}");
    }

    // 🔽 District
    final district = auth.selectedDistrict;
    if (district != null && district.isNotEmpty) {
      print("District ID: ${district['_id']}");
      print("District Name: ${district['name']}");
    }

    // 🔽 Sub-District
    final subDistrict = auth.selectedSubDistrict;
    if (subDistrict != null && subDistrict.isNotEmpty) {
      print("SubDistrict ID: ${subDistrict['_id']}");
      print("SubDistrict Name: ${subDistrict['name']}");
    }

    // 🔽 City
    final city = auth.selectedCity;
    if (city != null && city.isNotEmpty) {
      print("City ID: ${city['_id']}");
      print("City Name: ${city['name']}");
    }
    String State = state==null? "": state['name'];
    String Jilla = district==null? "": district['name'];
    String taluka = subDistrict==null? "": subDistrict['name'];
    String city_name = city==null? "": city['name'];



    final map = {

      "shopName": shopCtrl.text.toString(),
      "contactNumber": mobileNoCtrl.text,
      "fullName": nameCtrl.text.toString(),
      "address": addressCtrl.text.toString(),
      "taluka": taluka,
      "jilla": Jilla,
      "city": city_name,
      "state": State
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
    final provider = Provider.of<ApiProvider>(context);
    //final dropDownKey = GlobalKey<DropdownSearchState>();

    //final auth = context.watch<AuthProvider>();
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


            /*  DropdownSearch<Map<String, dynamic>>(
                key: GlobalKey<DropdownSearchState>(),
                selectedItem: provider.selectedState,
                items: (String? filter, infiniteScrollProps) {
                  return provider.stateList;
                },
                itemAsString: (item) => item["name"] ?? "",
                compareFn: (item, selected) => item["_id"] == selected["_id"], // 👈 important
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Select State",
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 300),
                ),
                onChanged: (value) {
                  if (value != null) provider.setStateSelection(value);
                },
              ),
              const SizedBox(height: 12),

              /// DISTRICT
              DropdownSearch<Map<String, dynamic>>(
                key: GlobalKey<DropdownSearchState>(),
                selectedItem: provider.selectedDistrict,
                items: (String? filter, infiniteScrollProps) {
                  return provider.districtList;
                },
                itemAsString: (item) => item["name"] ?? "",
                compareFn: (item, selected) => item["_id"] == selected["_id"], // 👈 important

                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Select District",
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 300),
                ),
                onChanged: (value) {
                  if (value != null) provider.setDistrictSelection(value);
                },
              ),
              const SizedBox(height: 12),

              /// SUB-DISTRICT
              DropdownSearch<Map<String, dynamic>>(
                key: GlobalKey<DropdownSearchState>(),
                selectedItem: provider.selectedSubDistrict,
                items: (String? filter, infiniteScrollProps) {
                  return provider.subDistrictList;
                },
                itemAsString: (item) => item["name"] ?? "",
                compareFn: (item, selected) => item["_id"] == selected["_id"], // 👈 important

                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Select Sub-District",
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 300),
                ),
                onChanged: (value) {
                  if (value != null) provider.setSubDistrictSelection(value);
                },
              ),
              const SizedBox(height: 12),

              /// CITY
              DropdownSearch<Map<String, dynamic>>(
                key: GlobalKey<DropdownSearchState>(),
                selectedItem: provider.selectedCity,
                items: (String? filter, infiniteScrollProps) {
                  return provider.cityList;
                },
                itemAsString: (item) => item["name"] ?? "",
                compareFn: (item, selected) => item["_id"] == selected["_id"], // 👈 important

                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    labelText: "Select City",
                    border: OutlineInputBorder(),
                  ),
                ),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 300),
                ),
                onChanged: (value) {
                  if (value != null) provider.setCitySelection(value);
                },
              ),
*/



              Align(
                alignment: Alignment.centerLeft,
                child: Text("રાજ્ય",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
              /// ---- STATE ----
              DropdownButtonFormField<String>(
                value: provider.selectedStateId,
                items: provider.stateList
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem(
                    value: c['_id'], // ✅ sirf ID rakho
                    child: Text(c['name']),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  if (v != null) provider.setStateSelection(v);
                  _form.currentState!.validate(); // 👈 yeh line important

                },
                decoration: const InputDecoration(
                  hintText: 'State',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'રાજ્ય સિલેક્ટ કરો' : null,
              ),


              const SizedBox(height: 12),

              /// ---- DISTRICT ----
              Align(
                alignment: Alignment.centerLeft,
                child: Text("જિલ્લા",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),

              DropdownButtonFormField<String>(
                value: provider.selectedDistrictId,
                items: provider.districtList
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem(
                    value: c['_id'], // ✅ sirf ID rakho
                    child: Text(c['name']),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  if (v != null) provider.setDistrictSelection(v);
                  _form.currentState!.validate(); // 👈 yeh line important

                },
                decoration: const InputDecoration(
                  hintText: 'જિલ્લા',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'જિલ્લા સિલેક્ટ કરો' : null,
              ),

              const SizedBox(height: 12),

              /// ---- SUBDISTRICT ----
              Align(
                alignment: Alignment.centerLeft,
                child: Text("તાલુકા",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),

              /*DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedSubDistrict,
                items: provider.subDistrictList
                    .map<DropdownMenuItem<Map<String, dynamic>>>(
                      (sd) => DropdownMenuItem(
                    value: sd["_id"],
                    child: Text(sd['name'].toString()),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedSubDistrict = v;
                    selectedCity = null;
                  });
                  if (v != null) {
                    print("તાલુકા ID: ${v['_id']}, Name: ${v['name']}");
                    provider.getCities(v['_id']);
                    _form.currentState!.validate(); // 👈 yeh line important
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'તાલુકા',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'તાલુકા સિલેક્ટ કરો' : null,
              ),*/


              DropdownButtonFormField<String>(
                value: provider.selectedSubDistrictId,
                items: provider.subDistrictList
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem(
                    value: c['_id'], // ✅ sirf ID rakho
                    child: Text(c['name']),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                  if (v != null) provider.setSubDistrictSelection(v);
                  _form.currentState!.validate(); // 👈 yeh line important

                },
                decoration: const InputDecoration(
                  hintText: 'તાલુકા',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'તાલુકા સિલેક્ટ કરો' : null,
              ),

              const SizedBox(height: 12),

              /// ---- CITY ----

              Align(
                alignment: Alignment.centerLeft,
                child: Text("શહેર",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),

              /*DropdownButtonFormField<Map<String, dynamic>>(
                value: selectedCity,
                *//*items: provider.cityList
                    .map<DropdownMenuItem<Map<String, dynamic>>>(
                      (c) => DropdownMenuItem(
                    value: c['_id'],
                    child: Text(c['name'].toString()),
                  ),
                )
                    .toList(),*//*

                onChanged: (v) {
                  setState(() {
                    selectedCity = v;
                  });
                  if (v != null) {
                    print("શહેર ID: ${v['_id']}, Name: ${v['name']}");
                    _form.currentState!.validate(); // 👈 yeh line important

                  }
                },
                decoration: const InputDecoration(
                  hintText: 'શહેર',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'શહેર સિલેક્ટ કરો' : null,
              ),*/


              DropdownButtonFormField<String>(
                value: provider.selectedCityId,
                items: provider.cityList
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem(
                    value: c['_id'], // ✅ sirf ID rakho
                    child: Text(c['name']),
                  ),
                )
                    .toList(),
                onChanged: (v) {
                 // setState(() => selectedCityId = v);
                  if (v != null) provider.setCitySelection(v);
                  _form.currentState!.validate(); // 👈 yeh line important

                },
                decoration: const InputDecoration(
                  hintText: 'શહેર',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'શહેર સિલેક્ટ કરો' : null,
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
              AppButton(text: 'Register', onTap: _onRegister, loading: provider.isLoading),//auth.loading),
            ]),
          ),
        ),
      ),
    );
  }
}
