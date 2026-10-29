/// The complete traditional Panchanga (5 limbs) + auspicious & inauspicious Muhurthas.
class PanchangaData {
  final DateTime date;
  final String placeName;
  final String vara;
  final int varaIndex; // 0=Sunday, 1=Monday ... 6=Saturday
  final String tithi;
  final int tithiIndex; // 0-29
  final String paksha;
  final double tithiProgress; // 0.0 - 100.0%
  final String nakshatra;
  final int nakshatraIndex;
  final int nakshatraPada;
  final String yoga;
  final int yogaIndex;
  final String karana;
  final int karanaIndex;
  final String sunSign;
  final String moonSign;
  final DateTime sunrise;
  final DateTime sunset;
  final (DateTime, DateTime) rahuKalam;
  final (DateTime, DateTime) yamagandam;
  final (DateTime, DateTime) gulikaKalam;
  final (DateTime, DateTime) abhijitMuhurtham;
  final (DateTime, DateTime) brahmaMuhurtham;

  const PanchangaData({
    required this.date,
    required this.placeName,
    required this.vara,
    required this.varaIndex,
    required this.tithi,
    required this.tithiIndex,
    required this.paksha,
    required this.tithiProgress,
    required this.nakshatra,
    required this.nakshatraIndex,
    required this.nakshatraPada,
    required this.yoga,
    required this.yogaIndex,
    required this.karana,
    required this.karanaIndex,
    required this.sunSign,
    required this.moonSign,
    required this.sunrise,
    required this.sunset,
    required this.rahuKalam,
    required this.yamagandam,
    required this.gulikaKalam,
    required this.abhijitMuhurtham,
    required this.brahmaMuhurtham,
  });
}
