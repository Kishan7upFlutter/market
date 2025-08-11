import 'package:flutter/material.dart';
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
      body: Column(children: [
        Container(
          height: topHeight,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.yellow[600], borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            const CircleAvatar(
                radius: 36, backgroundImage: AssetImage('assets/profile.png')),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(userName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),

                  ]),
            ),
            const SizedBox(width: 10),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.notifications_none,size: 25,)),
          ]),
        ),
       // const SizedBox(height: 12),

        Container(


          margin: EdgeInsets.symmetric(horizontal: 10),
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
                child: Center(child: Text("News",style: TextStyle(color: Colors.white),)),

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
                    "Live News , Live News , Live News",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              )

            ],
          ),
        ),
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
                  Expanded(
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
