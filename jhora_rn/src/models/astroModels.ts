export interface BirthData {
  name: string;
  dateTime: Date;
  latitude: number;
  longitude: number;
  timezone: number;
  placeName: string;
  gender?: string;
}

export interface PlanetPosition {
  name: string;
  longitude: number;
  latitude: number;
  speed: number;
  isRetrograde: boolean;
  isCombust: boolean;
  rashiIndex: number;
  degreesInRashi: number;
  nakshatraIndex: number;
  pada: number;
  navamsaRashiIndex: number;
  dignity: string;
  abbreviation: string;
}

export interface ChartData {
  birthData: BirthData;
  ascendant: PlanetPosition;
  planets: PlanetPosition[];
  ayanamsa: number;
}

export interface PanchangaData {
  date?: Date;
  placeName?: string;
  vara?: string;
  varaIndex?: number;
  tithi?: string;
  tithiIndex: number;
  paksha: string;
  tithiProgress?: number;
  nakshatra?: string;
  nakshatraIndex?: number;
  nakshatraPada?: number;
  yoga?: string;
  yogaIndex: number;
  karana: string;
  karanaIndex?: number;
  sunSign?: string;
  moonSign?: string;
  sunrise: Date;
  sunset: Date;
  rahuKalam: [Date, Date];
  yamagandam: [Date, Date];
  gulika: [Date, Date];
  gulikaKalam?: [Date, Date];
  abhijitMuhurtha: [Date, Date];
  abhijitMuhurtham?: [Date, Date];
  brahmaMuhurtham?: [Date, Date];
}

export interface AshtakavargaData {
  sav: number[];
  bav: Record<string, number[]>;
}

export interface PlanetShadbala {
  planetName: string;
  sthanaBala: number;
  digBala: number;
  kalaBala: number;
  chestaBala: number;
  naisargikaBala: number;
  drikBala: number;
  totalVirupas: number;
  totalRupas: number;
  requiredRupas: number;
  ratio: number;
  rank: number;
}

export interface DashaPeriod {
  planet: string;
  startDate: Date;
  endDate: Date;
  years?: number;
  level: number;
  subPeriods?: DashaPeriod[];
  nominalStart?: Date;
}

export interface SpecialPointsResult {
  bhriguBinduRashi: string;
  bhriguBinduRashiDeg: number;
  bhriguBinduHouse: number;
  yogiPlanet: string;
  yogiRashi: string;
  yogiNakshatra: string;
  sahayogiPlanet: string;
  avayogiPlanet: string;
  avayogiRashi: string;
  avayogiNakshatra: string;
  charaKarakas: Array<{
    name: string;
    nameTelugu: string;
    planet: string;
    planetTelugu: string;
    rashiTelugu: string;
    degreeInRashi: number;
  }>;
}

export interface DoshaAnalysis {
  kujaDosha: {
    hasDosha: boolean;
    description: string;
  };
  kaalSarpa: {
    hasDosha: boolean;
    teluguTypeName: string;
    description: string;
  };
}

export enum DivisionalChartType {
  d1 = 'd1',
  d2 = 'd2',
  d3 = 'd3',
  d4 = 'd4',
  d7 = 'd7',
  d9 = 'd9',
  d10 = 'd10',
  d12 = 'd12',
  d16 = 'd16',
  d20 = 'd20',
  d24 = 'd24',
  d27 = 'd27',
  d30 = 'd30',
  d40 = 'd40',
  d45 = 'd45',
  d60 = 'd60'
}

