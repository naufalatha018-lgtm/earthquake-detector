import 'dart:async';
import 'package:flutter/material.dart';

class GempaProvider extends ChangeNotifier {
  Map<String, String> gempa = {
    "tanggal": "-",
    "jam": "-",
    "magnitude": "-",
    "kedalaman": "-",
    "wilayah": "-",
  };

  List<double> magnitudes = [1, 2, 3, 2, 4, 3, 5];

  Timer? _timer;

  Object? get logs => null;

  void startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _updateGempa();
    });
  }

  void _updateGempa() {
    final now = DateTime.now();

    gempa = {
      "tanggal": "${now.day}/${now.month}/${now.year}",
      "jam": "${now.hour}:${now.minute}:${now.second}",
      "magnitude": (2 + (now.second % 5)).toString(),
      "kedalaman": "${10 + now.second} km",
      "wilayah": "Dummy Area",
    };

    magnitudes.add(double.parse(gempa["magnitude"]!));
    if (magnitudes.length > 10) {
      magnitudes.removeAt(0);
    }

    notifyListeners();
  }

  void stopSimulation() {}
}
