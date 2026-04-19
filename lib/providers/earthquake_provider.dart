import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/earthquake_data.dart';
import '../utils/risk_engine.dart';

enum ConnectionStatus { connecting, online, offline }

class EarthquakeProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────
  EarthquakeData _data = EarthquakeData.calm();
  ConnectionStatus _connection = ConnectionStatus.connecting;
  bool _sirenActive = false;
  bool _isDemoMode = true;
  DateTime? _lastUpdated;

  final List<double> _magnitudeHistory = [];
  static const int _historyLength = 20;

  Timer? _simulationTimer;
  Timer? _connectionTimer;
  final _rand = Random();

  // ── Audio ──────────────────────────────────────────────
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _audioReady = false;

  // ── Getters ───────────────────────────────────────────
  EarthquakeData get data => _data;
  ConnectionStatus get connection => _connection;
  bool get sirenActive => _sirenActive;
  bool get isDemoMode => _isDemoMode;
  DateTime? get lastUpdated => _lastUpdated;
  List<double> get magnitudeHistory => List.unmodifiable(_magnitudeHistory);
  RiskResult get risk => RiskEngine.classify(_data.magnitude, _data.distanceKm);

  String get lastUpdatedLabel {
    if (_lastUpdated == null) return '—';
    final diff = DateTime.now().difference(_lastUpdated!);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s lalu';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    return '${diff.inHours}h lalu';
  }

  EarthquakeProvider() {
    _initAudio();
    _startSimulation();
  }

  // ── Audio Initialisation ──────────────────────────────
  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      _audioReady = true;
      debugPrint('[SeismoGuard Audio] AudioPlayer ready — asset: sounds/alarm.mp3');
    } catch (e) {
      _audioReady = false;
      debugPrint('[SeismoGuard Audio] WARNING Init failed: $e');
    }
  }

  Future<void> _playSiren() async {
    if (!_audioReady) {
      debugPrint('[SeismoGuard Audio] WARNING Audio not ready, retrying init...');
      await _initAudio();
      if (!_audioReady) {
        debugPrint('[SeismoGuard Audio] FALLBACK Audio unavailable, siren suppressed');
        return;
      }
    }
    try {
      if (_audioPlayer.state == PlayerState.playing) return;
      await _audioPlayer.play(AssetSource('sounds/alarm.mp3'));
      debugPrint('[SeismoGuard Audio] PLAY siren started');
    } catch (e) {
      debugPrint('[SeismoGuard Audio] ERROR Play failed: $e');
    }
  }

  Future<void> _stopSiren() async {
    try {
      await _audioPlayer.stop();
      debugPrint('[SeismoGuard Audio] STOP siren stopped');
    } catch (e) {
      debugPrint('[SeismoGuard Audio] ERROR Stop failed: $e');
    }
  }

  // ── Demo Simulation ───────────────────────────────────
  void _startSimulation() {
    _connection = ConnectionStatus.connecting;
    _connectionTimer = Timer(const Duration(milliseconds: 1200), () {
      _connection = ConnectionStatus.online;
      notifyListeners();
    });
    _pushReading(EarthquakeData.calm());
    _simulationTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _simulateTick();
    });
  }

  void _simulateTick() {
    final isEvent = _rand.nextDouble() < 0.10;
    double mag;
    double dist;
    bool trigger;
    if (isEvent) {
      mag = 3.5 + _rand.nextDouble() * 3.5;
      dist = 5.0 + _rand.nextDouble() * 60.0;
      trigger = mag > 4.5;
    } else {
      mag = 0.5 + _rand.nextDouble() * 2.0;
      dist = 40.0 + _rand.nextDouble() * 200.0;
      trigger = false;
    }
    _pushReading(EarthquakeData(
      magnitude: double.parse(mag.toStringAsFixed(1)),
      distanceKm: double.parse(dist.toStringAsFixed(1)),
      statusTrigger: trigger,
      timestamp: DateTime.now(),
    ));
  }

  void _pushReading(EarthquakeData reading) {
    _data = reading;
    _lastUpdated = reading.timestamp;
    _magnitudeHistory.add(reading.magnitude);
    if (_magnitudeHistory.length > _historyLength) {
      _magnitudeHistory.removeAt(0);
    }
    if (reading.statusTrigger && !_sirenActive) {
      _sirenActive = true;
      _playSiren();
    } else if (!reading.statusTrigger && _sirenActive) {
      _sirenActive = false;
      _stopSiren();
    }
    notifyListeners();
  }

  // ── Siren Control ──────────────────────────────────────
  void toggleSiren() {
    _sirenActive = !_sirenActive;
    if (_sirenActive) {
      _playSiren();
    } else {
      _stopSiren();
    }
    notifyListeners();
  }

  void deactivateSiren() {
    _sirenActive = false;
    _stopSiren();
    notifyListeners();
  }

  // ── Manual Demo Controls ───────────────────────────────
  void simulateDangerEvent() {
    _pushReading(EarthquakeData.danger());
  }

  void simulateCalmState() {
    _stopSiren();
    _pushReading(EarthquakeData.calm());
  }

  // ── Connection Simulation ──────────────────────────────
  void simulateOffline() {
    _connection = ConnectionStatus.offline;
    _simulationTimer?.cancel();
    notifyListeners();
  }

  void simulateReconnect() {
    _connection = ConnectionStatus.connecting;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      _connection = ConnectionStatus.online;
      _startSimulation();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    _connectionTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
