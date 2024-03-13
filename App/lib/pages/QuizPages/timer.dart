import 'dart:async';

class SimpleTimer {
  Timer? _timer;
  int _remainingSeconds; // Die verbleibende Zeit in Sekunden
  final Function(String, bool)
      onDisplayUpdate; // Callback für die Aktualisierung der Anzeige und ob die Zeit negativ ist

  SimpleTimer({required this.onDisplayUpdate, int minutes = 0, int seconds = 0})
      : _remainingSeconds = minutes * 60 + seconds {
    // Initialisiere die Anzeige mit der Startzeit
    _updateDisplay();
  }

  void _updateDisplay() {
    int minutes = _remainingSeconds.abs() ~/ 60;
    int seconds = _remainingSeconds.abs() % 60;
    // Füge ein Minuszeichen hinzu, wenn die verbleibende Zeit negativ ist
    String formattedTime =
        '${_remainingSeconds < 0 ? "-" : ""}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    // Rufe den Callback mit der formatierten Zeit und einem Flag auf, ob die Zeit negativ ist
    onDisplayUpdate(formattedTime, _remainingSeconds < 0);
  }

  void startTimer() {
    _timer?.cancel(); // Bestehenden Timer abbrechen, falls vorhanden
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _remainingSeconds--;
      _updateDisplay();
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }
}
