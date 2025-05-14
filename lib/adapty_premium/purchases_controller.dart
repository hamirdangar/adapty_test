import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:get/get.dart';
import '../home_screen.dart';
import 'adapty_key.dart';
import 'purchases_observer.dart';

class PurchasesController extends GetxController {
  final PurchasesObserver _observer = PurchasesObserver();

  Rx<AdaptyPaywall?> paywall = Rx<AdaptyPaywall?>(null);
  RxList<AdaptyPaywallProduct> products = <AdaptyPaywallProduct>[].obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingRestore = false.obs;
  RxBool isLoadingPurchase = false.obs;
  RxBool isPurchase = false.obs;
  RxString error = ''.obs;
  Rx<AdaptyPaywallProduct?> selectedProduct = Rx<AdaptyPaywallProduct?>(null);


  /// Initialize Adapty and fetch paywall/products
  Future<void> initialize() async {
    isLoading.value = true;
    error.value = '';

    try {
      await _observer.initialize();
      final fetchedPaywall = await _observer.callGetPaywallForDefaultAudience(placementId);
      if (fetchedPaywall != null) {
        paywall.value = fetchedPaywall;
        final fetchedProducts = await _observer.callGetPaywallProducts(fetchedPaywall);
        if (fetchedProducts != null) {
          products.assignAll(fetchedProducts);
          selectedProduct.value = fetchedProducts.last;
        }
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Make a purchase for the selected product
  Future<void> buyPlan(AdaptyPaywallProduct product,bool item) async {
    isLoadingPurchase.value = true;
    error.value = '';

    try {
      final result = await _observer.callMakePurchase(product);
      if (result is AdaptyPurchaseResultSuccess) {
        final profile = result.profile;
        final hasPremium = profile.accessLevels['premium']?.isActive ?? false;
        if (hasPremium) {
          isPurchase.value = true;
          await hasActiveSubscription();
          if(item){
            Get.back();
          }else{
            Get.offAll(()=> HomeScreen());
          }
          Get.snackbar('Success', 'Purchase successful and premium access activated!');
        } else {
          Get.snackbar('Info', 'Purchase complete but no premium access found.');
        }
      } else if (result is AdaptyPurchaseResultUserCancelled) {
        Get.snackbar('Cancelled', 'Purchase was cancelled by the user.');
      } else if (result is AdaptyPurchaseResultPending) {
        Get.snackbar('Pending', 'Purchase is pending. Please wait...');
      } else {
        Get.snackbar('Error', 'Unknown purchase result.');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingPurchase.value = false;
    }
  }


  /// Restore previous purchases
  Future<void> restorePurchases() async {
    isLoadingRestore.value = true;
    error.value = '';

    try {
      final result = await _observer.callRestorePurchases();
      if (result?.accessLevels['premium']?.isActive ?? false) {
        Get.snackbar('Success', 'Restored and premium access active!');
      } else {
        Get.snackbar('Info', 'Restore completed but no premium access found.');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingRestore.value = false;
    }
  }

  /// Check if the user has an active premium subscription
  Future<bool> hasActiveSubscription() async {
    try {
      final profile = await Adapty().getProfile();
      final hasPremium = profile.accessLevels['premium']?.isActive ?? false;
      if(hasPremium){
        ///after purchase
      }
      return hasPremium;
    } catch (e) {
      error.value = e.toString();
      return false;
    }
  }

}
