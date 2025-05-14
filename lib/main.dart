import 'package:adapty_test/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'adapty_premium/purchases_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(PurchasesController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Adapty Purchase Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
