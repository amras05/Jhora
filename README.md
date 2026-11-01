# SBJV Hora (సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)
### Vedic Astrology Comprehensive Calculation & Horoscope Reporting System

A comprehensive Vedic Astrology (Jyotish) mobile application built with React Native and Expo, implementing classical Brihat Parashara Hora Shastra principles for astrologers, scholars, and spiritual seekers. Blessed by **Sri Bala Tripura Sundari Devi**.

---

## 🌟 Key Features

### 1. Classical Parashari Planetary Engine & Charts
- **Birth Chart (Rasi Chart - D1)**: South Indian style chart rendering with high-contrast Vedic palette, retrogrades, and combust indicators.
- **Complete Shodashavarga (16 Divisional Charts D1–D60)**:
  - D1 (Rasi), D2 (Hora), D3 (Drekkana), D4 (Chaturthamsha), D7 (Saptamsha)
  - D9 (Navamsha - with J2000 precession-compensated planetary longitudes)
  - D10 (Dashamsha), D12 (Dwadashamsha), D16 (Shodashamsha), D20 (Vimshamsha)
  - D24 (Chaturvimshamsha), D27 (Saptavimshamsha)
  - D30 (Trimshamsha - classical Parashari odd/even sign rulers with 25°–30° Libra)
  - D40 (Khavedamsha), D45 (Akshavedamsha), D60 (Shashtiamsha)
- **Mathematical Precession Alignment**: Planetary orbital positions in the J2000 frame are dynamically converted to of-date tropical and sidereal (Lahiri/Chitra Paksha Ayanamsa), preventing boundary shifts in fine divisional vargas (D9, D60).

### 2. Classical Special Points & Systems
- **Bhrigu Bindu**: Correctly computed along the forward arc from Rahu to Moon:
  $$\text{Arc} = (\lambda_{\text{Moon}} - \lambda_{\text{Rahu}} + 360^\circ) \bmod 360^\circ$$
  $$\lambda_{\text{Bhrigu}} = (\lambda_{\text{Rahu}} + \frac{\text{Arc}}{2}) \bmod 360^\circ$$
- **Yogi, Sahayogi & Avayogi**:
  - Yogi Point = $(\lambda_{\text{Sun}} + \lambda_{\text{Moon}} + 93^\circ 20') \bmod 360^\circ$
  - Yogi Nakshatra & Vimshottari Yogi Lord
  - Sahayogi Lord (ruler of the Rasi hosting Yogi Point)
  - Avayogi Nakshatra (6th asterism from Yogi Nakshatra) & Avayogi Lord
- **Jaimini 7 Chara Karakas**: Dynamically calculated by sorting the 7 primary grahas (Sun to Saturn) by intra-sign longitude:
  - Atmakaraka (AK), Amatyakaraka (AmK), Bhratrukaraka (BK), Matrukaraka (MK), Putrakaraka (PK), Gnatikaraka (GK), Darakaraka (DK)
- **Dosha Analysis**: Real-time evaluation of Kuja (Manglik) Dosha from Lagna and Moon, and Kaal Sarpa Yoga/Dosha across the Rahu-Ketu nodal axis.

### 3. Vimshottari Dasha Hierarchy (Levels 1–5)
- Full 120-year Vimshottari Dasha timeline from Mahadasha down to Prana Dasha:
  - Level 1: Mahadashas
  - Level 2: Antardashas
  - Level 3: Pratyantardashas
  - Level 4: Sookshma Dashas
  - Level 5: Prana Dashas (calculated down to seconds)
- Real-time active dasha highlighting with age brackets and duration formatting.

### 4. Ashtakavarga & Bhava Sputa
- **Sarvashtakavarga (SAV 337)**: 12-house matrix, planet-wise bindus, and visual chart.
- **Bhava Sputa Patika**: Sripati/Equal 12-house cusp start, mid-point (sandhi), and end boundaries with house lordships.

### 5. Panchanga & Muhurtha
- Complete 5 limbs of Panchanga: Tithi (with elapsed percentage), Vara (with ruler), Nakshatra & Pada (with lord), Yoga, Karana.
- Real-time Sun & Moon rise/set, Rahu Kalam, Yamagandam, Gulika, Abhijit Muhurtham, and Brahma Muhurtham.

### 6. Interactive Calendar & 12-Hour Input
- **Mathematical 7-Column Calendar Modal**: Exact 14.2857% column widths ensuring perfect vertical alignment of every date under its weekday (Sun through Sat).
- Fast decade and year navigation buttons (`« -10y`, `‹ -1y`, `+1y ›`, `+10y »`) supporting dates from 1800 to 2100.
- **12-Hour Format Time Picker**: Hour (01–12), Minute (00–59), Second (00–59), and interactive AM/PM selector pills with live preview.

### 7. Professional 25-Page Telugu PDF Report
- Standalone HTML5-to-PDF generation formatted strictly for standard A4 (`210mm x 297mm`, zero margin, overflow contained).
- **Exact 25 Pages**: Every page maps 1:1 to a physical page with zero phantom page overflows.
- Direct device storage saving via `StorageAccessFramework` and native share sheet — **no mobile print service dialog**.

---

## 📱 Tech Stack & Architecture

- **Framework**: React Native 0.88.1 / Expo SDK 58
- **Language**: TypeScript 6.0
- **Vector Graphics**: React Native SVG 15.12
- **PDF Engine**: Expo Print + Expo Sharing + Expo FileSystem
- **Native Android Configuration**: Standalone offline bundling with Hermes bytecode (`debuggableVariants = []`), signed with debug keystore.
- **App Icon & Branding**: Bala Amma (Sri Bala Tripura Sundari Devi) on vermilion (`#AE171E`) canvas across all Android mipmap densities (`mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`).

---

## 📂 Project Directory Structure

```
Jhora/
├── README.md                   # Project documentation
├── LICENSE                     # GNU General Public License v3.0
├── AGENTS.md                   # Architecture & developer rules
├── python_server/              # High-precision Swiss Ephemeris microservice
└── jhora_rn/                   # React Native / Expo Application
    ├── App.tsx                 # Root component & screen router
    ├── app.json                # Expo application manifest
    ├── index.ts                # Application entrypoint
    ├── assets/                 # High-resolution icons & Bala Amma artwork
    ├── android/                # Native Android Gradle project (AGP 9 / Gradle 9.4.1)
    │   └── app/build/outputs/apk/
    │       ├── release/app-release.apk  (Optimized production release APK, 71 MB)
    │       └── debug/app-debug.apk      (Standalone debug APK, 156 MB)
    └── src/
        ├── constants/          # Sanskrit & Telugu astronomical constants
        │   └── astroConstants.ts
        ├── models/             # TypeScript data contracts
        │   └── astroModels.ts
        ├── theme/              # Vedic color palette (Maroon, Gold, Saffron)
        │   └── appTheme.ts
        ├── components/         # Modular visual UI components
        │   ├── SouthIndianChart.tsx
        │   └── ChartPanchangaView.tsx
        ├── services/           # Astrological & astronomical business logic
        │   ├── astroEngine.ts             # Meeus VSOP87, ELP2000 & Parashara engine
        │   ├── dashaService.ts            # Vimshottari 5-level dasha hierarchy
        │   ├── divisionalChartService.ts  # Shodashavarga (D1-D60) generators
        │   ├── ashtakavargaService.ts     # SAV & BAV bindu calculators
        │   ├── panchangaService.ts        # 5 limbs & muhurtha timings
        │   ├── cityDatabase.ts            # Offline coordinates database (AP/Telangana/India)
        │   ├── teluguPdfReportGenerator.ts# 25-page Telugu report builder
        │   ├── pdfExportService.ts        # Direct file storage save service
        │   └── savedHoroscopeService.ts   # Offline horoscope persistence
        └── screens/            # Application views
            ├── HomeScreen.tsx             # Sacred Bala Amma hero & portal
            ├── BirthInputScreen.tsx       # 7-col calendar modal & 12h time input
            ├── ChartResultScreen.tsx      # Comprehensive tabbed horoscope viewer
            ├── TeluguPdfReportScreen.tsx  # 25-page PDF preview & export
            ├── PanchangaScreen.tsx        # Daily panchangam & muhurthams
            ├── PrasnaScreen.tsx           # Horary astrology calculations
            └── SavedHoroscopesScreen.tsx  # Saved native profiles
```

---

## 🚀 Building & Running

### Prerequisites
- Node.js 18+
- Android Studio with Android SDK (API 34–37) & Java 17+ (or Android Studio JBR)

### 1. Running in Development
```bash
cd jhora_rn
npm install
npx expo start --android
```

### 2. Compiling Standalone Android APKs
Both debug and release APKs embed the offline JavaScript bundle and all assets, allowing 100% offline execution on any physical Android device:

```bash
# Build standalone Release APK (71 MB, R8-optimized)
cd jhora_rn/android
./gradlew assembleRelease

# Build standalone Debug APK (156 MB)
./gradlew assembleDebug
```

---

## 📜 Astrological Literature References

1. **Brihat Parashara Hora Shastra (BPHS)** — Maharshi Parashara (Vargas, Dashas, Ashtakavarga, Special Points)
2. **Jataka Parijata** — Vaidyanatha Dikshita (Divisional chart rules and Bhava Sputa)
3. **Phaladeepika** — Mantreswara (Yogas, Gochara, and planetary dignities)
4. **Saravali** — Kalyana Varma (Planetary strengths and characteristics)
5. **Astronomical Algorithms** — Jean Meeus (VSOP87 planetary orbits & ELP2000 lunar perturbations)

---

## ⚖️ License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)**.  
See the [LICENSE](LICENSE) file for the full license text.

Copyright (C) 2024–2026 **సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం** (M.B.S. Sastry & SBJV Hora Team).  
*All rights reserved under classical Jyotish tradition.*
