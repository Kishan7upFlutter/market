import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:provider/provider.dart';

class BrachListScreen extends StatefulWidget {
  const BrachListScreen({super.key});

  @override
  State<BrachListScreen> createState() => _BrachListScreenState();
}

class _BrachListScreenState extends State<BrachListScreen> {
  List<dynamic> branchList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotificationDetails();
  }


  Future<void> _initNotificationDetails() async {
    final apiprovider = context.read<ApiProvider>();
    await apiprovider.getBranchList();
    setState(() {
      branchList = apiprovider.branchList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiprovider = context.read<ApiProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("અમારી શાખાઓ")),
      body: RefreshIndicator(
        onRefresh: _initNotificationDetails,
        child: apiprovider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : branchList.isEmpty
            ? const Center(child: Text("ડેટા નથી...."))
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: branchList.length,
          itemBuilder: (context, index) {
            final item = branchList[index];

            return NotificationCard(
              title: item["status"]==true?"Active":"Not Active",
              message: item["address"] ?? "",
            );

          },
        ),
      ),
    );


  }
}




class NotificationCard extends StatelessWidget {
  final String title;
  final String message;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style:  TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style:  TextStyle(
                color: Colors.black,
                fontSize: 15.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
