import 'dart:convert';
import 'package:http/http.dart' as http;
import 'city_database.dart';

/// 100% Offline-First Location Service with instant local database lookup and Open-Meteo CORS-friendly fallback.
class OsmLocationService {
  OsmLocationService._();

  static const String _openMeteoUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org/search';

  /// Search locations with instant offline local search priority.
  static Future<List<CityEntry>> searchLocation(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return const [];

    // 1. Instant offline search in built-in database (0ms latency, works completely offline)
    final localMatches = CityDatabase.search(cleanQuery);
    if (localMatches.isNotEmpty) {
      return localMatches;
    }

    // 2. Open-Meteo Geocoding API (Fast, Free, Open CORS for Web & Mobile, covers all world villages/taluks)
    try {
      final uri = Uri.parse('$_openMeteoUrl?name=${Uri.encodeComponent(cleanQuery)}&count=10&language=en&format=json');
      final response = await http.get(uri).timeout(const Duration(milliseconds: 2500));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          final List results = data['results'];
          final List<CityEntry> meteoResults = [];

          for (var item in results) {
            final lat = (item['latitude'] as num?)?.toDouble();
            final lon = (item['longitude'] as num?)?.toDouble();
            if (lat == null || lon == null) continue;

            final name = item['name']?.toString() ?? cleanQuery;
            final admin1 = item['admin1']?.toString() ?? '';
            final admin2 = item['admin2']?.toString() ?? '';
            final country = item['country']?.toString() ?? '';
            final countryCode = (item['country_code']?.toString() ?? '').toLowerCase();

            String state = admin1;
            if (admin2.isNotEmpty && admin1.isNotEmpty && admin2 != admin1) {
              state = '$admin2, $admin1';
            } else if (state.isEmpty) {
              state = admin2;
            }

            double tz = _estimateTimezone(lat, lon, countryCode);

            meteoResults.add(CityEntry(
              name: name,
              state: state,
              country: country.isNotEmpty ? country : countryCode.toUpperCase(),
              latitude: lat,
              longitude: lon,
              timezone: tz,
            ));
          }

          if (meteoResults.isNotEmpty) {
            return meteoResults;
          }
        }
      }
    } catch (_) {
      // Fallback to nominatim if open-meteo fails
    }

    // 3. Fallback to OpenStreetMap Nominatim
    try {
      final uri = Uri.parse(_nominatimUrl).replace(
        queryParameters: {
          'q': cleanQuery,
          'format': 'json',
          'addressdetails': '1',
          'limit': '8',
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'JhoraMobile/1.0 (VedicAstrologyApp; offline-first)',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(milliseconds: 2000));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<CityEntry> osmResults = [];

        for (var item in data) {
          final lat = double.tryParse(item['lat']?.toString() ?? '');
          final lon = double.tryParse(item['lon']?.toString() ?? '');
          if (lat == null || lon == null) continue;

          final address = item['address'] as Map<String, dynamic>? ?? {};
          final country = address['country']?.toString() ?? '';
          final state = address['state']?.toString() ?? address['region']?.toString() ?? '';
          final countryCode = (address['country_code']?.toString() ?? '').toLowerCase();

          String cityName = address['city']?.toString() ??
              address['town']?.toString() ??
              address['village']?.toString() ??
              address['municipality']?.toString() ??
              item['name']?.toString() ??
              cleanQuery;

          double tz = _estimateTimezone(lat, lon, countryCode);

          osmResults.add(CityEntry(
            name: cityName,
            state: state,
            country: country.isNotEmpty ? country : countryCode.toUpperCase(),
            latitude: lat,
            longitude: lon,
            timezone: tz,
          ));
        }

        if (osmResults.isNotEmpty) {
          return osmResults;
        }
      }
    } catch (_) {
      // Completely silent offline fallback
    }

    return localMatches;
  }

  /// Estimates UTC timezone offset based on coordinates.
  static double _estimateTimezone(double lat, double lon, String countryCode) {
    if (countryCode == 'in' || (lat >= 6 && lat <= 38 && lon >= 68 && lon <= 98 && countryCode != 'bd')) {
      return 5.5; // India (IST)
    }
    if (countryCode == 'np') return 5.75; // Nepal
    if (countryCode == 'lk') return 5.5;  // Sri Lanka
    if (countryCode == 'bd') return 6.0;  // Bangladesh
    if (countryCode == 'pk') return 5.0;  // Pakistan
    if (countryCode == 'ae') return 4.0;  // UAE
    if (countryCode == 'gb') return 0.0;  // UK
    if (countryCode == 'sg' || countryCode == 'my') return 8.0;
    if (countryCode == 'jp') return 9.0;
    if (countryCode == 'au') {
      if (lon > 140) return 10.0;
      if (lon > 125) return 9.5;
      return 8.0;
    }
    if (countryCode == 'us' || countryCode == 'ca') {
      if (lon > -75) return -5.0;
      if (lon > -90) return -6.0;
      if (lon > -105) return -7.0;
      return -8.0;
    }

    double rawTz = lon / 15.0;
    return (rawTz * 2).round() / 2.0;
  }
}
