import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/presentation/providers/api_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {


  List<dynamic> samacharList = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotificationDetails();
  }


  Future<void> _initNotificationDetails() async {
    final apiprovider = context.read<ApiProvider>();
    await apiprovider.getSamachar();
    setState(() {
      samacharList = apiprovider.samcharList;
      isLoading = false;
    });
  }


  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
 /*   final List<Map<String, String>> newsList = [
      {
        "title": "આ એપ નો મુખ્ય हेतु છે",
        "thumbnail": "https://dummyimage.com/150x150/000/fff.png",

      },
      {
        "title": "મહાદેવ ટ્રેડિંગ મા આપનું સ્વાગત છે",
        "thumbnail": "https://dummyimage.com/150x150/000/fff.png",

      },
      {
        "title": "માલ ખરીદવો જરૂરી નથી",
        "thumbnail": "https://dummyimage.com/150x150/000/fff.png",

      },
      {
        "title": "અમારી પાસેથી માલ ખરીદી કરતા પહેલા સુચના",
        "thumbnail": "https://dummyimage.com/150x150/000/fff.png",
      },
    ];*/

    final apiprovider = context.read<ApiProvider>();


    return Scaffold(
      appBar: AppBar(
        title:  Text("સમાચાર",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.sp),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.yellow[600],
      ),
      body: apiprovider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : samacharList.isEmpty
          ? const Center(child: Text("ડેટા નથી...."))
          :ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: samacharList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final news = samacharList[index];
          return InkWell(
            onTap: (){
              _launchUrl(Uri.parse(news["link"]!));
            },
            child: NewsCard(
              title: news["file"]!,
              mediaUrl: "https://dummyimage.com/150x150/000/fff.png",
            ),
          );
        },
      ),
    );
  }
}




class NewsCard extends StatelessWidget {
  final String title;
  final String mediaUrl;

  const NewsCard({
    super.key,
    required this.title,
    required this.mediaUrl,
  });

  bool isImage(String url) {
    return url.endsWith(".jpg") ||
        url.endsWith(".jpeg") ||
        url.endsWith(".png") ||
        url.endsWith(".gif");
  }

  bool isVideo(String url) {
    return url.endsWith(".mp4") || url.endsWith(".mov") || url.endsWith(".avi");
  }

  @override
  Widget build(BuildContext context) {
    Widget mediaWidget;

    if (isImage(mediaUrl)) {
      // ✅ Image
      mediaWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          mediaUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }  else {
      // ✅ Default placeholder
      mediaWidget = Container(
        height: 180,
        color: Colors.grey,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, size: 50, color: Colors.white),
      );
    }

    return Card(
      color: Colors.yellow[600],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mediaWidget,
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


