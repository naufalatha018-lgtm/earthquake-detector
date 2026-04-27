import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:seismo_guard/core/services/firebase_service.dart';

class GempaProvider extends ChangeNotifier {
  bool isDemo = true;
  Map<String, String> gempa = {
    "tanggal": "-",
    "jam": "-",
    "magnitude": "-",
    "kedalaman": "-",
    "wilayah": "-",
  };

  List<double> magnitudes = [1, 2, 3, 2, 4, 3, 5];
  List<Map<String, String>> logs = [];

  StreamSubscription? _firebaseSubscription;
  final FirebaseService _firebaseService = FirebaseService();
  final AudioPlayer _player = AudioPlayer();
  bool _isAutoSirenActive = false;
  bool _isManualSirenActive = false;
  Timer? _clockTimer;
  DateTime _currentTime = DateTime.now();

  String get currentTimeStr => 
      "${_currentTime.hour.toString().padLeft(2, '0')}:${_currentTime.minute.toString().padLeft(2, '0')}:${_currentTime.second.toString().padLeft(2, '0')}";

  bool get isSirenActive => _isAutoSirenActive || _isManualSirenActive;

  // 🚀 START SIMULATION (Now from Firebase)
  void startSimulation() {
    stopSimulation();

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentTime = DateTime.now();
      notifyListeners();
    });

    if (isDemo) {
      _firebaseSubscription = _firebaseService.getCombinedDataStream().listen((data) {
        _updateFromFirebase(data);
      });
    } else {
      // nanti untuk API (sementara kosong)
    }
  }

  // 🛑 STOP SIMULATION
  void stopSimulation() {
    _firebaseSubscription?.cancel();
    _firebaseSubscription = null;
    _clockTimer?.cancel();
    _clockTimer = null;
    setManualSiren(false);
  }

  void setManualSiren(bool active) {
    _isManualSirenActive = active;
    _updateSirenPlayer();
    notifyListeners();
  }

  Future<void> _updateSirenPlayer() async {
    if (isSirenActive) {
      if (_player.state != PlayerState.playing) {
        await _player.setReleaseMode(ReleaseMode.loop);
        await _player.play(AssetSource('sounds/alarm.mp3'));
      }
    } else {
      if (_player.state == PlayerState.playing) {
        await _player.stop();
      }
    }
  }

  // 🔄 UPDATE DATA (FROM FIREBASE)
  void _updateFromFirebase(Map<String, dynamic> data) {
    final environment = data['demo_environment'] as Map<dynamic, dynamic>?;
    final telemetry = data['demo_telemetry'] as Map<dynamic, dynamic>?;

    if (environment == null) return;

    final double magnitude = (environment['api_magnitude'] ?? 0).toDouble();
    final bool apiTriggerActive = environment['api_trigger_active'] ?? false;
    final bool sensorVibration = telemetry?['sensor_vibration_active'] ?? false;

    // 🔥 Update Auto Siren State
    _isAutoSirenActive = apiTriggerActive || sensorVibration || magnitude >= 5.0;
    _updateSirenPlayer();

    final now = DateTime.now();
    
    // For demo purposes, we still generate some fields that might not be in RTDB yet
    // but we use magnitude from Firebase.
    gempa = {
      "tanggal": "${now.day}/${now.month}/${now.year}",
      "jam": "${now.hour}:${now.minute}:${now.second}",
      "magnitude": magnitude.toStringAsFixed(1),
      "kedalaman": "10 km", // Mocked for now as it's not in the provided JSON
      "wilayah": "Demo Location", // Mocked
    };

    if (magnitude > 0) {
      magnitudes.add(magnitude);
      if (magnitudes.length > 10) {
        magnitudes.removeAt(0);
      }

      // Add to logs if it's a new "event" or just to show something in the logs for now
      // For this demo, let's just add it if magnitude changed significantly or just add it
      logs.insert(0, {...gempa});
      if (logs.length > 50) {
        logs.removeLast();
      }
    }

    notifyListeners();
  }

  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }
}