import React from 'react';
import { StyleSheet, View } from 'react-native';
import {
  BirthData,
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  DashaPeriod,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
} from './src/models/astroModels';
import { HomeScreen } from './src/screens/HomeScreen';
import { BirthInputScreen } from './src/screens/BirthInputScreen';
import { ChartResultScreen } from './src/screens/ChartResultScreen';
import { PanchangaScreen } from './src/screens/PanchangaScreen';
import { PrasnaScreen } from './src/screens/PrasnaScreen';
import { SavedHoroscopesScreen } from './src/screens/SavedHoroscopesScreen';
import { TeluguPdfReportScreen } from './src/screens/TeluguPdfReportScreen';
import { ThemeProvider, useTheme } from './src/context/ThemeContext';
import { LanguageProvider, useLanguage } from './src/context/LanguageContext';
import { ProfileProvider, useProfile } from './src/context/ProfileContext';
import { NavigationProvider, useNavigation } from './src/navigation/NavigationContext';
import { BottomNavBar } from './src/navigation/BottomNavBar';

function AppContent() {
  const { currentScreen, navigate, goBack } = useNavigation();
  const { isDark, toggleTheme } = useTheme();
  const { lang } = useLanguage();
  const { birthData, setBirthData, pdfData, setPdfData } = useProfile();

  const handleCalculateFromInput = (data: BirthData) => {
    setBirthData(data);
    navigate('chart_result');
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
    navigate('pdf_report');
  };

  return (
    <View style={styles.container}>
      <View style={styles.screenContainer}>
        {currentScreen === 'home' && (
          <HomeScreen onNavigate={screen => navigate(screen)} />
        )}

        {currentScreen === 'birth_input' && (
          <BirthInputScreen
            isDark={isDark}
            lang={lang}
            onBack={goBack}
            onCalculate={handleCalculateFromInput}
          />
        )}

        {currentScreen === 'chart_result' && (
          <ChartResultScreen
            birthData={birthData}
            isDark={isDark}
            onToggleTheme={toggleTheme}
            lang={lang}
            onBack={goBack}
            onOpenPdfReport={handleOpenPdfReport}
          />
        )}

        {currentScreen === 'panchanga' && (
          <PanchangaScreen
            isDark={isDark}
            lang={lang}
            onBack={goBack}
          />
        )}

        {currentScreen === 'prasna' && (
          <PrasnaScreen
            isDark={isDark}
            lang={lang}
            onBack={goBack}
            onGeneratePrasna={data => {
              setBirthData(data);
              navigate('chart_result');
            }}
          />
        )}

        {currentScreen === 'saved' && (
          <SavedHoroscopesScreen
            isDark={isDark}
            lang={lang}
            onBack={goBack}
            onSelectProfile={profile => {
              setBirthData(profile);
              navigate('chart_result');
            }}
            onAddNew={() => navigate('birth_input')}
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
            onBack={goBack}
          />
        )}
      </View>

      <BottomNavBar />
    </View>
  );
}

export default function App() {
  return (
    <ThemeProvider followSystem>
      <LanguageProvider defaultLang="te">
        <ProfileProvider>
          <NavigationProvider>
            <AppContent />
          </NavigationProvider>
        </ProfileProvider>
      </LanguageProvider>
    </ThemeProvider>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  screenContainer: {
    flex: 1,
  },
});
