import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/two_card_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String searchQuery = '';
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _initDashboard();
  }

  Future<void> _initDashboard() async {
    final dash = context.read<DashboardProvider>();
    await dash.checkAppVersionAndMaybeForce();
    if (dash.forceUpdate) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text('Update Required'),
          content: const Text('Please update the app to continue.'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
      return;
    }
    await dash.fetchDashboardList();
    setState(() {
      filteredItems = dash.items;
    });
  }

  void _filterItems(String query) {
    final dash = context.read<DashboardProvider>();
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredItems = dash.items;
      } else {
        filteredItems = dash.items
            .where((item) =>
            item['title']
                .toString()
                .toLowerCase()
                .replaceAll(" ", "") // title ke spaces hatao
                .contains(query.toLowerCase().trim())) // query ke spaces hatao
            .toList();
      }
    });
  }

  Future<void> _refreshDashboard() async {
    final dash = context.read<DashboardProvider>();
    await dash.fetchDashboardList();
    setState(() {
      filteredItems = dash.items;
      /*if (searchQuery.isNotEmpty) {
        _filterItems(searchQuery);
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();
    final auth = context.watch<AuthProvider>();
    final userName = auth.user?['name']?.toString() ?? 'User';
    final topHeight = MediaQuery.of(context).size.height * 0.20;

    return Scaffold(
      backgroundColor: Colors.yellow[600],
      key: _scaffoldKey,
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
                Navigator.pop(context);
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
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(children: [
        Container(
          color: Colors.black,
          height: 30,
          width: double.infinity,
          child: Marquee(
            text: "Breaking News: Flutter Drawer + AppBar + Marquee Example Running Successfully 🚀",
            style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.center,
            blankSpace: 50.0,
            velocity: 50.0,
            pauseAfterRound: const Duration(seconds: 3),
            startPadding: 20.0,
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
                  TextField(

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
                     /* border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),*/
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
                  Expanded(
                    child:
                    LiquidPullToRefresh(
                      onRefresh: _refreshDashboard, // वही function use होगा
                      color: Colors.yellow[600],     // liquid का color
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
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
