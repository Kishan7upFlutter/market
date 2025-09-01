import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';


class PriceBottomSheet extends StatefulWidget {
  //const PriceBottomSheet(t, {super.key});
  final String id;

  const PriceBottomSheet({super.key,  required this.id});

  @override
  State<PriceBottomSheet> createState() => _PriceBottomSheetState();
}

class _PriceBottomSheetState extends State<PriceBottomSheet> {
  List<dynamic> productList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    final apiprovider = context.read<ApiProvider>();


    print("DASSSSS" + " CategoryID : "+widget.id.toString());
    await apiprovider.getNewsChannel();
    await apiprovider.getProduct(widget.id.toString());

    setState(() {
      productList = apiprovider.productList;
    });
  }


  @override
  Widget build(BuildContext context) {

    final apiProvider = context.read<ApiProvider>();

    return Scaffold(

      drawer: Drawer(
        backgroundColor: Colors.yellow[600],
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color:  Colors.yellow[600]),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo.png", // ← yaha apna logo rakho
                      height: 60,
                    ),
                    SizedBox(height: 10.h,),
                    Text(
                      "મહાદેવ",
                      style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(નરેશભાઈ)",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message_rounded),
              title: const Text("વોટ્સએપમાં ભાવ જોવા માટે"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text("PDF"),
              onTap: () {
                Navigator.pushNamed(context, '/pdfScreen');

              },
            ),

            ListTile(
              leading: const Icon(Icons.branding_watermark),
              title: const Text("અમારી શાખાઓ"),
              onTap: () {

                Navigator.pushNamed(context, '/branchScreen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.maps_home_work_outlined),
              title: const Text("બેંકની માહિતી"),
              onTap: () {

                Navigator.pushNamed(context, '/bankScreen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text("સંપર્ક"),
              onTap: () {

                Navigator.pushNamed(context, '/numberScreen');

              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("બહાર નીકળો"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.yellow[600],
        titleSpacing: 0,
        title: InkWell(
          onTap: (){
            Navigator.pushReplacementNamed(context, '/dashboard');
          },
          child: Row(
            children: [
              Image.asset(
                "assets/logo.png", // ← yaha apna logo rakho
                height: 42.h,
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Text("મહાદેવ", style: TextStyle(color: Colors.black, fontSize: 18,fontWeight: FontWeight.bold),),
                  const Text("(નરેશભાઈ)", style: TextStyle(color: Colors.black, fontSize: 15,fontWeight: FontWeight.bold),),

                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Image.asset("assets/news.png", height: 28), // new logo
            onPressed: () {
              Navigator.pushNamed(context, '/newsScreen');

            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationScreen');

            },
          ),
        ],
      ),
      body:
    RefreshIndicator(
    onRefresh: _initDashboard,
    child: apiProvider.isLoading
    ? const Center(child: CircularProgressIndicator())
        : productList.isEmpty
    ?  Center(child: Text("ડેટા નથી....",style: TextStyle(fontSize: 25.sp),))
        : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            apiProvider.isLoading==true?Container(): Container(
              color: Colors.black,
              height: 30,
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(width: 10.w,),
                  Text("સમાચાર :",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  SizedBox(width: 10.w,),
                  Expanded(
                    child: Marquee(
                      text: apiProvider.newsChannelList[0]['headline'].toString(),//"Breaking News: Flutter Drawer + AppBar + Marquee Example Running Successfully 🚀",
                      style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 12.sp),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      blankSpace: 50.0,
                      velocity: 50.0,
                      pauseAfterRound: const Duration(seconds: 3),
                      startPadding: 20.0,
                    ),
                  ),
                ],
              ),
            ),

            DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey),
              columnSpacing: 20,
              border: TableBorder.all(
                color: Colors.black,
                width: 1,
              ), // 👈 हर cell पर border
              columns: const [
                DataColumn(
                  label: Expanded(
                    child: Center(
                      child: Text(
                        "નામ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Center(
                      child: Text(
                        "ભાવ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows: productList.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        row["name"].toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    DataCell(
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          row["price"].toString(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    )
    );
  }
}


