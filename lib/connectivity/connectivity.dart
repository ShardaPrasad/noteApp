import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ConnectivityController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();

    _connectivity.onConnectivityChanged.listen((results) {
      _updateStatus(results);
    });

    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    isConnected.value = !results.contains(ConnectivityResult.none);
  }
}

