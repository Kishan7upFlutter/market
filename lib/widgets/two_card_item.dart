import 'package:flutter/material.dart';

class TwoCardItem extends StatelessWidget {
  final Map<String, dynamic> left;
  final Map<String, dynamic>? right;

  const TwoCardItem({super.key, required this.left, this.right});

  Widget _card(BuildContext c, Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(item['title']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
         /* const SizedBox(height: 6),
          Text(item['subtitle']?.toString() ?? ''),
          const SizedBox(height: 8),
          Text('Value: ${item['value']?.toString() ?? '-'}', style: const TextStyle(color: Colors.black87)),*/
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _card(context, left)),
      const SizedBox(width: 12),
      Expanded(child: right != null ? _card(context, right!) : const SizedBox()),
    ]);
  }
}
