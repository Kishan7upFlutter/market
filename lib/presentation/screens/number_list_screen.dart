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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotificationDetails();
  }


  Future<void> _initNotificationDetails() async {
    final apiprovider = context.read<ApiProvider>();
    await apiprovider.getNumberList();
    setState(() {
      numberList = apiprovider.numberList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiprovider = context.read<ApiProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("સંપર્ક")),
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
              child: NotificationCard(
                title: item["number"] ?? "",
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

    /*return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.yellow[600],
      ),




      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: const [
            NotificationCard(
              title: "SHOP TIME",
              message:
              "બજાર ગામ ના વેપારીઓઓ ને જાણ માટે બપોરે ત્રણ વાગ્યા પહેલા ઓર્ડર આપેલો હશી તો તે દિશે માલ બુક થશી "
                  "ત્રણ વાગ્યા પછી ઓર્ડર આવશે તો બીજે દિશે માલ બુક થશી",
            ),
            SizedBox(height: 12),
            NotificationCard(
              title: "ORDER",
              message:
              "લોકલ હોલસેલ વેપારીઓને જાણ માટે હોલસેલ દુકાન ખોલવાનૉ સમય બપોરે 3 થી રાત ના 8.00 - બજાર ગામ ના "
                  "વેપારીઓમાટે વોટ્સએપ ઉપર 24 કલાક દુકાન ચાલુ રહેશે",
            ),
            SizedBox(height: 12),
            NotificationCard(
              title: "માલ ખરીદી પહેલા સુચના",
              message:
              "અમારી પાસ થી માલ ખરીદી કરતા પહેલા સુચના\n\n"
                  "આપના ઓર્ડર મુકબલ આપ જૅ ટ્રાન્સપોર્ટ મા કરોશ એમા બુક થશી જશે\n\n"
                  "બુક થયા પછી ટ્રાન્સપોર્ટ ની બિલટી અમને આપવાની જવાબદારી હોય છે\n"
                  "માલ બુક થયા પછી બિલટી આપ્યા પછી અમારી કોઈપણ પ્રકારની જવાબદારી રહેતી નથી\n\n"
                  "જેથી આવા ફિન અમને ન કરવા સરઝ છે\n\n"
                  "માલ નહી મળ્યો",
            ),
          ],
        ),
      ),
    );*/
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:  TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
           Icon(Icons.call)

          ],
        ),
      ),
    );
  }
}
