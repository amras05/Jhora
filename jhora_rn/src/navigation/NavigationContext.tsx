import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { BackHandler } from 'react-native';

export type ScreenType =
  | 'home'
  | 'panchanga'
  | 'prasna'
  | 'saved'
  | 'birth_input'
  | 'chart_result'
  | 'pdf_report'
  | 'reports';

export type TabType = 'home' | 'panchanga' | 'prasna' | 'saved';

interface NavigationContextType {
  currentScreen: ScreenType;
  currentTab: TabType;
  history: ScreenType[];
  navigate: (screen: ScreenType) => void;
  switchTab: (tab: TabType) => void;
  goBack: () => boolean;
  canGoBack: boolean;
}

const NavigationContext = createContext<NavigationContextType | undefined>(undefined);

export const NavigationProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [history, setHistory] = useState<ScreenType[]>(['home']);
  const [currentTab, setCurrentTab] = useState<TabType>('home');

  const currentScreen = history[history.length - 1] || 'home';
  const canGoBack = history.length > 1;

  const navigate = useCallback((screen: ScreenType) => {
    // If navigating to a main tab, reset history to that tab
    if (screen === 'home' || screen === 'panchanga' || screen === 'prasna' || screen === 'saved') {
      setCurrentTab(screen);
      setHistory([screen]);
    } else {
      setHistory(prev => {
        // Prevent duplicate consecutive pushes
        if (prev[prev.length - 1] === screen) return prev;
        return [...prev, screen];
      });
    }
  }, []);

  const switchTab = useCallback((tab: TabType) => {
    setCurrentTab(tab);
    setHistory([tab]);
  }, []);

  const goBack = useCallback((): boolean => {
    if (history.length > 1) {
      setHistory(prev => {
        const next = prev.slice(0, -1);
        const top = next[next.length - 1];
        if (top === 'home' || top === 'panchanga' || top === 'prasna' || top === 'saved') {
          setCurrentTab(top);
        }
        return next;
      });
      return true; // handled
    }
    return false; // let system exit app
  }, [history.length]);

  // Hardware Back Button Handler for Android
  useEffect(() => {
    const onBackPress = () => {
      return goBack();
    };

    const subscription = BackHandler.addEventListener('hardwareBackPress', onBackPress);
    return () => subscription.remove();
  }, [goBack]);

  return (
    <NavigationContext.Provider
      value={{
        currentScreen,
        currentTab,
        history,
        navigate,
        switchTab,
        goBack,
        canGoBack,
      }}
    >
      {children}
    </NavigationContext.Provider>
  );
};

export const useNavigation = (): NavigationContextType => {
  const context = useContext(NavigationContext);
  if (!context) {
    throw new Error('useNavigation must be used within a NavigationProvider');
  }
  return context;
};

