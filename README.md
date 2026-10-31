# SBJV Hora - Vedic Astrology Mobile Application

A comprehensive Vedic Astrology (Jyotish) mobile application built with Expo/React Native, implementing classical Parashara principles for professional astrologers and enthusiasts.

## Features

### Core Astrology Calculations
- **Birth Chart (Rasi Chart)** - South Indian style chart rendering with planetary positions
- **Divisional Charts (D1-D60)** - Complete suite of Vargas including Navamsa (D9), Dasamsa (D10), and all 60 divisional charts
- **Vimshottari Dasha System** - Full Mahadasha, Antardasha, Pratyantardasha with timeline browser
- **Ashtakavarga** - Sarvashtakavarga and Bhinnashtakavarga with bindu calculations
- **Shadbala** - Six-fold planetary strength analysis
- **Yogas** - 100+ classical yogas including Raja Yogas, Dhana Yogas, Pancha Mahapurusha Yogas
- **Doshas** - Kuja Dosha, Kala Sarpa Dosha, Pitru Dosha, and other afflictions
- **Gochara (Transits)** - Real-time and historical transit analysis with Ashtakavarga overlay

### Panchanga & Muhurta
- **Complete Panchanga** - Tithi, Vara, Nakshatra, Yoga, Karana for any date/time/location
- **Sunrise/Sunset** - Accurate astronomical calculations
- **Rahu/Kala/Yama Gulika** - Daily time periods

### Reports & Export
- **Telugu PDF Reports** - Professional horoscope reports in Telugu language
- **Chart Export** - Save and share charts as images
- **Saved Horoscopes** - Local storage for multiple profiles

### Prasna (Horary Astrology)
- **Prasna Charts** - Time-based query charts with Tajaka aspects
- **Ashtamangala Prasna** - Traditional query system

## Tech Stack

- **Framework**: Expo (React Native) ~58.0.22
- **Language**: TypeScript ~6.0.3
- **Navigation**: Expo Router (file-based routing)
- **Charts**: React Native SVG for custom chart rendering
- **PDF Generation**: Expo Print + Expo Sharing
- **Local Storage**: Expo FileSystem for offline persistence
- **Astronomy Engine**: Custom implementation with Swiss Ephemeris algorithms

## Project Structure

```
jhora_rn/
├── src/
│   ├── app/                    # Expo Router screens (file-based routing)
│   │   ├── _layout.tsx         # Root layout with providers
│   │   ├── index.tsx           # Home screen
│   │   ├── birth-input.tsx     # Birth data entry
│   │   ├── chart-result.tsx    # Chart display
│   │   ├── panchanga.tsx       # Panchanga calculations
│   │   ├── saved-horoscopes.tsx # Profile management
│   │   ├── telugu-pdf-report.tsx # PDF report generation
│   │   └── prasna.tsx          # Horary astrology
│   ├── components/             # Reusable UI components
│   │   ├── SouthIndianChart.tsx
│   │   ├── ChartPanchangaView.tsx
│   │   ├── DashaBrowser.tsx
│   │   └── AshtakavargaView.tsx
│   ├── services/               # Business logic & calculations
│   │   ├── astroEngine.ts      # Core astronomy/astrology engine
│   │   ├── dashaService.ts     # Vimshottari dasha calculations
│   │   ├── yogaService.ts      # Yoga detection
│   │   ├── doshaService.ts     # Dosha analysis
│   │   ├── divisionalChartService.ts # Vargas
│   │   ├── ashtakavargaService.ts # Ashtakavarga
│   │   ├── transitService.ts   # Gochara/transits
│   │   ├── panchangaService.ts # Panchanga
│   │   ├── teluguPdfReportGenerator.ts # PDF reports
│   │   ├── savedHoroscopeService.ts # Local storage
│   │   └── cityDatabase.ts     # Location lookup
│   ├── models/                 # TypeScript interfaces
│   │   └── astroModels.ts
│   ├── constants/              # Astrological constants
│   │   └── astroConstants.ts
│   └── theme/                  # UI theming
│       └── appTheme.ts
├── assets/                     # Icons, images, fonts
├── app.json                    # Expo config
└── package.json
```

## Getting Started

### Prerequisites
- Node.js 18+
- Bun (recommended) or npm/yarn
- Expo CLI: `npm install -g expo-cli`
- iOS Simulator (Mac) / Android Studio for device testing

### Installation

```bash
cd jhora_rn
bun install  # or npm install
```

### Development

```bash
# Start development server
bunx expo start

# Run on iOS simulator
bunx expo run:ios

# Run on Android emulator
bunx expo run:android

# Run on web
bunx expo start --web
```

### Building for Production

```bash
# Using EAS Build (recommended)
bunx eas-cli@latest build --platform all

# Or locally (requires Xcode/Android Studio)
bunx expo run:ios --configuration Release
bunx expo run:android --variant release
```

## Astrological References

This application implements calculations based on:
- **Brihat Parashara Hora Shastra** - Primary classical text
- **Phaladeepika** - For yogas and predictive principles
- **Saravali** - For planetary strength and dashas
- **Jataka Parijata** - For divisional charts
- **Swiss Ephemeris** - High-precision planetary positions (via custom implementation)

## License

This project is licensed under the **GNU General Public License v3.0** - see the [LICENSE](LICENSE) file for details.

The mobile application (`jhora_rn/`) includes third-party dependencies under their respective licenses (Expo - MIT, React Native - MIT, etc.).

## Author

**SBJV Hora Team**  
Built with dedication to the classical tradition of Jyotish.

---

*Jyotisham Suryadi Grihanam... - "Astrology begins with the Sun and planets"*