import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';

class SampleApiUi extends StatelessWidget {
  const SampleApiUi({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null
          ? Center(child: SelectableText("Error: ${provider.error}"))
          : provider.categories.isEmpty
          ? Center(
        child: ElevatedButton(
          onPressed: () => provider.getCategories(),
          child: const Text("Load Categories"),
        ),
      )
          : ListView.builder(
        itemCount: provider.categories.length,
        itemBuilder: (context, index) {
          final category = provider.categories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Color(
                int.parse(
                  category["color"].toString().replaceFirst("#", "0xff"),
                ),
              ),
            ),
            title: Text(category["name"].toString()),
            subtitle: Text("Order: ${category["order"]}"),
            trailing: Icon(
              category["status"] == true
                  ? Icons.check_circle
                  : Icons.cancel,
              color: category["status"] == true ? Colors.green : Colors.red,
            ),
          );
        },
      ),
    );
  }
}
