import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:market/core/api_client.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:market/widgets/two_card_item.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String searchQuery = '';
  List<dynamic> filteredItems = [];

 // List<dynamic> colorList = [];
  Color bgColor = Colors.yellow[600]!; // default

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    final dash = context.read<ApiProvider>();

     await dash.getCategories();
     await dash.getNewsChannel();
     await dash.getBannerList();
     await dash.getColors();
    await dash.getNumberList();


    if(dash.bannerList.isNotEmpty)
       {

         ArtSweetAlert.show(
             context: context,
             artDialogArgs: ArtDialogArgs(
                 title: "Banner!",
                 text:  dash.bannerList.first["text"] ?? "",
                 customColumns: [
                   Container(
                     margin: EdgeInsets.only(
                         bottom: 12.0
                     ),
                     child: Image.network(
                      dash.bannerList.first["image"],
                       fit: BoxFit.cover,
                      /* loadingBuilder: (context, child, loadingProgress) {
                         if (loadingProgress == null) return child; // ✅ image loaded

                         return SizedBox(
                           height: 150,
                           child: Center(
                             child: Column(
                               children: [
                                 CircularProgressIndicator(
                                   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // ✅ static color
                                   backgroundColor: Colors.grey[300],
                                   //valueColor: Animation.fromValueListenable(transformer: ),
                                   value: loadingProgress.expectedTotalBytes != null
                                       ? loadingProgress.cumulativeBytesLoaded /
                                       loadingProgress.expectedTotalBytes!
                                       : null, // agar size na mile toh indeterminate spinner
                                 ),
                                 SizedBox(height: 20.h,),
                                 Center(child: Text("Loading banner...!"),)
                               ],
                             ),
                           ),
                         );
                       },*/
                       errorBuilder: (context, error, stackTrace) {
                         return const Icon(
                           Icons.broken_image,
                           size: 80,
                           color: Colors.grey,
                         );
                       },
                     ),

                   )
                 ]
             )
         );

       }

    setState(() {
      filteredItems = dash.categories;
      //colorList = dash.colorList;
    });
  }



  void _showBannerDialog(Map<String, dynamic> banner) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(

                  ApiClient.bannerImgBasePath+banner["image"],
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),

              // Text
              Text(
                banner["text"] ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Status
              Text(
                "Status: ${banner["status"] == true ? "Active" : "Inactive"}",
                style: TextStyle(
                  fontSize: 14,
                  color: banner["status"] == true ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  void _filterItems(String query) {
    final dash = context.read<ApiProvider>();
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredItems = dash.categories;
      } else {
        filteredItems = dash.categories
            .where((item) =>
            item['name']
                .toString()
                .toLowerCase()
                .replaceAll(" ", "") // title ke spaces hatao
                .contains(query.toLowerCase().trim())) // query ke spaces hatao
            .toList();
      }
    });
  }

  Future<void> _refreshDashboard() async {
    final dash = context.read<ApiProvider>();

    // final dash = context.read<DashboardProvider>();
   // await dash.fetchDashboardList();
    setState(() {
      filteredItems = dash.categories;
      /*if (searchQuery.isNotEmpty) {
        _filterItems(searchQuery);
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = context.read<ApiProvider>();
    final dash = context.watch<DashboardProvider>();
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?['name']?.toString() ?? 'User';
    final topHeight = MediaQuery.of(context).size.height * 0.20;
    //print(colorList[0]["color"]);
    //Color bgColor = Color(int.parse(colorList[0]["color"].substring(1), radix: 16) + 0xFF000000);
   // Color? bgColor = apiProvider.colorList.isNotEmpty?Color(int.parse(colorList.first["color"].substring(1), radix: 16) + 0xFF000000):Colors.yellow[600];
    if (apiProvider.colorList.isNotEmpty) {
      final colorHex = apiProvider.colorList.first["color"] ?? "#FFFF00"; // fallback
      bgColor = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
    }

    return apiProvider.isLoading?Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black,),),):Scaffold(
      backgroundColor: bgColor,
      key: _scaffoldKey,

      drawer: Drawer(

        backgroundColor: bgColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color:  /*Colors.yellow[600]*/bgColor),
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
                      style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "(નરેશભાઈ)",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.message_rounded,color: Colors.white,),
              title:  Text("વોટ્સએપમાં ભાવ જોવા માટે",style: TextStyle(color: Colors.white),),
              onTap: () async  {
                //Navigator.pushNamed(context, '/whatsappListScreen');
               // final apiprovider = context.read<ApiProvider>();
                //apiprovider.getNumberList();

                if (apiProvider.numberList.isNotEmpty) {
                  final phoneNumber = apiProvider.numberList.first["number"] ?? "1234567890"; // fallback
                  //bgColor = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
                  final String whatsappUrl = "https://wa.me/$phoneNumber"; // WhatsApp ka URL scheme

                  final Uri whatsappUri = Uri.parse(whatsappUrl);

                  if (await canLaunchUrl(whatsappUri)) {
                    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Could not launch WhatsApp for $phoneNumber';
                  }
                }

                //final String phoneNumber = apiprovider.numberList.first["number"]; // number string, e.g. "919876543210"


              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf,color: Colors.white,),
              title: const Text("PDF",style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pushNamed(context, '/pdfScreen');

              },
            ),

            ListTile(
              leading: const Icon(Icons.branding_watermark,color: Colors.white,),
              title: const Text("અમારી શાખાઓ",style: TextStyle(color: Colors.white),),
              onTap: () {

                Navigator.pushNamed(context, '/branchScreen');
              },
            ),
            ListTile(
              leading: const Icon(Icons.maps_home_work_outlined,color: Colors.white,),
              title: const Text("બેંકની માહિતી",style: TextStyle(color: Colors.white),),
              onTap: () {

                Navigator.pushNamed(context, '/bankScreen');
              },
            ),
            ListTile(
              leading:  Icon(Icons.call,color: Colors.white,),
              title: const Text("સંપર્ક",style: TextStyle(color: Colors.white),),
              onTap: () async {
                if (apiProvider.numberList.isNotEmpty) {
                  final phoneNumber = apiProvider.numberList.first["number"] ?? "1234567890"; // fallback
                  final Uri callUri = Uri(scheme: 'tel', path: phoneNumber); // apna number
                  if (await canLaunchUrl(callUri)) {
                    await launchUrl(callUri);
                  } else {
                    throw 'Could not launch $callUri';
                  }
              }
                //Navigator.pushNamed(context, '/numberScreen');
//whatsappListScreen
              //
              },
            ),
            ListTile(
              leading:  Icon(Icons.exit_to_app,color: Colors.white,),
              title: const Text("બહાર નીકળો",style: TextStyle(color: Colors.white),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // 👈 Drawer (hamburger) icon color
        ),
        backgroundColor: bgColor,
        titleSpacing: 0,
        title: Container(
          margin: EdgeInsets.only(left: 10.w),
          child: Row(
            children: [
              Image.asset(
                "assets/logo.png", // ← yaha apna logo rakho
                height: 42.h,
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Text("મહાદેવ", style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),),
                  const Text("(નરેશભાઈ)", style: TextStyle(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),),

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
            icon: const Icon(Icons.notifications,color: Colors.white,),
            onPressed: () {
              Navigator.pushNamed(context, '/notificationScreen');

            },
          ),
        ],
      ),
      body: Column(children: [
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

        /* Container(
          //height: topHeight,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.yellow[600], borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const CircleAvatar(
                radius: 32, backgroundImage: AssetImage('assets/logo.png')),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("MAHADEV",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28)),

                  ]),
            ),
            const SizedBox(width: 10),

            const CircleAvatar(
                radius: 24, backgroundImage: AssetImage('assets/news.png')),

            const SizedBox(width: 10),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications_none,size: 42,)),
          ]),
        ),*/
       // const SizedBox(height: 12),

       /* Container(


          margin: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(

            //border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: Row(
           // crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 30,
                //margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.black,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomLeft: Radius.circular(30),),
                    border: Border.all(color: Colors.black)

                ),
                child: Center(child: Text("News",style: TextStyle(color: Color(0xFFFFBB00)),)),

              ),

              //SizedBox(width: 10,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(3),
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    border: Border.all(color: Colors.black),
                  ),
                  alignment: Alignment.centerLeft, // vertical center + left align
                  //margin: EdgeInsets.only(left: 5),
                  child: Text(
                    "News...Live...News...Live...News...live...",

                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )

            ],
          ),
        ),*/
        // White rounded container
        const SizedBox(height: 12),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: dash.loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                children: [
                  // Search Field
                  /*TextField(

                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      filled: true, // background color enable karega
                      fillColor: Colors.grey[200], // background color set karo
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                     *//* border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),*//*
                    ),
                  ),*/

                  /*TextField(
                    onChanged: _filterItems,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true, // 👈 ye lagane se TextField compact ho jata hai
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,  // 👈 vertical padding कम करो
                        horizontal: 16,
                      ),
                    ),
                    style: const TextStyle(fontSize: 16), // font भी छोटा कर सकते हो
                  ),*/


                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(15.r))
                    ),

                    height: 45, // 👈 jitni height chahiye
                    child: TextField(
                      onChanged: _filterItems,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search, size: 18),
                        border: OutlineInputBorder(
                         // borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Swipe to Refresh + List
                  /*Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshDashboard,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: (filteredItems.length / 2).ceil(),
                        itemBuilder: (c, i) {
                          final leftIdx = i * 2;
                          final rightIdx = leftIdx + 1;
                          final left = filteredItems[leftIdx];
                          final right =
                          rightIdx < filteredItems.length ? filteredItems[rightIdx] : null;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TwoCardItem(left: left, right: right),
                          );
                        },
                      ),
                    ),
                  ),*/
                  //filteredItems.isNotEmpty?
                  apiProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filteredItems.isEmpty
                      ? const Center(child: Text("ડેટા નથી...."))
                      :
                  Expanded(
                    child:
                    LiquidPullToRefresh(
                      onRefresh: _refreshDashboard, // वही function use होगा
                      color: bgColor,     // liquid का color
                      backgroundColor: Colors.white, // loader का background
                      height: 120,                   // liquid की ऊँचाई
                      animSpeedFactor: 2,            // animation की speed
                      showChildOpacityTransition: true, // smooth effect
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: (filteredItems.length / 2).ceil(),
                        itemBuilder: (c, i) {
                          final leftIdx = i * 2;
                          final rightIdx = leftIdx + 1;
                          final left = filteredItems[leftIdx];
                          final right = rightIdx < filteredItems.length ? filteredItems[rightIdx] : null;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TwoCardItem(left: left, right: right),
                          );
                        },
                      ),
                    ),
                  )
                      //:Center(child: Text("ડેટા નથી....",style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.bold,color: Colors.grey),),),

                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
