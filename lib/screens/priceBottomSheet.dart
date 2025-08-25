import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marquee/marquee.dart';


class PriceBottomSheet extends StatefulWidget {
  const PriceBottomSheet({super.key});

  @override
  State<PriceBottomSheet> createState() => _PriceBottomSheetState();
}

class _PriceBottomSheetState extends State<PriceBottomSheet> {

  final List<Map<String, dynamic>> data = [
    {"name": "વિમલ 5 વાળી", "price": "121"},
    {"name": "વિમલ 5 વાળી બાયકી (52 પેકેટ )", "price": "6250"},
    {"name": "વિમલ 5 વાળી બોરો (208 પેકેટ )", "price": "25100"},
    {"name": "વિમલ દસ વાળી", "price": "174.50"},
    {"name": "વિમલ દસ વાળી બાયકી (52 પેકેટ )", "price": "9074"},
    {"name": "વિમલ દસ વાળી બોરો ( પેકેટ 208)", "price": "36200"},
    {"name": "વિમલ વીસ વાળી પેકેટ", "price": "170.50"},
    {"name": "વિમલ વીસ વાળી બાયકી ( 22 પેકેટ )", "price": "3751"},
    {"name": "વિમલ વીસ વાળી બોરો ભાવ", "price": "37450"},
    {"name": "વિમલ 50 વાળી", "price": "434"},
    {"name": "વિમલ 50 વાળી 20 પેકેટ ( 1 સિકો )", "price": "8680"},
    {"name": "વિમલ 50 વાળી કાકુન (100 પેકેટ )", "price": "43400"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     /* appBar: AppBar(
        title: const Text("ભાવ યાદી"),
      ),*/
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
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.branding_watermark),
              title: const Text("અમારી શાખાઓ"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.maps_home_work_outlined),
              title: const Text("બેંકની માહિતી"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text("સંપર્ક"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("બહાર નીકળો"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/dashboard');
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
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [

            Container(
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
                      text: "Breaking News: Flutter Drawer + AppBar + Marquee Example Running Successfully 🚀",
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
                        "વસ્તુ વિગત",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Center(
                      child: Text(
                        "રકમ (₹)",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white),
                      ),
                    ),
                  ),
                  numeric: true,
                ),
              ],
              rows: data.map((row) {
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

    /*  Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("નામ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                Text("ભાવ",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 1),
                  ),
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item['name'],
                            style: const TextStyle(fontSize: 14)),
                      ),
                      Text(
                        item['price'],
                        style: TextStyle(
                          fontSize: 14,
                          color: item['price'].contains(".")
                              ? Colors.black
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),*/
    );
  }
}


