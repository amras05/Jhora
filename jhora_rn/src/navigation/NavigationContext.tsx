/**
 * Copyright (C) 2024-2026 Karrthikeya Sarma (SBJV Hora Team)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: AGPL-3.0-or-later
 */

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

