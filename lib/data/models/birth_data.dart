/// Model representing birth details entered by the user.
class BirthData {
  final String name;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
  final double timezone; // hours offset from UTC
  final String placeName;

  const BirthData({
    required this.name,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.placeName,
  });

  /// Julian Day Number calculation (Meeus algorithm)
  double get julianDay {
    int y = dateTime.year;
    int m = dateTime.month;
    double d = dateTime.day +
        (dateTime.hour + dateTime.minute / 60.0 + dateTime.second / 3600.0 - timezone) / 24.0;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    int a = (y / 100).floor();
    int b = 2 - a + (a / 4).floor();

    return (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        d +
        b -
        1524.5;
  }

  /// Local Sidereal Time in degrees
  double get localSiderealTime {
    double jd = julianDay;
    double t = (jd - 2451545.0) / 36525.0;

    // Greenwich Mean Sidereal Time in degrees
    double gmst = 280.46061837 +
        360.98564736629 * (jd - 2451545.0) +
        0.000387933 * t * t -
        t * t * t / 38710000.0;

    gmst = gmst % 360.0;
    if (gmst < 0) gmst += 360.0;

    // Local Sidereal Time
    double lst = gmst + longitude;
    lst = lst % 360.0;
    if (lst < 0) lst += 360.0;

    return lst;
  }

  BirthData copyWith({
    String? name,
    DateTime? dateTime,
    double? latitude,
    double? longitude,
    double? timezone,
    String? placeName,
  }) {
    return BirthData(
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      placeName: placeName ?? this.placeName,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'dateTime': dateTime.toIso8601String(),
    'latitude': latitude,
    'longitude': longitude,
    'timezone': timezone,
    'placeName': placeName,
  };

  factory BirthData.fromJson(Map<String, dynamic> json) => BirthData(
    name: json['name'] as String,
    dateTime: DateTime.parse(json['dateTime'] as String),
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
    timezone: (json['timezone'] as num).toDouble(),
    placeName: json['placeName'] as String,
  );
}
