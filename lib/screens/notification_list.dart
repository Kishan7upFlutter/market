import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
