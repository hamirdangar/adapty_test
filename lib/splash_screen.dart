import 'package:adapty_test/adapty_premium/subscription_screen.dart';
import 'package:adapty_test/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'adapty_premium/purchases_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final controller = Get.find<PurchasesController>();

  @override
  void initState() {
    goNextScreen();
    super.initState();
  }

  Future<void> goNextScreen() async {
    await controller.initialize();
    await Future.delayed(Duration(seconds: 3));
    final hasAccess = await controller.hasActiveSubscription();
    if(hasAccess){
      Get.to(()=> HomeScreen());
    }else{
      Get.to(()=> SubscriptionScreen(item: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Splash Screen'),
          ],
        ),
      ),
    );
  }
}
