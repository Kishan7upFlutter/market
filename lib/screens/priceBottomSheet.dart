import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
        title: Row(
          children: [
            Image.asset(
              "assets/logo.png", // ← yaha apna logo rakho
              height: 30,
            ),
            const SizedBox(width: 8),
            const Text("મહાદેવ", style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold),),
          ],
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
      body: Column(
        children: [
          Align(alignment: Alignment.center,child: Text("ભાવ યાદી",style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.bold)),),
          Container(
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            child: const Row(
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
      ),
    );
  }
}


