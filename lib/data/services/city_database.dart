/// Comprehensive offline city and town entry with coordinates, timezone, and multilingual aliases.
class CityEntry {
  final String name;
  final String state;
  final String country;
  final double latitude;
  final double longitude;
  final double timezone;
  final List<String> aliases;

  const CityEntry({
    required this.name,
    this.state = '',
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    this.aliases = const [],
  });

  String get displayName {
    if (state.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  @override
  String toString() => displayName;
}

/// 100% Offline Built-in Worldwide & Indian Cities Database
class CityDatabase {
  CityDatabase._();

  /// Search offline database by city name, state, aliases or multilingual tokens (case-insensitive)
  static List<CityEntry> search(String query) {
    if (query.trim().isEmpty) return const [];
    final q = query.trim().toLowerCase();

    final exact = <CityEntry>[];
    final prefix = <CityEntry>[];
    final contains = <CityEntry>[];

    for (final city in cities) {
      final n = city.name.toLowerCase();
      final s = city.state.toLowerCase();
      final c = city.country.toLowerCase();
      final aliasMatches = city.aliases.any((a) => a.toLowerCase().contains(q));
      final aliasExact = city.aliases.any((a) => a.toLowerCase() == q);
      final aliasPrefix = city.aliases.any((a) => a.toLowerCase().startsWith(q));

      // Substrings in slash-separated names like "Akividu / Akiveedu"
      final parts = n.split(RegExp(r'\s*/\s*'));
      final partExact = parts.any((p) => p == q);
      final partPrefix = parts.any((p) => p.startsWith(q));

      if (n == q || aliasExact || partExact) {
        exact.add(city);
      } else if (n.startsWith(q) || aliasPrefix || partPrefix) {
        prefix.add(city);
      } else if (n.contains(q) || s.contains(q) || c.contains(q) || aliasMatches) {
        contains.add(city);
      }
    }

    return [...exact, ...prefix, ...contains].take(25).toList();
  }

  static const List<CityEntry> cities = [
    // ══════════════════════════════════════════════════════════════════
    // ANDHRA PRADESH - WEST GODAVARI & ELURU
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Akividu', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5823, longitude: 81.3811, timezone: 5.5, aliases: ['Akiveedu', 'Akivīdu', 'ఆకివీడు']),
    CityEntry(name: 'Bhimavaram', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5449, longitude: 81.5212, timezone: 5.5, aliases: ['భీమవరం']),
    CityEntry(name: 'Tadepalligudem', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.8143, longitude: 81.5266, timezone: 5.5, aliases: ['T.P.Gudem', 'తాడేపల్లిగూడెం']),
    CityEntry(name: 'Tanuku', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.7570, longitude: 81.6823, timezone: 5.5, aliases: ['తణుకు']),
    CityEntry(name: 'Palakollu', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5167, longitude: 81.7333, timezone: 5.5, aliases: ['Palakol', 'పాలకొల్లు']),
    CityEntry(name: 'Narsapur', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.4333, longitude: 81.7000, timezone: 5.5, aliases: ['Narasapuram', 'నర్సాపురం']),
    CityEntry(name: 'Undi', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5936, longitude: 81.4589, timezone: 5.5, aliases: ['ఉండి']),
    CityEntry(name: 'Kalla', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.5361, longitude: 81.4289, timezone: 5.5, aliases: ['కళ్ళ']),
    CityEntry(name: 'Mogalthur', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.4250, longitude: 81.6000, timezone: 5.5, aliases: ['మొగల్తూరు']),
    CityEntry(name: 'Attili', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.6967, longitude: 81.6000, timezone: 5.5, aliases: ['అత్తిలి']),
    CityEntry(name: 'Penumantra', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.6333, longitude: 81.6333, timezone: 5.5, aliases: ['పెనుమంట్ర']),
    CityEntry(name: 'Penugonda', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.6667, longitude: 81.7333, timezone: 5.5, aliases: ['పెనుగొండ']),
    CityEntry(name: 'Achanta', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.6000, longitude: 81.8000, timezone: 5.5, aliases: ['ఆచంట']),
    CityEntry(name: 'Ganapavaram', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.7167, longitude: 81.4667, timezone: 5.5, aliases: ['గణపవరం']),
    CityEntry(name: 'Pentapadu', state: 'West Godavari, Andhra Pradesh', country: 'India', latitude: 16.8333, longitude: 81.5667, timezone: 5.5, aliases: ['పెంటపాడు']),
    CityEntry(name: 'Eluru', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 16.7107, longitude: 81.0952, timezone: 5.5, aliases: ['ఏలూరు']),
    CityEntry(name: 'Jangareddygudem', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 17.1264, longitude: 81.2941, timezone: 5.5, aliases: ['జంగారెడ్డిగూడెం']),
    CityEntry(name: 'Kovvur', state: 'East Godavari, Andhra Pradesh', country: 'India', latitude: 17.0167, longitude: 81.7333, timezone: 5.5, aliases: ['కొవ్వూరు']),
    CityEntry(name: 'Nidadavole', state: 'East Godavari, Andhra Pradesh', country: 'India', latitude: 16.9167, longitude: 81.6667, timezone: 5.5, aliases: ['నిడదవోలు']),
    CityEntry(name: 'Chintalapudi', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 17.0667, longitude: 80.9833, timezone: 5.5, aliases: ['చింతలపూడి']),
    CityEntry(name: 'Dwaraka Tirumala', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 16.9536, longitude: 81.2589, timezone: 5.5, aliases: ['ద్వారకా తిరుమల', 'Chinna Tirupati']),
    CityEntry(name: 'Polavaram', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 17.2500, longitude: 81.6333, timezone: 5.5, aliases: ['పోలవరం']),

    // ══════════════════════════════════════════════════════════════════
    // ANDHRA PRADESH - EAST GODAVARI, KAKINADA & KONASEEMA
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Rajahmundry', state: 'East Godavari, Andhra Pradesh', country: 'India', latitude: 17.0005, longitude: 81.8040, timezone: 5.5, aliases: ['Rajamahendravaram', 'రాజమండ్రి']),
    CityEntry(name: 'Kakinada', state: 'Kakinada, Andhra Pradesh', country: 'India', latitude: 16.9891, longitude: 82.2475, timezone: 5.5, aliases: ['కాకినాడ', 'Cocanada']),
    CityEntry(name: 'Amalapuram', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.5787, longitude: 82.0061, timezone: 5.5, aliases: ['అమలాపురం']),
    CityEntry(name: 'Ravulapalem', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.7500, longitude: 81.8500, timezone: 5.5, aliases: ['రావులపాలెం']),
    CityEntry(name: 'Mandapeta', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.8667, longitude: 81.9333, timezone: 5.5, aliases: ['మండపేట']),
    CityEntry(name: 'Ramachandrapuram', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.8333, longitude: 82.0167, timezone: 5.5, aliases: ['రామచంద్రపురం']),
    CityEntry(name: 'Razole', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.4833, longitude: 81.8333, timezone: 5.5, aliases: ['రాజోలు']),
    CityEntry(name: 'Kothapeta', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.7167, longitude: 81.9000, timezone: 5.5, aliases: ['కొత్తపేట']),
    CityEntry(name: 'Mummidivaram', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.6500, longitude: 82.1167, timezone: 5.5, aliases: ['ముమ్మిడివరం']),
    CityEntry(name: 'Samalkot', state: 'Kakinada, Andhra Pradesh', country: 'India', latitude: 17.0500, longitude: 82.1667, timezone: 5.5, aliases: ['Samalkota', 'సామర్లకోట']),
    CityEntry(name: 'Pithapuram', state: 'Kakinada, Andhra Pradesh', country: 'India', latitude: 17.1167, longitude: 82.2667, timezone: 5.5, aliases: ['పీఠాపురం']),
    CityEntry(name: 'Peddapuram', state: 'Kakinada, Andhra Pradesh', country: 'India', latitude: 17.0833, longitude: 82.1333, timezone: 5.5, aliases: ['పెద్దాపురం']),
    CityEntry(name: 'Tuni', state: 'Kakinada, Andhra Pradesh', country: 'India', latitude: 17.3500, longitude: 82.5500, timezone: 5.5, aliases: ['తుని']),
    CityEntry(name: 'Anaparthi', state: 'East Godavari, Andhra Pradesh', country: 'India', latitude: 16.9333, longitude: 81.9500, timezone: 5.5, aliases: ['అనపర్తి']),
    CityEntry(name: 'Draksharamam', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.7933, longitude: 82.0622, timezone: 5.5, aliases: ['ద్రాక్షారామం']),
    CityEntry(name: 'Antarvedi', state: 'Dr. B.R. Ambedkar Konaseema, Andhra Pradesh', country: 'India', latitude: 16.3333, longitude: 81.7333, timezone: 5.5, aliases: ['అంతర్వేది']),
    CityEntry(name: 'Rampachodavaram', state: 'Alluri Sitharama Raju, Andhra Pradesh', country: 'India', latitude: 17.4500, longitude: 81.7833, timezone: 5.5, aliases: ['రంపచోడవరం']),

    // ══════════════════════════════════════════════════════════════════
    // ANDHRA PRADESH - KRISHNA & NTR
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Vijayawada', state: 'NTR, Andhra Pradesh', country: 'India', latitude: 16.5062, longitude: 80.6480, timezone: 5.5, aliases: ['Bezawada', 'విజయవాడ']),
    CityEntry(name: 'Machilipatnam', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.1875, longitude: 81.1389, timezone: 5.5, aliases: ['Bandar', 'మచిలీపట్నం']),
    CityEntry(name: 'Gudivada', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.4410, longitude: 80.9926, timezone: 5.5, aliases: ['గుడివాడ']),
    CityEntry(name: 'Nuzvid', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 16.7850, longitude: 80.8461, timezone: 5.5, aliases: ['నూజివీడు']),
    CityEntry(name: 'Jaggaiahpet', state: 'NTR, Andhra Pradesh', country: 'India', latitude: 16.8928, longitude: 80.0975, timezone: 5.5, aliases: ['జగ్గయ్యపేట']),
    CityEntry(name: 'Nandigama', state: 'NTR, Andhra Pradesh', country: 'India', latitude: 16.7667, longitude: 80.3000, timezone: 5.5, aliases: ['నందిగామ']),
    CityEntry(name: 'Kaikaluru', state: 'Eluru, Andhra Pradesh', country: 'India', latitude: 16.5667, longitude: 81.2000, timezone: 5.5, aliases: ['కైకలూరు']),
    CityEntry(name: 'Vuyyuru', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.3667, longitude: 80.8500, timezone: 5.5, aliases: ['వుయ్యూరు']),
    CityEntry(name: 'Avanigadda', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.0167, longitude: 80.9167, timezone: 5.5, aliases: ['అవనిగడ్డ']),
    CityEntry(name: 'Gannavaram', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.5417, longitude: 80.8033, timezone: 5.5, aliases: ['గన్నవరం']),
    CityEntry(name: 'Tiruvuru', state: 'NTR, Andhra Pradesh', country: 'India', latitude: 17.1167, longitude: 80.6167, timezone: 5.5, aliases: ['తిరువూరు']),
    CityEntry(name: 'Pamarru', state: 'Krishna, Andhra Pradesh', country: 'India', latitude: 16.3333, longitude: 80.9667, timezone: 5.5, aliases: ['పామర్రు']),

    // ══════════════════════════════════════════════════════════════════
    // ANDHRA PRADESH - GUNTUR, PALNADU & BAPATLA
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Guntur', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.3067, longitude: 80.4365, timezone: 5.5, aliases: ['గుంటూరు']),
    CityEntry(name: 'Tenali', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.2430, longitude: 80.6400, timezone: 5.5, aliases: ['తెనాలి', 'Andhra Paris']),
    CityEntry(name: 'Narasaraopet', state: 'Palnadu, Andhra Pradesh', country: 'India', latitude: 16.2361, longitude: 80.0494, timezone: 5.5, aliases: ['నర్సరావుపేట']),
    CityEntry(name: 'Bapatla', state: 'Bapatla, Andhra Pradesh', country: 'India', latitude: 15.9042, longitude: 80.4678, timezone: 5.5, aliases: ['బాపట్ల']),
    CityEntry(name: 'Repalle', state: 'Bapatla, Andhra Pradesh', country: 'India', latitude: 16.0200, longitude: 80.8500, timezone: 5.5, aliases: ['రేపల్లె']),
    CityEntry(name: 'Mangalagiri', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.4300, longitude: 80.5700, timezone: 5.5, aliases: ['మంగళగిరి']),
    CityEntry(name: 'Sattenapalle', state: 'Palnadu, Andhra Pradesh', country: 'India', latitude: 16.3961, longitude: 80.1811, timezone: 5.5, aliases: ['సత్తెనపల్లి']),
    CityEntry(name: 'Chilakaluripet', state: 'Palnadu, Andhra Pradesh', country: 'India', latitude: 16.0892, longitude: 80.1672, timezone: 5.5, aliases: ['చిలకలూరిపేట']),
    CityEntry(name: 'Vinukonda', state: 'Palnadu, Andhra Pradesh', country: 'India', latitude: 16.0500, longitude: 79.7500, timezone: 5.5, aliases: ['వినుకొండ']),
    CityEntry(name: 'Macherla', state: 'Palnadu, Andhra Pradesh', country: 'India', latitude: 16.4800, longitude: 79.4300, timezone: 5.5, aliases: ['మాచర్ల']),
    CityEntry(name: 'Piduguralla', state: 'Palnadu, Andhra Pradesh', country: 'India', latitude: 16.4833, longitude: 79.8833, timezone: 5.5, aliases: ['పిడుగురాళ్ల', 'Lime City']),
    CityEntry(name: 'Amaravati', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.5735, longitude: 80.3575, timezone: 5.5, aliases: ['అమరావతి']),
    CityEntry(name: 'Ponnur', state: 'Guntur, Andhra Pradesh', country: 'India', latitude: 16.0667, longitude: 80.5667, timezone: 5.5, aliases: ['పొన్నూరు']),
    CityEntry(name: 'Chirala', state: 'Bapatla, Andhra Pradesh', country: 'India', latitude: 15.8246, longitude: 80.3522, timezone: 5.5, aliases: ['చీరాల']),

    // ══════════════════════════════════════════════════════════════════
    // ANDHRA PRADESH - VISAKHAPATNAM, ANAKAPALLI, VIZIANAGARAM, SRIKAKULAM
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Visakhapatnam', state: 'Visakhapatnam, Andhra Pradesh', country: 'India', latitude: 17.6868, longitude: 83.2185, timezone: 5.5, aliases: ['Vizag', 'Waltair', 'విశాఖపట్నం']),
    CityEntry(name: 'Anakapalli', state: 'Anakapalli, Andhra Pradesh', country: 'India', latitude: 17.6897, longitude: 83.0033, timezone: 5.5, aliases: ['అనకాపల్లి']),
    CityEntry(name: 'Vizianagaram', state: 'Vizianagaram, Andhra Pradesh', country: 'India', latitude: 18.1167, longitude: 83.4167, timezone: 5.5, aliases: ['విజయనగరం']),
    CityEntry(name: 'Srikakulam', state: 'Srikakulam, Andhra Pradesh', country: 'India', latitude: 18.2949, longitude: 83.8938, timezone: 5.5, aliases: ['శ్రీకాకుళం', 'Chicacole']),
    CityEntry(name: 'Bobbili', state: 'Vizianagaram, Andhra Pradesh', country: 'India', latitude: 18.5667, longitude: 83.3667, timezone: 5.5, aliases: ['బొబ్బిలి']),
    CityEntry(name: 'Parvathipuram', state: 'Parvathipuram Manyam, Andhra Pradesh', country: 'India', latitude: 18.7833, longitude: 83.4333, timezone: 5.5, aliases: ['పార్వతీపురం']),
    CityEntry(name: 'Salur', state: 'Parvathipuram Manyam, Andhra Pradesh', country: 'India', latitude: 18.5333, longitude: 83.2167, timezone: 5.5, aliases: ['సాలూరు']),
    CityEntry(name: 'Palakonda', state: 'Parvathipuram Manyam, Andhra Pradesh', country: 'India', latitude: 18.6000, longitude: 83.7500, timezone: 5.5, aliases: ['పాలకొండ']),
    CityEntry(name: 'Amadalavalasa', state: 'Srikakulam, Andhra Pradesh', country: 'India', latitude: 18.4167, longitude: 83.9000, timezone: 5.5, aliases: ['ఆమదాలవలస']),
    CityEntry(name: 'Rajam', state: 'Vizianagaram, Andhra Pradesh', country: 'India', latitude: 18.4500, longitude: 83.6667, timezone: 5.5, aliases: ['రాజాం']),
    CityEntry(name: 'Tekkali', state: 'Srikakulam, Andhra Pradesh', country: 'India', latitude: 18.6167, longitude: 84.2333, timezone: 5.5, aliases: ['టెక్కలి']),
    CityEntry(name: 'Ichchapuram', state: 'Srikakulam, Andhra Pradesh', country: 'India', latitude: 19.1167, longitude: 84.7000, timezone: 5.5, aliases: ['ఇచ్ఛాపురం']),
    CityEntry(name: 'Narsipatnam', state: 'Anakapalli, Andhra Pradesh', country: 'India', latitude: 17.6667, longitude: 82.6167, timezone: 5.5, aliases: ['నర్సీపట్నం']),
    CityEntry(name: 'Yellamanchili', state: 'Anakapalli, Andhra Pradesh', country: 'India', latitude: 17.5500, longitude: 82.8667, timezone: 5.5, aliases: ['ఎలమంచిలి']),
    CityEntry(name: 'Chodavaram', state: 'Anakapalli, Andhra Pradesh', country: 'India', latitude: 17.8333, longitude: 82.9500, timezone: 5.5, aliases: ['చోడవరం']),
    CityEntry(name: 'Araku Valley', state: 'Alluri Sitharama Raju, Andhra Pradesh', country: 'India', latitude: 18.3333, longitude: 82.8667, timezone: 5.5, aliases: ['అరకు', 'Araku']),
    CityEntry(name: 'Paderu', state: 'Alluri Sitharama Raju, Andhra Pradesh', country: 'India', latitude: 18.0833, longitude: 82.6667, timezone: 5.5, aliases: ['పాడేరు']),

    // ══════════════════════════════════════════════════════════════════
    // ANDHRA PRADESH - RAYALASEEMA (TIRUPATI, KADAPA, KURNOOL, ANANTAPUR, CHITTOOR, NELLORE, PRAKASAM)
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Tirupati', state: 'Tirupati, Andhra Pradesh', country: 'India', latitude: 13.6288, longitude: 79.4192, timezone: 5.5, aliases: ['తిరుపతి', 'Tirumala']),
    CityEntry(name: 'Nellore', state: 'SPSR Nellore, Andhra Pradesh', country: 'India', latitude: 14.4426, longitude: 79.9865, timezone: 5.5, aliases: ['నెల్లూరు', 'Simhapuri']),
    CityEntry(name: 'Ongole', state: 'Prakasam, Andhra Pradesh', country: 'India', latitude: 15.5057, longitude: 80.0499, timezone: 5.5, aliases: ['ఒంగోలు']),
    CityEntry(name: 'Kurnool', state: 'Kurnool, Andhra Pradesh', country: 'India', latitude: 15.8281, longitude: 78.0373, timezone: 5.5, aliases: ['కర్నూలు']),
    CityEntry(name: 'Kadapa', state: 'YSR Kadapa, Andhra Pradesh', country: 'India', latitude: 14.4673, longitude: 78.8242, timezone: 5.5, aliases: ['Cuddapah', 'కడప']),
    CityEntry(name: 'Anantapur', state: 'Anantapur, Andhra Pradesh', country: 'India', latitude: 14.6819, longitude: 77.6006, timezone: 5.5, aliases: ['అనంతపురం', 'Anantapuramu']),
    CityEntry(name: 'Chittoor', state: 'Chittoor, Andhra Pradesh', country: 'India', latitude: 13.2172, longitude: 79.1003, timezone: 5.5, aliases: ['చిత్తూరు']),
    CityEntry(name: 'Madanapalle', state: 'Annamayya, Andhra Pradesh', country: 'India', latitude: 13.5500, longitude: 78.5000, timezone: 5.5, aliases: ['మదనపల్లె']),
    CityEntry(name: 'Proddatur', state: 'YSR Kadapa, Andhra Pradesh', country: 'India', latitude: 14.7500, longitude: 78.5500, timezone: 5.5, aliases: ['ప్రొద్దుటూరు']),
    CityEntry(name: 'Nandyal', state: 'Nandyal, Andhra Pradesh', country: 'India', latitude: 15.4833, longitude: 78.4833, timezone: 5.5, aliases: ['నంద్యాల']),
    CityEntry(name: 'Adoni', state: 'Kurnool, Andhra Pradesh', country: 'India', latitude: 15.6300, longitude: 77.2700, timezone: 5.5, aliases: ['ఆదోని']),
    CityEntry(name: 'Hindupur', state: 'Sri Sathya Sai, Andhra Pradesh', country: 'India', latitude: 13.8294, longitude: 77.4917, timezone: 5.5, aliases: ['హిందూపురం']),
    CityEntry(name: 'Dharmavaram', state: 'Sri Sathya Sai, Andhra Pradesh', country: 'India', latitude: 14.4142, longitude: 77.7214, timezone: 5.5, aliases: ['ధర్మవరం']),
    CityEntry(name: 'Puttaparthi', state: 'Sri Sathya Sai, Andhra Pradesh', country: 'India', latitude: 14.1650, longitude: 77.8110, timezone: 5.5, aliases: ['పుట్టపర్తి', 'Prasanthi Nilayam']),
    CityEntry(name: 'Guntakal', state: 'Anantapur, Andhra Pradesh', country: 'India', latitude: 15.1667, longitude: 77.3833, timezone: 5.5, aliases: ['గుంతకల్లు']),
    CityEntry(name: 'Tadipatri', state: 'Anantapur, Andhra Pradesh', country: 'India', latitude: 14.9100, longitude: 78.0100, timezone: 5.5, aliases: ['తాడిపత్రి']),
    CityEntry(name: 'Rayachoti', state: 'Annamayya, Andhra Pradesh', country: 'India', latitude: 14.0500, longitude: 78.7500, timezone: 5.5, aliases: ['రాయచోటి']),
    CityEntry(name: 'Srikalahasti', state: 'Tirupati, Andhra Pradesh', country: 'India', latitude: 13.7500, longitude: 79.7000, timezone: 5.5, aliases: ['శ్రీకాళహస్తి', 'Kalahasti']),
    CityEntry(name: 'Puttur', state: 'Tirupati, Andhra Pradesh', country: 'India', latitude: 13.4333, longitude: 79.5500, timezone: 5.5, aliases: ['పుత్తూరు']),
    CityEntry(name: 'Nagari', state: 'Chittoor, Andhra Pradesh', country: 'India', latitude: 13.3333, longitude: 79.5833, timezone: 5.5, aliases: ['నగరి']),
    CityEntry(name: 'Palamaner', state: 'Chittoor, Andhra Pradesh', country: 'India', latitude: 13.2000, longitude: 78.7500, timezone: 5.5, aliases: ['పలమనేరు']),
    CityEntry(name: 'Kuppam', state: 'Chittoor, Andhra Pradesh', country: 'India', latitude: 12.7500, longitude: 78.3667, timezone: 5.5, aliases: ['కుప్పం']),
    CityEntry(name: 'Punganur', state: 'Chittoor, Andhra Pradesh', country: 'India', latitude: 13.3667, longitude: 78.5833, timezone: 5.5, aliases: ['పుంగనూరు']),
    CityEntry(name: 'Gudur', state: 'Tirupati, Andhra Pradesh', country: 'India', latitude: 14.1500, longitude: 79.8500, timezone: 5.5, aliases: ['గూడూరు']),
    CityEntry(name: 'Sullurpeta', state: 'Tirupati, Andhra Pradesh', country: 'India', latitude: 13.7000, longitude: 80.0167, timezone: 5.5, aliases: ['సూళ్లూరుపేట', 'Sriharikota', 'SHAR']),
    CityEntry(name: 'Kavali', state: 'SPSR Nellore, Andhra Pradesh', country: 'India', latitude: 14.9128, longitude: 79.9928, timezone: 5.5, aliases: ['కావలి']),
    CityEntry(name: 'Kandukur', state: 'SPSR Nellore, Andhra Pradesh', country: 'India', latitude: 15.2167, longitude: 79.9000, timezone: 5.5, aliases: ['కందుకూరు']),
    CityEntry(name: 'Markapur', state: 'Prakasam, Andhra Pradesh', country: 'India', latitude: 15.7333, longitude: 79.2833, timezone: 5.5, aliases: ['మార్కాపురం']),
    CityEntry(name: 'Giddalur', state: 'Prakasam, Andhra Pradesh', country: 'India', latitude: 15.3667, longitude: 78.9333, timezone: 5.5, aliases: ['గిద్దలూరు']),
    CityEntry(name: 'Dhone', state: 'Nandyal, Andhra Pradesh', country: 'India', latitude: 15.4200, longitude: 77.8700, timezone: 5.5, aliases: ['డోన్']),
    CityEntry(name: 'Yemmiganur', state: 'Kurnool, Andhra Pradesh', country: 'India', latitude: 15.7700, longitude: 77.4800, timezone: 5.5, aliases: ['ఎమ్మిగనూరు']),
    CityEntry(name: 'Allagadda', state: 'Nandyal, Andhra Pradesh', country: 'India', latitude: 15.1333, longitude: 78.5167, timezone: 5.5, aliases: ['ఆళ్లగడ్డ', 'Ahobilam']),
    CityEntry(name: 'Srisailam', state: 'Nandyal, Andhra Pradesh', country: 'India', latitude: 16.0740, longitude: 78.8680, timezone: 5.5, aliases: ['శ్రీశైలం', 'Srisaila Devasthanam']),
    CityEntry(name: 'Mahanandi', state: 'Nandyal, Andhra Pradesh', country: 'India', latitude: 15.4667, longitude: 78.6333, timezone: 5.5, aliases: ['మహానంది']),
    CityEntry(name: 'Pulivendula', state: 'YSR Kadapa, Andhra Pradesh', country: 'India', latitude: 14.4167, longitude: 78.2333, timezone: 5.5, aliases: ['పులివెందుల']),
    CityEntry(name: 'Jammalamadugu', state: 'YSR Kadapa, Andhra Pradesh', country: 'India', latitude: 14.8500, longitude: 78.3833, timezone: 5.5, aliases: ['జమ్మలమడుగు']),
    CityEntry(name: 'Rajampet', state: 'Annamayya, Andhra Pradesh', country: 'India', latitude: 14.1833, longitude: 79.1667, timezone: 5.5, aliases: ['రాజంపేట']),
    CityEntry(name: 'Badvel', state: 'YSR Kadapa, Andhra Pradesh', country: 'India', latitude: 14.7333, longitude: 79.0500, timezone: 5.5, aliases: ['బద్వేలు']),

    // ══════════════════════════════════════════════════════════════════
    // TELANGANA - ALL 33 DISTRICTS & KEY TOWNS
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Hyderabad', state: 'Telangana', country: 'India', latitude: 17.3850, longitude: 78.4867, timezone: 5.5, aliases: ['హైదరాబాద్', 'Bhagyanagar', 'Secunderabad', 'సికింద్రాబాద్']),
    CityEntry(name: 'Warangal', state: 'Telangana', country: 'India', latitude: 17.9784, longitude: 79.5941, timezone: 5.5, aliases: ['వరంగల్', 'Hanamkonda', 'హన్మకొండ', 'Kazipet', 'కాజీపేట', 'Orugallu']),
    CityEntry(name: 'Karimnagar', state: 'Telangana', country: 'India', latitude: 18.4386, longitude: 79.1288, timezone: 5.5, aliases: ['కరీంనగర్', 'Elgandal']),
    CityEntry(name: 'Nizamabad', state: 'Telangana', country: 'India', latitude: 18.6725, longitude: 78.0941, timezone: 5.5, aliases: ['నిజామాబాద్', 'Indur']),
    CityEntry(name: 'Khammam', state: 'Telangana', country: 'India', latitude: 17.2473, longitude: 80.1514, timezone: 5.5, aliases: ['ఖమ్మం', 'Khammamett']),
    CityEntry(name: 'Ramagundam', state: 'Telangana', country: 'India', latitude: 18.7557, longitude: 79.4738, timezone: 5.5, aliases: ['రామగుండం', 'Godavarikhani', 'గోదావరిఖని']),
    CityEntry(name: 'Mahbubnagar', state: 'Telangana', country: 'India', latitude: 16.7488, longitude: 77.9868, timezone: 5.5, aliases: ['మహబూబ్ నగర్', 'Palamuru', 'పాలమూరు']),
    CityEntry(name: 'Nalgonda', state: 'Telangana', country: 'India', latitude: 17.0575, longitude: 79.2684, timezone: 5.5, aliases: ['నల్గొండ', 'Neelagiri']),
    CityEntry(name: 'Adilabad', state: 'Telangana', country: 'India', latitude: 19.6641, longitude: 78.5320, timezone: 5.5, aliases: ['ఆదిలాబాద్']),
    CityEntry(name: 'Suryapet', state: 'Telangana', country: 'India', latitude: 17.1439, longitude: 79.6239, timezone: 5.5, aliases: ['సూర్యాపేట', 'Bhanupuri']),
    CityEntry(name: 'Siddipet', state: 'Telangana', country: 'India', latitude: 18.1018, longitude: 78.8520, timezone: 5.5, aliases: ['సిద్దిపేట']),
    CityEntry(name: 'Miryalaguda', state: 'Telangana', country: 'India', latitude: 16.8744, longitude: 79.5647, timezone: 5.5, aliases: ['మిర్యాలగూడ']),
    CityEntry(name: 'Jagtial', state: 'Telangana', country: 'India', latitude: 18.7963, longitude: 78.9130, timezone: 5.5, aliases: ['జగిత్యాల']),
    CityEntry(name: 'Mancherial', state: 'Telangana', country: 'India', latitude: 18.8679, longitude: 79.4639, timezone: 5.5, aliases: ['మంచిర్యాల']),
    CityEntry(name: 'Nirmal', state: 'Telangana', country: 'India', latitude: 19.0964, longitude: 78.3427, timezone: 5.5, aliases: ['నిర్మల్']),
    CityEntry(name: 'Kamareddy', state: 'Telangana', country: 'India', latitude: 18.3243, longitude: 78.3411, timezone: 5.5, aliases: ['కామారెడ్డి']),
    CityEntry(name: 'Kothagudem', state: 'Telangana', country: 'India', latitude: 17.5500, longitude: 80.6167, timezone: 5.5, aliases: ['కొత్తగూడెం']),
    CityEntry(name: 'Bodhan', state: 'Telangana', country: 'India', latitude: 18.6667, longitude: 77.9000, timezone: 5.5, aliases: ['బోధన్']),
    CityEntry(name: 'Armoor', state: 'Telangana', country: 'India', latitude: 18.7833, longitude: 78.2833, timezone: 5.5, aliases: ['ఆర్మూర్']),
    CityEntry(name: 'Sircilla', state: 'Telangana', country: 'India', latitude: 18.3833, longitude: 78.8333, timezone: 5.5, aliases: ['సిరిసిల్ల']),
    CityEntry(name: 'Koratla', state: 'Telangana', country: 'India', latitude: 18.8200, longitude: 78.7100, timezone: 5.5, aliases: ['కోరుట్ల']),
    CityEntry(name: 'Tandur', state: 'Telangana', country: 'India', latitude: 17.2589, longitude: 77.5857, timezone: 5.5, aliases: ['తాండూరు']),
    CityEntry(name: 'Vikarabad', state: 'Telangana', country: 'India', latitude: 17.3364, longitude: 77.9048, timezone: 5.5, aliases: ['వికారాబాద్']),
    CityEntry(name: 'Sangareddy', state: 'Telangana', country: 'India', latitude: 17.6190, longitude: 78.0818, timezone: 5.5, aliases: ['సంగారెడ్డి']),
    CityEntry(name: 'Medak', state: 'Telangana', country: 'India', latitude: 18.0469, longitude: 78.2612, timezone: 5.5, aliases: ['మెదక్']),
    CityEntry(name: 'Gadwal', state: 'Telangana', country: 'India', latitude: 16.2333, longitude: 77.8000, timezone: 5.5, aliases: ['గద్వాల్']),
    CityEntry(name: 'Wanaparthy', state: 'Telangana', country: 'India', latitude: 16.3622, longitude: 78.0617, timezone: 5.5, aliases: ['వనపర్తి']),
    CityEntry(name: 'Nagarkurnool', state: 'Telangana', country: 'India', latitude: 16.4853, longitude: 78.3325, timezone: 5.5, aliases: ['నాగర్ కర్నూల్']),
    CityEntry(name: 'Jangaon', state: 'Telangana', country: 'India', latitude: 17.7214, longitude: 79.1553, timezone: 5.5, aliases: ['జనగామ']),
    CityEntry(name: 'Bhongir', state: 'Telangana', country: 'India', latitude: 17.5100, longitude: 78.8900, timezone: 5.5, aliases: ['Bhuvanagiri', 'భువనగిరి']),
    CityEntry(name: 'Yadagirigutta', state: 'Telangana', country: 'India', latitude: 17.5878, longitude: 78.9405, timezone: 5.5, aliases: ['యాదగిరిగుట్ట', 'Yadadri']),
    CityEntry(name: 'Bhadrachalam', state: 'Telangana', country: 'India', latitude: 17.6688, longitude: 80.8936, timezone: 5.5, aliases: ['భద్రాచలం']),
    CityEntry(name: 'Basar', state: 'Telangana', country: 'India', latitude: 18.8781, longitude: 77.9547, timezone: 5.5, aliases: ['బాసర', 'Gnana Saraswathi']),
    CityEntry(name: 'Vemulawada', state: 'Telangana', country: 'India', latitude: 18.4678, longitude: 78.8683, timezone: 5.5, aliases: ['వేములవాడ', 'Rajarajeshwara Swamy']),
    CityEntry(name: 'Kaleshwaram', state: 'Telangana', country: 'India', latitude: 18.8100, longitude: 79.9100, timezone: 5.5, aliases: ['కాళేశ్వరం']),
    CityEntry(name: 'Dharmapuri', state: 'Telangana', country: 'India', latitude: 18.9500, longitude: 79.0900, timezone: 5.5, aliases: ['ధర్మపురి']),
    CityEntry(name: 'Bellampalli', state: 'Telangana', country: 'India', latitude: 18.0667, longitude: 79.5000, timezone: 5.5, aliases: ['బెల్లంపల్లి']),
    CityEntry(name: 'Mandamarri', state: 'Telangana', country: 'India', latitude: 18.9833, longitude: 79.4833, timezone: 5.5, aliases: ['మందమర్రి']),
    CityEntry(name: 'Yellandu', state: 'Telangana', country: 'India', latitude: 17.6000, longitude: 80.3333, timezone: 5.5, aliases: ['ఇల్లందు']),
    CityEntry(name: 'Palwancha', state: 'Telangana', country: 'India', latitude: 17.6000, longitude: 80.7000, timezone: 5.5, aliases: ['పాల్వంచ']),
    CityEntry(name: 'Sathupalli', state: 'Telangana', country: 'India', latitude: 17.2167, longitude: 80.8333, timezone: 5.5, aliases: ['సత్తుపల్లి']),
    CityEntry(name: 'Kodad', state: 'Telangana', country: 'India', latitude: 16.9967, longitude: 79.9658, timezone: 5.5, aliases: ['కోదాడ']),
    CityEntry(name: 'Huzurnagar', state: 'Telangana', country: 'India', latitude: 16.9000, longitude: 80.0167, timezone: 5.5, aliases: ['హుజూర్ నగర్']),
    CityEntry(name: 'Devarakonda', state: 'Telangana', country: 'India', latitude: 16.7000, longitude: 78.9333, timezone: 5.5, aliases: ['దేవరకొండ']),
    CityEntry(name: 'Mahabubabad', state: 'Telangana', country: 'India', latitude: 17.5983, longitude: 80.0039, timezone: 5.5, aliases: ['మహబూబాబాద్']),
    CityEntry(name: 'Bhupalpally', state: 'Telangana', country: 'India', latitude: 18.4333, longitude: 79.8667, timezone: 5.5, aliases: ['భూపాలపల్లి']),
    CityEntry(name: 'Mulugu', state: 'Telangana', country: 'India', latitude: 18.1911, longitude: 79.9431, timezone: 5.5, aliases: ['ములుగు', 'Medaram', 'మేడారం']),
    CityEntry(name: 'Zaheerabad', state: 'Telangana', country: 'India', latitude: 17.6833, longitude: 77.6167, timezone: 5.5, aliases: ['జహీరాబాద్']),
    CityEntry(name: 'Gajwel', state: 'Telangana', country: 'India', latitude: 17.8500, longitude: 78.6833, timezone: 5.5, aliases: ['గజ్వేల్']),
    CityEntry(name: 'Huzurabad', state: 'Telangana', country: 'India', latitude: 18.1833, longitude: 79.4000, timezone: 5.5, aliases: ['హుజూరాబాద్']),
    CityEntry(name: 'Peddapalli', state: 'Telangana', country: 'India', latitude: 18.6167, longitude: 79.3833, timezone: 5.5, aliases: ['పెద్దపల్లి']),

    // ══════════════════════════════════════════════════════════════════
    // OTHER MAJOR INDIAN STATES & METROS
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'Chennai', state: 'Tamil Nadu', country: 'India', latitude: 13.0827, longitude: 80.2707, timezone: 5.5, aliases: ['Madras', 'Madrasapattinam']),
    CityEntry(name: 'Coimbatore', state: 'Tamil Nadu', country: 'India', latitude: 11.0168, longitude: 76.9558, timezone: 5.5, aliases: ['Kovai']),
    CityEntry(name: 'Madurai', state: 'Tamil Nadu', country: 'India', latitude: 9.9252, longitude: 78.1198, timezone: 5.5, aliases: ['Meenakshi Amman Temple']),
    CityEntry(name: 'Tiruchirappalli', state: 'Tamil Nadu', country: 'India', latitude: 10.7905, longitude: 78.7047, timezone: 5.5, aliases: ['Trichy', 'Srirangam']),
    CityEntry(name: 'Salem', state: 'Tamil Nadu', country: 'India', latitude: 11.6643, longitude: 78.1460, timezone: 5.5),
    CityEntry(name: 'Tirunelveli', state: 'Tamil Nadu', country: 'India', latitude: 8.7139, longitude: 77.7567, timezone: 5.5, aliases: ['Nellai']),
    CityEntry(name: 'Kanchipuram', state: 'Tamil Nadu', country: 'India', latitude: 12.8342, longitude: 79.7036, timezone: 5.5, aliases: ['Kanchi', 'Conjeevaram']),
    CityEntry(name: 'Thanjavur', state: 'Tamil Nadu', country: 'India', latitude: 10.7870, longitude: 79.1378, timezone: 5.5, aliases: ['Tanjore', 'Brihadeeswara']),
    CityEntry(name: 'Rameswaram', state: 'Tamil Nadu', country: 'India', latitude: 9.2876, longitude: 79.3129, timezone: 5.5),
    CityEntry(name: 'Kanyakumari', state: 'Tamil Nadu', country: 'India', latitude: 8.0883, longitude: 77.5385, timezone: 5.5, aliases: ['Cape Comorin']),

    CityEntry(name: 'Bengaluru', state: 'Karnataka', country: 'India', latitude: 12.9716, longitude: 77.5946, timezone: 5.5, aliases: ['Bangalore', 'ಬೆಂಗಳೂರು']),
    CityEntry(name: 'Mysuru', state: 'Karnataka', country: 'India', latitude: 12.2958, longitude: 76.6394, timezone: 5.5, aliases: ['Mysore']),
    CityEntry(name: 'Hubballi', state: 'Karnataka', country: 'India', latitude: 15.3647, longitude: 75.1240, timezone: 5.5, aliases: ['Hubli', 'Dharwad']),
    CityEntry(name: 'Mangaluru', state: 'Karnataka', country: 'India', latitude: 12.9141, longitude: 74.8560, timezone: 5.5, aliases: ['Mangalore']),
    CityEntry(name: 'Belagavi', state: 'Karnataka', country: 'India', latitude: 15.8497, longitude: 74.4977, timezone: 5.5, aliases: ['Belgaum']),
    CityEntry(name: 'Kalaburagi', state: 'Karnataka', country: 'India', latitude: 17.3297, longitude: 76.8343, timezone: 5.5, aliases: ['Gulbarga']),
    CityEntry(name: 'Udupi', state: 'Karnataka', country: 'India', latitude: 13.3409, longitude: 74.7421, timezone: 5.5, aliases: ['Krishna Matha']),
    CityEntry(name: 'Sringeri', state: 'Karnataka', country: 'India', latitude: 13.4194, longitude: 75.2578, timezone: 5.5, aliases: ['Sharada Peetham']),
    CityEntry(name: 'Kollur', state: 'Karnataka', country: 'India', latitude: 13.8644, longitude: 74.8136, timezone: 5.5, aliases: ['Mookambika']),
    CityEntry(name: 'Gokarna', state: 'Karnataka', country: 'India', latitude: 14.5426, longitude: 74.3188, timezone: 5.5),

    CityEntry(name: 'Thiruvananthapuram', state: 'Kerala', country: 'India', latitude: 8.5241, longitude: 76.9366, timezone: 5.5, aliases: ['Trivandrum', 'Padmanabhaswamy']),
    CityEntry(name: 'Kochi', state: 'Kerala', country: 'India', latitude: 9.9312, longitude: 76.2673, timezone: 5.5, aliases: ['Cochin', 'Ernakulam']),
    CityEntry(name: 'Kozhikode', state: 'Kerala', country: 'India', latitude: 11.2588, longitude: 75.7804, timezone: 5.5, aliases: ['Calicut']),
    CityEntry(name: 'Thrissur', state: 'Kerala', country: 'India', latitude: 10.5276, longitude: 76.2144, timezone: 5.5, aliases: ['Trichur', 'Guruvayur']),
    CityEntry(name: 'Guruvayur', state: 'Kerala', country: 'India', latitude: 10.5946, longitude: 76.0406, timezone: 5.5, aliases: ['Guruvayoor']),
    CityEntry(name: 'Sabarimala', state: 'Kerala', country: 'India', latitude: 9.4404, longitude: 77.0819, timezone: 5.5, aliases: ['Ayyappa Temple']),

    CityEntry(name: 'Mumbai', state: 'Maharashtra', country: 'India', latitude: 19.0760, longitude: 72.8777, timezone: 5.5, aliases: ['Bombay', 'Thane', 'Navi Mumbai']),
    CityEntry(name: 'Pune', state: 'Maharashtra', country: 'India', latitude: 18.5204, longitude: 73.8567, timezone: 5.5, aliases: ['Poona']),
    CityEntry(name: 'Nagpur', state: 'Maharashtra', country: 'India', latitude: 21.1458, longitude: 79.0882, timezone: 5.5),
    CityEntry(name: 'Nashik', state: 'Maharashtra', country: 'India', latitude: 19.9975, longitude: 73.7898, timezone: 5.5, aliases: ['Trimbakeshwar', 'Nasik']),
    CityEntry(name: 'Chhatrapati Sambhajinagar', state: 'Maharashtra', country: 'India', latitude: 19.8762, longitude: 75.3433, timezone: 5.5, aliases: ['Aurangabad', 'Ajanta', 'Ellora']),
    CityEntry(name: 'Shirdi', state: 'Maharashtra', country: 'India', latitude: 19.7667, longitude: 74.4767, timezone: 5.5, aliases: ['Sai Baba']),
    CityEntry(name: 'Kolhapur', state: 'Maharashtra', country: 'India', latitude: 16.7050, longitude: 74.2433, timezone: 5.5, aliases: ['Mahalakshmi']),
    CityEntry(name: 'Solapur', state: 'Maharashtra', country: 'India', latitude: 17.6599, longitude: 75.9064, timezone: 5.5),

    CityEntry(name: 'New Delhi', state: 'Delhi', country: 'India', latitude: 28.6139, longitude: 77.2090, timezone: 5.5, aliases: ['Delhi', 'NCR']),
    CityEntry(name: 'Gurugram', state: 'Haryana', country: 'India', latitude: 28.4595, longitude: 77.0266, timezone: 5.5, aliases: ['Gurgaon']),
    CityEntry(name: 'Noida', state: 'Uttar Pradesh', country: 'India', latitude: 28.5355, longitude: 77.3910, timezone: 5.5, aliases: ['Greater Noida']),
    CityEntry(name: 'Lucknow', state: 'Uttar Pradesh', country: 'India', latitude: 26.8467, longitude: 80.9462, timezone: 5.5),
    CityEntry(name: 'Varanasi', state: 'Uttar Pradesh', country: 'India', latitude: 25.3176, longitude: 82.9739, timezone: 5.5, aliases: ['Kashi', 'Benares', 'Banaras']),
    CityEntry(name: 'Prayagraj', state: 'Uttar Pradesh', country: 'India', latitude: 25.4358, longitude: 81.8463, timezone: 5.5, aliases: ['Allahabad', 'Triveni Sangam']),
    CityEntry(name: 'Ayodhya', state: 'Uttar Pradesh', country: 'India', latitude: 26.7922, longitude: 82.1998, timezone: 5.5, aliases: ['Ram Janmabhoomi', 'Faizabad']),
    CityEntry(name: 'Mathura', state: 'Uttar Pradesh', country: 'India', latitude: 27.4924, longitude: 77.6737, timezone: 5.5, aliases: ['Vrindavan', 'Gokul', 'Braj']),
    CityEntry(name: 'Agra', state: 'Uttar Pradesh', country: 'India', latitude: 27.1767, longitude: 78.0081, timezone: 5.5),
    CityEntry(name: 'Kanpur', state: 'Uttar Pradesh', country: 'India', latitude: 26.4499, longitude: 80.3319, timezone: 5.5),
    CityEntry(name: 'Gorakhpur', state: 'Uttar Pradesh', country: 'India', latitude: 26.7606, longitude: 83.3732, timezone: 5.5),

    CityEntry(name: 'Haridwar', state: 'Uttarakhand', country: 'India', latitude: 29.9457, longitude: 78.1642, timezone: 5.5, aliases: ['Rishikesh', 'Badrinath', 'Kedarnath']),
    CityEntry(name: 'Dehradun', state: 'Uttarakhand', country: 'India', latitude: 30.3165, longitude: 78.0322, timezone: 5.5),
    CityEntry(name: 'Jaipur', state: 'Rajasthan', country: 'India', latitude: 26.9124, longitude: 75.7873, timezone: 5.5, aliases: ['Pink City']),
    CityEntry(name: 'Jodhpur', state: 'Rajasthan', country: 'India', latitude: 26.2389, longitude: 73.0243, timezone: 5.5),
    CityEntry(name: 'Udaipur', state: 'Rajasthan', country: 'India', latitude: 24.5854, longitude: 73.7125, timezone: 5.5),
    CityEntry(name: 'Pushkar', state: 'Rajasthan', country: 'India', latitude: 26.4897, longitude: 74.5511, timezone: 5.5, aliases: ['Ajmer']),

    CityEntry(name: 'Ahmedabad', state: 'Gujarat', country: 'India', latitude: 23.0225, longitude: 72.5714, timezone: 5.5),
    CityEntry(name: 'Surat', state: 'Gujarat', country: 'India', latitude: 21.1702, longitude: 72.8311, timezone: 5.5),
    CityEntry(name: 'Vadodara', state: 'Gujarat', country: 'India', latitude: 22.3072, longitude: 73.1812, timezone: 5.5, aliases: ['Baroda']),
    CityEntry(name: 'Rajkot', state: 'Gujarat', country: 'India', latitude: 22.3039, longitude: 70.8022, timezone: 5.5),
    CityEntry(name: 'Dwarka', state: 'Gujarat', country: 'India', latitude: 22.2442, longitude: 68.9685, timezone: 5.5, aliases: ['Dwaraka', 'Dwarkadhish']),
    CityEntry(name: 'Somnath', state: 'Gujarat', country: 'India', latitude: 20.8880, longitude: 70.4012, timezone: 5.5, aliases: ['Prabhas Patan']),

    CityEntry(name: 'Ujjain', state: 'Madhya Pradesh', country: 'India', latitude: 23.1765, longitude: 75.7885, timezone: 5.5, aliases: ['Mahakaleshwar', 'Avantika']),
    CityEntry(name: 'Indore', state: 'Madhya Pradesh', country: 'India', latitude: 22.7196, longitude: 75.8577, timezone: 5.5),
    CityEntry(name: 'Bhopal', state: 'Madhya Pradesh', country: 'India', latitude: 23.2599, longitude: 77.4126, timezone: 5.5),
    CityEntry(name: 'Gwalior', state: 'Madhya Pradesh', country: 'India', latitude: 26.2183, longitude: 78.1828, timezone: 5.5),
    CityEntry(name: 'Jabalpur', state: 'Madhya Pradesh', country: 'India', latitude: 23.1815, longitude: 79.9864, timezone: 5.5),

    CityEntry(name: 'Patna', state: 'Bihar', country: 'India', latitude: 25.6093, longitude: 85.1376, timezone: 5.5, aliases: ['Pataliputra']),
    CityEntry(name: 'Gaya', state: 'Bihar', country: 'India', latitude: 24.7955, longitude: 85.0002, timezone: 5.5, aliases: ['Bodh Gaya', 'Vishnupad']),
    CityEntry(name: 'Kolkata', state: 'West Bengal', country: 'India', latitude: 22.5726, longitude: 88.3639, timezone: 5.5, aliases: ['Calcutta', 'Kalighat']),
    CityEntry(name: 'Howrah', state: 'West Bengal', country: 'India', latitude: 22.5958, longitude: 88.2636, timezone: 5.5),
    CityEntry(name: 'Bhubaneswar', state: 'Odisha', country: 'India', latitude: 20.2961, longitude: 85.8245, timezone: 5.5, aliases: ['Lingaraj Temple']),
    CityEntry(name: 'Puri', state: 'Odisha', country: 'India', latitude: 19.8135, longitude: 85.8312, timezone: 5.5, aliases: ['Jagannath Puri', 'Sri Kshetra']),
    CityEntry(name: 'Cuttack', state: 'Odisha', country: 'India', latitude: 20.4625, longitude: 85.8828, timezone: 5.5),
    CityEntry(name: 'Chandigarh', state: 'Chandigarh', country: 'India', latitude: 30.7333, longitude: 76.7794, timezone: 5.5),
    CityEntry(name: 'Amritsar', state: 'Punjab', country: 'India', latitude: 31.6340, longitude: 74.8723, timezone: 5.5, aliases: ['Golden Temple']),
    CityEntry(name: 'Ludhiana', state: 'Punjab', country: 'India', latitude: 30.9010, longitude: 75.8573, timezone: 5.5),
    CityEntry(name: 'Ranchi', state: 'Jharkhand', country: 'India', latitude: 23.3441, longitude: 85.3096, timezone: 5.5),
    CityEntry(name: 'Jamshedpur', state: 'Jharkhand', country: 'India', latitude: 22.8046, longitude: 86.2029, timezone: 5.5),
    CityEntry(name: 'Deoghar', state: 'Jharkhand', country: 'India', latitude: 24.4826, longitude: 86.7000, timezone: 5.5, aliases: ['Baidyanath Dham']),
    CityEntry(name: 'Raipur', state: 'Chhattisgarh', country: 'India', latitude: 21.2514, longitude: 81.6296, timezone: 5.5),
    CityEntry(name: 'Bilaspur', state: 'Chhattisgarh', country: 'India', latitude: 22.0797, longitude: 82.1409, timezone: 5.5),
    CityEntry(name: 'Guwahati', state: 'Assam', country: 'India', latitude: 26.1445, longitude: 91.7362, timezone: 5.5, aliases: ['Kamakhya']),
    CityEntry(name: 'Panaji', state: 'Goa', country: 'India', latitude: 15.4909, longitude: 73.8278, timezone: 5.5, aliases: ['Goa']),

    // ══════════════════════════════════════════════════════════════════
    // WORLD CITIES & GLOBAL NRI HUBS
    // ══════════════════════════════════════════════════════════════════
    CityEntry(name: 'New York', state: 'NY', country: 'USA', latitude: 40.7128, longitude: -74.0060, timezone: -5.0, aliases: ['NYC', 'Manhattan', 'Queens', 'Brooklyn']),
    CityEntry(name: 'San Jose', state: 'CA', country: 'USA', latitude: 37.3382, longitude: -121.8863, timezone: -8.0, aliases: ['Silicon Valley', 'Sunnyvale', 'Santa Clara', 'Cupertino', 'Fremont', 'San Francisco']),
    CityEntry(name: 'Dallas', state: 'TX', country: 'USA', latitude: 32.7767, longitude: -96.7970, timezone: -6.0, aliases: ['Frisco', 'Plano', 'Irving', 'Fort Worth']),
    CityEntry(name: 'Austin', state: 'TX', country: 'USA', latitude: 30.2672, longitude: -97.7431, timezone: -6.0),
    CityEntry(name: 'Houston', state: 'TX', country: 'USA', latitude: 29.7604, longitude: -95.3698, timezone: -6.0, aliases: ['Sugar Land']),
    CityEntry(name: 'Chicago', state: 'IL', country: 'USA', latitude: 41.8781, longitude: -87.6298, timezone: -6.0, aliases: ['Naperville']),
    CityEntry(name: 'Seattle', state: 'WA', country: 'USA', latitude: 47.6062, longitude: -122.3321, timezone: -8.0, aliases: ['Redmond', 'Bellevue']),
    CityEntry(name: 'Atlanta', state: 'GA', country: 'USA', latitude: 33.7490, longitude: -84.3880, timezone: -5.0, aliases: ['Alpharetta']),
    CityEntry(name: 'Los Angeles', state: 'CA', country: 'USA', latitude: 34.0522, longitude: -118.2437, timezone: -8.0, aliases: ['LA', 'Irvine']),
    CityEntry(name: 'Washington', state: 'DC', country: 'USA', latitude: 38.9072, longitude: -77.0369, timezone: -5.0, aliases: ['Herndon', 'Ashburn']),
    CityEntry(name: 'Boston', state: 'MA', country: 'USA', latitude: 42.3601, longitude: -71.0589, timezone: -5.0),
    CityEntry(name: 'London', country: 'UK', latitude: 51.5074, longitude: -0.1278, timezone: 0.0, aliases: ['Harrow', 'Wembley', 'Hounslow', 'Slough']),
    CityEntry(name: 'Dubai', country: 'UAE', latitude: 25.2048, longitude: 55.2708, timezone: 4.0, aliases: ['Abu Dhabi', 'Sharjah']),
    CityEntry(name: 'Singapore', country: 'Singapore', latitude: 1.3521, longitude: 103.8198, timezone: 8.0),
    CityEntry(name: 'Sydney', country: 'Australia', latitude: -33.8688, longitude: 151.2093, timezone: 10.0, aliases: ['Parramatta', 'Harris Park']),
    CityEntry(name: 'Melbourne', country: 'Australia', latitude: -37.8136, longitude: 144.9631, timezone: 10.0),
    CityEntry(name: 'Toronto', state: 'ON', country: 'Canada', latitude: 43.6532, longitude: -79.3832, timezone: -5.0, aliases: ['Brampton', 'Mississauga']),
    CityEntry(name: 'Vancouver', state: 'BC', country: 'Canada', latitude: 49.2827, longitude: -123.1207, timezone: -8.0, aliases: ['Surrey']),
    CityEntry(name: 'Kathmandu', country: 'Nepal', latitude: 27.7172, longitude: 85.3240, timezone: 5.75, aliases: ['Pashupatinath']),
    CityEntry(name: 'Colombo', country: 'Sri Lanka', latitude: 6.9271, longitude: 79.8612, timezone: 5.5),
    CityEntry(name: 'Kuala Lumpur', country: 'Malaysia', latitude: 3.1390, longitude: 101.6869, timezone: 8.0),
    CityEntry(name: 'Tokyo', country: 'Japan', latitude: 35.6762, longitude: 139.6503, timezone: 9.0),
    CityEntry(name: 'Paris', country: 'France', latitude: 48.8566, longitude: 2.3522, timezone: 1.0),
    CityEntry(name: 'Frankfurt', country: 'Germany', latitude: 50.1109, longitude: 8.6821, timezone: 1.0, aliases: ['Berlin', 'Munich']),
  ];
}
