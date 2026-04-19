/// Represents a single snapshot from /demo_environment/earthquake_data
class EarthquakeData {
  final double magnitude;
  final double distanceKm;
  final bool statusTrigger;
  final DateTime timestamp;

  const EarthquakeData({
    required this.magnitude,
    required this.distanceKm,
    required this.statusTrigger,
    required this.timestamp,
  });

  /// Parse from Firebase RTDB map
  factory EarthquakeData.fromMap(Map<dynamic, dynamic> map) {
    return EarthquakeData(
      magnitude: (map['magnitude'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (map['distance_km'] as num?)?.toDouble() ?? 0.0,
      statusTrigger: map['status_trigger'] as bool? ?? false,
      timestamp: DateTime.now(),
    );
  }

  /// Safe demo fallback
  factory EarthquakeData.calm() => EarthquakeData(
        magnitude: 1.2,
        distanceKm: 85.0,
        statusTrigger: false,
        timestamp: DateTime.now(),
      );

  /// Danger demo state
  factory EarthquakeData.danger() => EarthquakeData(
        magnitude: 5.8,
        distanceKm: 12.0,
        statusTrigger: true,
        timestamp: DateTime.now(),
      );

  EarthquakeData copyWith({
    double? magnitude,
    double? distanceKm,
    bool? statusTrigger,
    DateTime? timestamp,
  }) {
    return EarthquakeData(
      magnitude: magnitude ?? this.magnitude,
      distanceKm: distanceKm ?? this.distanceKm,
      statusTrigger: statusTrigger ?? this.statusTrigger,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'EarthquakeData(mag=$magnitude, dist=$distanceKm km, trigger=$statusTrigger)';
}
