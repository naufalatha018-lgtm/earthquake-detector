import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GempaProvider extends ChangeNotifier {
  
  // 🟢 SUPABASE CLIENT
  final SupabaseClient _supabase = Supabase.instance.client;
  
  // 🎧 REALTIME SUBSCRIPTION
  RealtimeChannel? _subscription;

  // 🔥 STATE
  double magnitude = 0;
  double distanceKm = 0;
  bool statusTrigger = false;

  Map<String, String> gempa = {
    "tanggal": "-",
    "jam": "-",
    "magnitude": "-",
    "kedalaman": "-",
    "wilayah": "-",
  };

  List<double> magnitudes = [];
  List<Map<String, String>> logs = [];

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  // 🚀 START LISTENING (SUPABASE REALTIME)
  void startListening() {
    print("🟢 Starting Supabase Realtime...");

    _subscription = _supabase
        .channel('public:earthquake_data')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'earthquake_data',
          callback: (payload) {
            print("🔥 SUPABASE DATA MASUK: ${payload.newRecord}");
            _handleDataUpdate(payload.newRecord);
          },
        )
        .subscribe();

    // 📥 LOAD DATA AWAL
    _loadInitialData();
  }

  // 📥 LOAD DATA AWAL DARI SUPABASE
  Future<void> _loadInitialData() async {
    try {
      final response = await _supabase
          .from('earthquake_data')
          .select()
          .order('id', ascending: false)
          .limit(1)
          .single();

      print("📊 Initial data loaded: $response");
      _handleDataUpdate(response);
    } catch (e) {
      print("❌ Error loading initial data: $e");
    }
  }

  // 🔄 HANDLE DATA UPDATE
  void _handleDataUpdate(Map<String, dynamic> data) {
    // ✅ PARSE DATA
    magnitude = (data['magnitude'] as num?)?.toDouble() ?? 0.0;
    distanceKm = (data['distance_km'] as num?)?.toDouble() ?? 0.0;
    statusTrigger = data['status_trigger'] as bool? ?? false;

    // 🕒 WAKTU
    final now = DateTime.now();
    final tanggal =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    final jam =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // 🔄 UPDATE UI DATA
    gempa = {
      "tanggal": tanggal,
      "jam": jam,
      "magnitude": magnitude.toStringAsFixed(1),
      "kedalaman": "$distanceKm km",
      "wilayah": statusTrigger ? "⚠️ BAHAYA GEMPA" : "AMAN",
    };

    // 📊 UPDATE CHART
    magnitudes.add(magnitude);
    if (magnitudes.length > 10) {
      magnitudes.removeAt(0);
    }

    // 📜 UPDATE LOGS
    logs.insert(0, {
      "tanggal": tanggal,
      "jam": jam,
      "magnitude": magnitude.toStringAsFixed(1),
      "kedalaman": "$distanceKm km",
      "wilayah": statusTrigger ? "BAHAYA GEMPA" : "AMAN",
    });

    if (logs.length > 20) {
      logs.removeLast();
    }

    // 🚨 ALARM - HANYA GUNAKAN status_trigger (SINGLE SOURCE OF TRUTH)
    if (statusTrigger) {
      _playAlarm();
    }

    notifyListeners();
  }

  // 🔊 PLAY ALARM
  Future<void> _playAlarm() async {
    if (_isPlaying) return;

    _isPlaying = true;
    await _player.play(AssetSource('sounds/alarm.mp3'));

    Future.delayed(const Duration(seconds: 3), () {
      _isPlaying = false;
    });
  }

  // 🔕 STOP SIREN (dipanggil dari UI)
  Future<void> stopSiren() async {
    try {
      await _supabase
          .from('device_control')
          .update({'siren_active': false})
          .eq('id', 1);
      
      print("✅ Siren stopped");
    } catch (e) {
      print("❌ Error stopping siren: $e");
    }
  }

  @override
  void dispose() {
    _subscription?.unsubscribe();
    _player.dispose();
    super.dispose();
  }
}