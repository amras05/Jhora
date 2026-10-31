import React, { useState } from 'react';
import { StyleSheet, View, Platform, StatusBar as RNStatusBar } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { BirthData, ChartData, AshtakavargaData, PlanetShadbala, DashaPeriod, SpecialPointsResult, PanchangaData, DoshaAnalysis } from './src/models/astroModels';
import { HomeScreen } from './src/screens/HomeScreen';
import { BirthInputScreen } from './src/screens/BirthInputScreen';
import { ChartResultScreen } from './src/screens/ChartResultScreen';
import { PanchangaScreen } from './src/screens/PanchangaScreen';
import { PrasnaScreen } from './src/screens/PrasnaScreen';
import { SavedHoroscopesScreen } from './src/screens/SavedHoroscopesScreen';
import { TeluguPdfReportScreen } from './src/screens/TeluguPdfReportScreen';
import { AppColors } from './src/theme/appTheme';

type ScreenType =
  | 'home'
  | 'birth_input'
  | 'chart_result'
  | 'panchanga'
  | 'prasna'
  | 'saved'
  | 'pdf_report';

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<ScreenType>('home');
  const [isDark, setIsDark] = useState(false);
  const [lang, setLang] = useState<'te' | 'en'>('te');

  const [activeBirthData, setActiveBirthData] = useState<BirthData>({
    name: 'శ్రీ వెంకటేశ్వర రావు',
    dateTime: new Date(1990, 7, 15, 10, 30, 0),
    latitude: 16.5062,
    longitude: 80.6480,
    timezone: 5.5,
    placeName: 'విజయవాడ, NTR, Andhra Pradesh',
    gender: 'పురుషుడు',
  });

  const [pdfData, setPdfData] = useState<{
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    special: SpecialPointsResult;
    panchanga: PanchangaData;
    dosha: DoshaAnalysis;
    dashas: DashaPeriod[];
  } | null>(null);

  const toggleTheme = () => setIsDark(prev => !prev);
  const toggleLang = () => setLang(prev => (prev === 'te' ? 'en' : 'te'));

  const handleCalculateFromInput = (data: BirthData) => {
    setActiveBirthData(data);
    setCurrentScreen('chart_result');
  };

  const handleOpenPdfReport = (data: {
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    special: SpecialPointsResult;
    panchanga: PanchangaData;
    dosha: DoshaAnalysis;
    dashas: DashaPeriod[];
  }) => {
    setPdfData(data);
    setCurrentScreen('pdf_report');
  };

  return (
    <View
      style={[
        styles.root,
        {
          backgroundColor: AppColors.getBg(isDark),
          paddingTop: Platform.OS === 'android' ? (RNStatusBar.currentHeight || 28) : 0,
        },
      ]}
    >
      <StatusBar style={isDark ? 'light' : 'dark'} />

      {currentScreen === 'home' && (
        <HomeScreen
          isDark={isDark}
          onToggleTheme={toggleTheme}
          lang={lang}
          onToggleLang={toggleLang}
          onNavigate={screen => setCurrentScreen(screen)}
        />
      )}

      {currentScreen === 'birth_input' && (
        <BirthInputScreen
          isDark={isDark}
          lang={lang}
          onBack={() => setCurrentScreen('home')}
          onCalculate={handleCalculateFromInput}
        />
      )}

      {currentScreen === 'chart_result' && (
        <ChartResultScreen
          birthData={activeBirthData}
          isDark={isDark}
          onToggleTheme={toggleTheme}
          lang={lang}
          onBack={() => setCurrentScreen('home')}
          onOpenPdfReport={handleOpenPdfReport}
        />
      )}

      {currentScreen === 'panchanga' && (
        <PanchangaScreen
          isDark={isDark}
          lang={lang}
          onBack={() => setCurrentScreen('home')}
        />
      )}

      {currentScreen === 'prasna' && (
        <PrasnaScreen
          isDark={isDark}
          lang={lang}
          onBack={() => setCurrentScreen('home')}
          onGeneratePrasna={data => {
            setActiveBirthData(data);
            setCurrentScreen('chart_result');
          }}
        />
      )}

      {currentScreen === 'saved' && (
        <SavedHoroscopesScreen
          isDark={isDark}
          lang={lang}
          onBack={() => setCurrentScreen('home')}
          onSelectProfile={profile => {
            setActiveBirthData(profile);
            setCurrentScreen('chart_result');
          }}
          onAddNew={() => setCurrentScreen('birth_input')}
        />
      )}

      {currentScreen === 'pdf_report' && pdfData && (
        <TeluguPdfReportScreen
          chartData={pdfData.chartData}
          ashtakavarga={pdfData.ashtakavarga}
          shadbala={pdfData.shadbala}
          special={pdfData.special}
          panchanga={pdfData.panchanga}
          dosha={pdfData.dosha}
          dashas={pdfData.dashas}
          isDark={isDark}
          lang={lang}
          onBack={() => setCurrentScreen('chart_result')}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
  },
});
