/// Core Vedic astrology constants — zodiac signs, nakshatras, planets, dignities, and Telugu names.
class AstroConstants {
  AstroConstants._();

  /// The 12 Rashis (Zodiac Signs) in order
  static const List<String> rashis = [
    'Aries', 'Taurus', 'Gemini', 'Cancer',
    'Leo', 'Virgo', 'Libra', 'Scorpio',
    'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  /// Telugu Rashi names
  static const List<String> rashisTelugu = [
    'మేషము', 'వృషభము', 'మిథునము', 'కర్కాటకము',
    'సింహము', 'కన్య', 'తుల', 'వృశ్చికము',
    'ధనుస్సు', 'మకరము', 'కుంభము', 'మీనము',
  ];

  /// Sanskrit Rashi names
  static const List<String> rashisSanskrit = [
    'Mesha', 'Vrishabha', 'Mithuna', 'Karka',
    'Simha', 'Kanya', 'Tula', 'Vrishchika',
    'Dhanu', 'Makara', 'Kumbha', 'Meena',
  ];

  /// Rashi symbols
  static const List<String> rashiSymbols = [
    '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓',
  ];

  /// Rashi lords
  static const List<String> rashiLords = [
    'Mars', 'Venus', 'Mercury', 'Moon',
    'Sun', 'Mercury', 'Venus', 'Mars',
    'Jupiter', 'Saturn', 'Saturn', 'Jupiter',
  ];

  /// Telugu Rashi Lords
  static const List<String> rashiLordsTelugu = [
    'కుజుడు', 'శుక్రుడు', 'బుధుడు', 'చంద్రుడు',
    'రవి', 'బుధుడు', 'శుక్రుడు', 'కుజుడు',
    'గురువు', 'శని', 'శని', 'గురువు',
  ];

  /// Element of each rashi (Fire, Earth, Air, Water)
  static const List<String> rashiElements = [
    'Fire', 'Earth', 'Air', 'Water',
    'Fire', 'Earth', 'Air', 'Water',
    'Fire', 'Earth', 'Air', 'Water',
  ];

  /// The 27 Nakshatras in order
  static const List<String> nakshatras = [
    'Ashwini', 'Bharani', 'Krittika', 'Rohini',
    'Mrigashira', 'Ardra', 'Punarvasu', 'Pushya',
    'Ashlesha', 'Magha', 'Purva Phalguni', 'Uttara Phalguni',
    'Hasta', 'Chitra', 'Swati', 'Vishakha',
    'Anuradha', 'Jyeshtha', 'Mula', 'Purva Ashadha',
    'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha',
    'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati',
  ];

  /// Telugu Nakshatras
  static const List<String> nakshatrasTelugu = [
    'అశ్విని', 'భరణి', 'కృత్తిక', 'రోహిణి',
    'మృగశిర', 'ఆరుద్ర', 'పునర్వసు', 'పుష్యమి',
    'ఆశ్లేష', 'మఖ', 'పుబ్బ', 'ఉత్తర',
    'హస్త', 'చిత్ర', 'స్వాతి', 'విశాఖ',
    'అనూరాధ', 'జ్యేష్ఠ', 'మూల', 'పూర్వాషాఢ',
    'ఉత్తరాషాఢ', 'శ్రవణం', 'ధనిష్ఠ', 'శతభిషం',
    'పూర్వాభాద్ర', 'ఉత్తరాభాద్ర', 'రేవతి',
  ];

  /// Nakshatra lords for Vimshottari Dasha
  static const List<String> nakshatraLords = [
    'Ketu', 'Venus', 'Sun', 'Moon',
    'Mars', 'Rahu', 'Jupiter', 'Saturn',
    'Mercury', 'Ketu', 'Venus', 'Sun',
    'Moon', 'Mars', 'Rahu', 'Jupiter',
    'Saturn', 'Mercury', 'Ketu', 'Venus',
    'Sun', 'Moon', 'Mars', 'Rahu',
    'Jupiter', 'Saturn', 'Mercury',
  ];

  /// Telugu Nakshatra lords
  static const List<String> nakshatraLordsTelugu = [
    'కేతువు', 'శుక్రుడు', 'రవి', 'చంద్రుడు',
    'కుజుడు', 'రాహువు', 'గురువు', 'శని',
    'బుధుడు', 'కేతువు', 'శుక్రుడు', 'రవి',
    'చంద్రుడు', 'కుజుడు', 'రాహువు', 'గురువు',
    'శని', 'బుధుడు', 'కేతువు', 'శుక్రుడు',
    'రవి', 'చంద్రుడు', 'కుజుడు', 'రాహువు',
    'గురువు', 'శని', 'బుధుడు',
  ];

  /// Telugu Planet Names
  static const Map<String, String> planetNamesTelugu = {
    'Sun': 'రవి',
    'Moon': 'చంద్రుడు',
    'Mars': 'కుజుడు',
    'Mercury': 'బుధుడు',
    'Jupiter': 'గురువు',
    'Venus': 'శుక్రుడు',
    'Saturn': 'శని',
    'Rahu': 'రాహువు',
    'Ketu': 'కేతువు',
    'Ascendant': 'లగ్నము',
    'Uranus': 'యురేనస్',
    'Neptune': 'నెప్ట్యూన్',
    'Pluto': 'ప్లూటో',
    'Gulika': 'గుళిక',
    'Mandi': 'మాంది',
  };

  /// Telugu Planet Single Character Abbreviations
  static const Map<String, String> planetAbbrTelugu = {
    'Sun': 'ర',
    'Moon': 'చం',
    'Mars': 'కు',
    'Mercury': 'బు',
    'Jupiter': 'గు',
    'Venus': 'శు',
    'Saturn': 'శ',
    'Rahu': 'రా',
    'Ketu': 'కే',
    'Ascendant': 'ల',
    'Gulika': 'గుళి',
    'Mandi': 'మాం',
  };

  /// Each nakshatra spans 13°20' (13.3333°)
  static const double nakshatraSpan = 13.333333333;

  /// Each pada spans 3°20' (3.3333°)
  static const double padaSpan = 3.333333333;

  /// Planet abbreviations for chart display
  static const Map<String, String> planetAbbr = {
    'Sun': 'Su',
    'Moon': 'Mo',
    'Mars': 'Ma',
    'Mercury': 'Me',
    'Jupiter': 'Ju',
    'Venus': 'Ve',
    'Saturn': 'Sa',
    'Rahu': 'Ra',
    'Ketu': 'Ke',
    'Ascendant': 'As',
  };

  /// Vimshottari Dasha years for each planet
  static const Map<String, double> dashaYears = {
    'Ketu': 7,
    'Venus': 20,
    'Sun': 6,
    'Moon': 10,
    'Mars': 7,
    'Rahu': 18,
    'Jupiter': 16,
    'Saturn': 19,
    'Mercury': 17,
  };

  /// Total Vimshottari cycle years
  static const double totalDashaYears = 120;

  /// Dasha sequence order
  static const List<String> dashaSequence = [
    'Ketu', 'Venus', 'Sun', 'Moon', 'Mars',
    'Rahu', 'Jupiter', 'Saturn', 'Mercury',
  ];

  /// Exaltation signs (0-indexed rashi)
  static const Map<String, int> exaltation = {
    'Sun': 0,     // Aries
    'Moon': 1,    // Taurus
    'Mars': 9,    // Capricorn
    'Mercury': 5, // Virgo
    'Jupiter': 3, // Cancer
    'Venus': 11,  // Pisces
    'Saturn': 6,  // Libra
    'Rahu': 1,    // Taurus
    'Ketu': 7,    // Scorpio
  };

  /// Debilitation signs (0-indexed)
  static const Map<String, int> debilitation = {
    'Sun': 6,     // Libra
    'Moon': 7,    // Scorpio
    'Mars': 3,    // Cancer
    'Mercury': 11,// Pisces
    'Jupiter': 9, // Capricorn
    'Venus': 5,   // Virgo
    'Saturn': 0,  // Aries
    'Rahu': 7,    // Scorpio
    'Ketu': 1,    // Taurus
  };

  /// Own signs for each planet
  static const Map<String, List<int>> ownSigns = {
    'Sun': [4],        // Leo
    'Moon': [3],       // Cancer
    'Mars': [0, 7],    // Aries, Scorpio
    'Mercury': [2, 5], // Gemini, Virgo
    'Jupiter': [8, 11],// Sagittarius, Pisces
    'Venus': [1, 6],   // Taurus, Libra
    'Saturn': [9, 10], // Capricorn, Aquarius
  };

  /// Friendly planets
  static const Map<String, List<String>> friends = {
    'Sun': ['Moon', 'Mars', 'Jupiter'],
    'Moon': ['Sun', 'Mercury'],
    'Mars': ['Sun', 'Moon', 'Jupiter'],
    'Mercury': ['Sun', 'Venus'],
    'Jupiter': ['Sun', 'Moon', 'Mars'],
    'Venus': ['Mercury', 'Saturn'],
    'Saturn': ['Mercury', 'Venus'],
  };

  /// Enemy planets
  static const Map<String, List<String>> enemies = {
    'Sun': ['Saturn', 'Venus'],
    'Moon': [],
    'Mars': ['Mercury'],
    'Mercury': ['Moon'],
    'Jupiter': ['Mercury', 'Venus'],
    'Venus': ['Sun', 'Moon'],
    'Saturn': ['Sun', 'Moon', 'Mars'],
  };

  /// South Indian chart — fixed sign positions in the 4x4 grid
  /// Grid indices (row, col) to rashi index (0-based)
  static const List<List<int>> southIndianGrid = [
    [11, 0,  1,  2],   // Row 0: Pisces, Aries, Taurus, Gemini
    [10, -1, -1, 3],   // Row 1: Aquarius, CENTER, CENTER, Cancer
    [9,  -1, -1, 4],   // Row 2: Capricorn, CENTER, CENTER, Leo
    [8,  7,  6,  5],   // Row 3: Sagittarius, Scorpio, Libra, Virgo
  ];
}
