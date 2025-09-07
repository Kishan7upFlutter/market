import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:provider/provider.dart';

class BankListScreen extends StatefulWidget {
  const BankListScreen({super.key});

  @override
  State<BankListScreen> createState() => _BankListScreenState();
}

class _BankListScreenState extends State<BankListScreen> {
  List<dynamic> bankList = [];
  bool isLoading = false;
  Color bgColor = Colors.yellow[600]!; // default

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotificationDetails();
  }


  Future<void> _initNotificationDetails() async {
    final apiprovider = context.read<ApiProvider>();
    await apiprovider.getBankList();
    await apiprovider.getColors();

    setState(() {
      bankList = apiprovider.bankList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiprovider = context.read<ApiProvider>();
    if (apiprovider.colorList.isNotEmpty) {
      final colorHex = apiprovider.colorList.first["color"] ?? "#FFFF00"; // fallback
      bgColor = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    }
    return Scaffold(
     // appBar: AppBar(title: const Text("બેંકની માહિતી")),
      appBar: AppBar(
          backgroundColor: bgColor,
          iconTheme:  IconThemeData(
            color: Colors.white, // 👈 leading (back/menu) icon color
          ),
          title:  Text("બેંકની માહિતી",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      body: RefreshIndicator(
        onRefresh: _initNotificationDetails,
        child: apiprovider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : bankList.isEmpty
            ? const Center(child: Text("ડેટા નથી...."))
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: bankList.length,
          itemBuilder: (context, index) {
            final item = bankList[index];

           /* return NotificationCard(
              title: item["name"] ?? "",
              message: item["accountNumber"] ?? "",
            );*/

           return Card(
              color:bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bank : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["name"] ?? "",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Account : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["accountNumber"] ?? "",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "IFSC : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["ifsc"] ?? "",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "City : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["city"] ?? "",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Branch : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["branch"] ?? "",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["status"]==true?"Active":"Not Active",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Description : ",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SelectableText(
                          item["description"] ?? "",
                          style:  TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );

          },
        ),
      ),
    );


  }
}




