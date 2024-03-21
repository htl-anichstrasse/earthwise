import 'dart:async';

// Class for a simple timer
class SimpleTimer {
  // Timer object
  Timer? _timer;

  // Remaining time in seconds
  int _remainingSeconds;

  // Callback for updating display and checking if time is negative
  final Function(String, bool) onDisplayUpdate;

  // Constructor for SimpleTimer
  SimpleTimer({required this.onDisplayUpdate, int minutes = 0, int seconds = 0})
      : _remainingSeconds = minutes * 60 + seconds {
    // Initialize display with start time
    _updateDisplay();
  }

  // Method to update the display with remaining time
  void _updateDisplay() {
    int minutes = _remainingSeconds.abs() ~/ 60;
    int seconds = _remainingSeconds.abs() % 60;
    // Add a minus sign if the remaining time is negative
    String formattedTime =
        '${_remainingSeconds < 0 ? "-" : ""}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    // Call the callback with the formatted time and a flag indicating if time is negative
    onDisplayUpdate(formattedTime, _remainingSeconds < 0);
  }

  // Method to start the timer
  void startTimer() {
    _timer?.cancel(); // Cancel existing timer if present
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      _updateDisplay();
    });
  }

  // Method to stop the timer
  void stopTimer() {
    _timer?.cancel();
  }
}
