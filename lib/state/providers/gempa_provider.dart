import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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

  Timer? _timer;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  // 🚀 START SIMULATION
  void startSimulation() {
  stopSimulation();

  if (isDemo) {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _updateGempa();
    });
    } else {
    // nanti untuk API (sementara kosong)
    }
  }

  // 🛑 STOP SIMULATION (biar aman)
  void stopSimulation() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _playAlarm() async {
  if (_isPlaying) return;

  _isPlaying = true;
  await _player.play(AssetSource('sounds/alarm.mp3'));

  Future.delayed(const Duration(seconds: 3), () {
    _isPlaying = false;
  });
}

  // 🔄 UPDATE DATA (DEMO MODE)
  void _updateGempa() {
    final now = DateTime.now();

    final dummyWilayah = [
      "Kab. Bandung, Jawa Barat",
      "Jakarta Selatan",
      "Yogyakarta",
      "Surabaya",
      "Padang, Sumatera Barat"
    ];

    final wilayah = dummyWilayah[now.second % dummyWilayah.length];

    final magnitude = (3 + (now.second % 5)).toDouble();

    if (magnitude >= 5) {
      _playAlarm();
    }

    gempa = {
      "tanggal": "${now.day}/${now.month}/${now.year}",
      "jam": "${now.hour}:${now.minute}:${now.second}",
      "magnitude": magnitude.toStringAsFixed(1),
      "kedalaman": "${10 + now.second} km",
      "wilayah": wilayah,
    };

    magnitudes.add(magnitude);
    if (magnitudes.length > 10) {
      magnitudes.removeAt(0);
    }

    notifyListeners();
  }

  @override
  void dispose() {
    stopSimulation();
    super.dispose();
  }
}
