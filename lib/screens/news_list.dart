import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsList = [
      {
        "title": "આ એપ નો મુખ્ય हेतु છે",
        "message":
        "નાના નાના વેપારીઓ ને સાયા ભાવ ની રોજ ની માહિતી મળતી રહે\n\n"
            "આ એપ મોટા વેપારી ત્યાં ડીલર એજન્ટ ને માલ લેવા માટે મદદ રૂપ નથી પણ માલ વેચવા માટે જરૂર મદદરૂપ થશે\n\n"
            "જે પણ મોટા વેપારી ભાઈઓ ને માલ વેચવો હોય તો અમે જરૂર મદદરૂપ થાશુ\n\n"
            "મોટા વેપારી ડીલર એજન્ટ ભાઈઓને ને જે પણ માલ વેચવો હોય તો 88250 27403 ઉપર અમારો સંપર્ક કરવો",
      },
      {
        "title": "મહાદેવ ટ્રેડિંગ મા આપનું સ્વાગત છે",
        "message":
        "આ એપ ના માધ્યમ થી રોજ ના ભાવ જાણવા મળશે",
      },
      {
        "title": "માલ ખરીદવો જરૂરી નથી",
        "message":
        "એપ ના માધ્યમ થી રોજ ના ભાવ ની માહિતી આપણે સમયસર મળતી રહેશે\n\n"
            "GST ને લગતા સમાચારো આપણે સમયસર મળતા રહેશે",
      },
      {
        "title": "અમારી પાસેથી માલ ખરીદી કરતા પહેલા સુચના",
        "message":
        "અમારી પાસેથી માલ ખરીદી કરતા પહેલા સુચના",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("સમાચાર"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.yellow[600],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: newsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final news = newsList[index];
          return NewsCard(
            title: news["title"]!,
            message: news["message"]!,
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String message;

  const NewsCard({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.yellow[600],
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
