import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetController extends GetxController with WidgetsBindingObserver {
  InternetController({InternetConnection? checker})
      : _checker = checker ?? InternetConnection.createInstance();

  final RxBool isConnected = true.obs;
  final RxBool isChecking = false.obs;
  final InternetConnection _checker;
  StreamSubscription<InternetStatus>? _subscription;
  Timer? _offlineTimer;
  int _revision = 0;
  bool _closed = false;

  static InternetController get to => Get.find<InternetController>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _subscription = _checker.onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        setConnected();
      } else {
        _scheduleOffline();
      }
    });
    retryConnection();
  }

  // Ignore short drops and cancel stale offline events when connectivity returns.
  void _scheduleOffline() {
    if (_closed) return;
    final revision = ++_revision;
    _offlineTimer?.cancel();
    _offlineTimer = Timer(const Duration(seconds: 2), () {
      if (!_closed && revision == _revision) isConnected.value = false;
    });
  }

  Future<void> retryConnection() async {
    if (_closed || isChecking.value) return;
    isChecking.value = true;
    final revision = ++_revision;
    _offlineTimer?.cancel();
    try {
      final connected = await _checker.hasInternetAccess
          .timeout(const Duration(seconds: 8));
      if (!_closed && revision == _revision) {
        if (connected) {
          setConnected();
        } else {
          _scheduleOffline();
        }
      }
    } catch (_) {
      if (!_closed && revision == _revision) _scheduleOffline();
    } finally {
      if (!_closed) isChecking.value = false;
    }
  }

  void setConnected() {
    if (_closed) return;
    ++_revision;
    _offlineTimer?.cancel();
    isConnected.value = true;
  }

  // A failed API host does not necessarily mean the device is offline.
  void setDisconnected() => unawaited(retryConnection());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) retryConnection();
  }

  @override
  void onClose() {
    _closed = true;
    ++_revision;
    _offlineTimer?.cancel();
    _subscription?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
