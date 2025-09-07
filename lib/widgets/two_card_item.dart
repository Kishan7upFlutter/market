import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../presentation/screens/priceBottomSheet.dart';

class TwoCardItem extends StatelessWidget {
  final Map<String, dynamic> left;
  final Map<String, dynamic>? right;

  const TwoCardItem({super.key, required this.left, this.right});

  Widget _card(BuildContext c, Map<String, dynamic> item) {
    final bool shouldFlash = item["flash"] == true;
    final card = Card(
      elevation: 10,
      shadowColor: Colors.black,
      color: Color(
        int.parse(
          item["color"].toString().replaceFirst("#", "0xff"),
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding:  EdgeInsets.only(top: 18,bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              item['name']?.toString() ?? '',
              style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.white,fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.push(
          c,
          MaterialPageRoute(
            builder: (_) =>  PriceBottomSheet(id: item["_id"].toString()),
          ),
        );
      },
      child: shouldFlash
          ? _FlashingWrapper(child: card) // 👈 अगर flash true है तो blinking
          : card,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _card(context, left)),
      const SizedBox(width: 12),
      Expanded(child: right != null ? _card(context, right!) : const SizedBox()),
    ]);
    return Container();
  }
}

/// 🔥 Wrapper Widget for Flash Effect
class _FlashingWrapper extends StatefulWidget {
  final Widget child;
  const _FlashingWrapper({required this.child});

  @override
  State<_FlashingWrapper> createState() => _FlashingWrapperState();
}

class _FlashingWrapperState extends State<_FlashingWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
