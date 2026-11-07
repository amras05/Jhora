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

import React, { createContext, useContext, useState, useCallback } from 'react';
import {
  BirthData,
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
  DashaPeriod,
} from '../models/astroModels';
import { VedicYoga } from '../services/yogaService';
import { GocharAnalysis } from '../services/transitService';

// ─── Types ───────────────────────────────────────────────────────────────────
export type PdfReportData = {
  chartData: ChartData;
  ashtakavarga: AshtakavargaData;
  shadbala: PlanetShadbala[];
  special: SpecialPointsResult;
  panchanga: PanchangaData;
  dosha: DoshaAnalysis;
  dashas: DashaPeriod[];
  yogas?: VedicYoga[];
  gochar?: GocharAnalysis;
};

type ProfileContextValue = {
  birthData: BirthData;
  setBirthData: (data: BirthData) => void;
  pdfData: PdfReportData | null;
  setPdfData: (data: PdfReportData | null) => void;
};

// ─── Default birth data ──────────────────────────────────────────────────────
const DEFAULT_BIRTH_DATA: BirthData = {
  name: 'శ్రీ వెంకటేశ్వర రావు',
  dateTime: new Date(1990, 7, 15, 10, 30, 0),
  latitude: 16.5062,
  longitude: 80.6480,
  timezone: 5.5,
  placeName: 'విజయవాడ, NTR, Andhra Pradesh',
  gender: 'పురుషుడు',
};

// ─── Context ─────────────────────────────────────────────────────────────────
const ProfileContext = createContext<ProfileContextValue | undefined>(undefined);

// ─── Provider ────────────────────────────────────────────────────────────────
interface ProfileProviderProps {
  children: React.ReactNode;
}

export const ProfileProvider: React.FC<ProfileProviderProps> = ({ children }) => {
  const [birthData, setBirthDataState] = useState<BirthData>(DEFAULT_BIRTH_DATA);
  const [pdfData, setPdfDataState] = useState<PdfReportData | null>(null);

  const setBirthData = useCallback((data: BirthData) => {
    setBirthDataState(data);
  }, []);

  const setPdfData = useCallback((data: PdfReportData | null) => {
    setPdfDataState(data);
  }, []);

  return (
    <ProfileContext.Provider value={{ birthData, setBirthData, pdfData, setPdfData }}>
      {children}
    </ProfileContext.Provider>
  );
};

// ─── Hook ────────────────────────────────────────────────────────────────────
export const useProfile = (): ProfileContextValue => {
  const ctx = useContext(ProfileContext);
  if (!ctx) {
    throw new Error('useProfile must be used within a ProfileProvider');
  }
  return ctx;
};

