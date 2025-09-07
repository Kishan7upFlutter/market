import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:market/presentation/screens/pdfviewer.dart';
import 'package:provider/provider.dart';

class PdfListScreen extends StatefulWidget {
  const PdfListScreen({super.key});

  @override
  State<PdfListScreen> createState() => _PdfListScreenState();
}

class _PdfListScreenState extends State<PdfListScreen> {
  List<dynamic> pdfList = [];
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
    await apiprovider.getPdfList();
    await apiprovider.getColors();

    setState(() {
      pdfList = apiprovider.pdfList;
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
     /* appBar: AppBar(title: const Text("PDF")),*/
      appBar: AppBar(
          backgroundColor: bgColor,
          iconTheme:  IconThemeData(
            color: Colors.white, // 👈 leading (back/menu) icon color
          ),
          title:  Text("PDF",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
      body: RefreshIndicator(
        onRefresh: _initNotificationDetails,
        child: apiprovider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : pdfList.isEmpty
            ? const Center(child: Text("ડેટા નથી...."))
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: pdfList.length,
          itemBuilder: (context, index) {
            final item = pdfList[index];
            String fileName = item["name"]=="" || item["name"]== null ?"":  item["name"].split("/").last;

            return InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerScreen(pdfUrl: item["name"]!),
                  ),
                );
              },
              child: Card(
                color:bgColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        fileName,
                        style:  TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.open_in_new,color: Colors.white,)

                    ],
                  ),
                ),
              )
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





