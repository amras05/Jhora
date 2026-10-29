import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/birth_data.dart';

/// Persists user-entered birth profiles locally; charts are regenerated on demand.
class SavedHoroscopeService {
  SavedHoroscopeService._();
  static const _key = 'saved_horoscopes_v1';
  static Future<List<BirthData>> load() async {
    final raw =
        (await SharedPreferences.getInstance()).getStringList(_key) ?? const [];
    final profiles = <BirthData>[];
    for (final item in raw) {
      try {
        profiles
            .add(BirthData.fromJson(jsonDecode(item) as Map<String, dynamic>));
      } catch (_) {}
    }
    return profiles;
  }

  static Future<bool> save(BirthData birth) async {
    final profiles = await load();
    final index =
        profiles.indexWhere((item) => _identity(item) == _identity(birth));
    if (index < 0) {
      profiles.add(birth);
    } else {
      profiles[index] = birth;
    }
    return _write(profiles);
  }

  static Future<bool> remove(BirthData birth) async {
    final profiles = await load();
    profiles.removeWhere((item) => _identity(item) == _identity(birth));
    return _write(profiles);
  }

  static String _identity(BirthData birth) =>
      '${birth.name}|${birth.dateTime.toIso8601String()}|${birth.latitude}|${birth.longitude}';
  static Future<bool> _write(List<BirthData> profiles) async =>
      (await SharedPreferences.getInstance()).setStringList(
          _key, profiles.map((item) => jsonEncode(item.toJson())).toList());
}
