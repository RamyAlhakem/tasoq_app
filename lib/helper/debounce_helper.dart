import 'dart:async';
import 'dart:ui';

class DebounceHelper {
  final int milliseconds;
  Timer? _timer;
  bool _isReady = true;

  DebounceHelper({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void runOnce(VoidCallback action) {
    if (!_isReady) return;
    _isReady = false;
    action();
    _timer = Timer(Duration(milliseconds: milliseconds), () => _isReady = true);
  }

  void dispose() {
    _timer?.cancel();
  }
}
