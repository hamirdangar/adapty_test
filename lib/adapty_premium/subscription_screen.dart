import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'purchases_controller.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool item;

  const SubscriptionScreen({super.key, required this.item});
  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final controller = Get.find<PurchasesController>();
  bool isClose = false;

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose a Plan")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text("Error: ${controller.error}"));
        }

        if (controller.products.isEmpty) {
          return const Center(child: Text("No plans available."));
        }

        return ListView.builder(
          itemCount: controller.products.length,
          itemBuilder: (_, index) {
            final product = controller.products[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(product.vendorProductId ?? 'Unnamed'),
                subtitle: Text(product.localizedDescription ?? ''),
                trailing: Text(product.price.localizedString ?? ''),
                onTap: () => controller.buyPlan(product,widget.item),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: controller.restorePurchases,
          child: const Text("Restore Purchases"),
        ),
      ),
    );
  }

}
