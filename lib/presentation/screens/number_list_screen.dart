import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NumberListScreen extends StatefulWidget {
  const NumberListScreen({super.key});

  @override
  State<NumberListScreen> createState() => _NumberListScreenState();
}

class _NumberListScreenState extends State<NumberListScreen> {
  List<dynamic> numberList = [];
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
    await apiprovider.getNumberList();
    await apiprovider.getColors();

    setState(() {
      numberList = apiprovider.numberList;
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
     // appBar: AppBar(title: const Text("સંપર્ક")),
      appBar: AppBar(
          backgroundColor: bgColor,
          iconTheme:  IconThemeData(
            color: Colors.white, // 👈 leading (back/menu) icon color
          ),
          title:  Text("સંપર્ક",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      body: RefreshIndicator(
        onRefresh: _initNotificationDetails,
        child: apiprovider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : numberList.isEmpty
            ? const Center(child: Text("ડેટા નથી...."))
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: numberList.length,
          itemBuilder: (context, index) {
            final item = numberList[index];

            return InkWell(
              onTap: () async {
                final Uri callUri = Uri(scheme: 'tel', path: item["number"]); // apna number
                if (await canLaunchUrl(callUri)) {
                await launchUrl(callUri);
                } else {
                throw 'Could not launch $callUri';
                }
              },
            /*  child: NotificationCard(
                title: item["number"] ?? "",
              ),*/
              child: Card(
                color:bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.call,color: Colors.white,),
                      SizedBox(width: 10.w,),
                      Text(
                        item["number"] ?? "",
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            );
            /*return Card(
              margin: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: 12),
              child: ListTile(
                leading: const Icon(Icons.notifications),
                title: Text(item["title"] ?? ""),
                subtitle: Text(item["description"] ?? ""),
                trailing: Text(
                  item["createdAt"]
                      ?.toString()
                      .substring(0, 10) ?? "",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            );*/
          },
        ),
      ),
    );


  }
}




class NotificationCard extends StatelessWidget {
  final String title;

  const NotificationCard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color:Colors.yellow[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.call),
            SizedBox(width: 10.w,),
            Text(
              title,
              style:  TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),


          ],
        ),
      ),
    );
  }
}
