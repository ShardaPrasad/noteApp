import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../routes/app_routes.dart';
import '../service/auth_service.dart';

class SplashController extends GetxController {
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    _checkSession();
  }

  void _checkSession() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_authService.isUserLoggedIn()) {
      Get.offAllNamed(AppRoutes.notes);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
