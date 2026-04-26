import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  Stream<Map<String, dynamic>> getCombinedDataStream() {
    // We want to listen to multiple paths or the root and filter.
    // For simplicity in this demo, let's listen to the root if it's small,
    // or combine specific streams.
    return _db.ref().onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return {};
      
      // Convert Map<dynamic, dynamic> to Map<String, dynamic>
      return data.map((key, value) => MapEntry(key.toString(), value));
    });
  }

  // Helper to update device status if needed
  Future<void> updateDeviceStatus(bool isOnline) async {
    await _db.ref('demo_device_status').update({
      'is_online': isOnline,
    });
  }
}
