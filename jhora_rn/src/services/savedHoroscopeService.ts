import { Paths, File } from 'expo-file-system';
import { BirthData } from '../models/astroModels';

export class SavedHoroscopeService {
  private static memCache: BirthData[] = [
    {
      name: 'శ్రీ వెంకటేశ్వర రావు (Sample)',
      dateTime: new Date(1990, 7, 15, 10, 30, 0),
      latitude: 16.5062,
      longitude: 80.6480,
      timezone: 5.5,
      placeName: 'విజయవాడ (Vijayawada)',
      gender: 'పురుషుడు',
    },
  ];

  static async load(): Promise<BirthData[]> {
    try {
      const file = new File(Paths.document, 'saved_horoscopes.json');
      if (file.exists) {
        const text = await file.text();
        const raw = JSON.parse(text) as any[];
        const parsed = raw.map(item => ({
          ...item,
          dateTime: new Date(item.dateTime),
        }));
        this.memCache = parsed;
        return parsed;
      }
    } catch (_) {
      // Return memory cache
    }
    return this.memCache;
  }

  static async save(profile: BirthData): Promise<void> {
    if (!profile.id) {
      profile.id = `${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
    }
    const existing = await this.load();
    const filtered = existing.filter(p => (profile.id ? p.id !== profile.id : p.name !== profile.name));
    filtered.unshift(profile);
    this.memCache = filtered;

    try {
      const file = new File(Paths.document, 'saved_horoscopes.json');
      await file.write(JSON.stringify(filtered));
    } catch (err) {
      console.error('SavedHoroscopeService write error:', err);
    }
  }

  static async delete(idOrName: string): Promise<void> {
    const existing = await this.load();
    const filtered = existing.filter(p => p.id !== idOrName && p.name !== idOrName);
    this.memCache = filtered;

    try {
      const file = new File(Paths.document, 'saved_horoscopes.json');
      await file.write(JSON.stringify(filtered));
    } catch (err) {
      console.error('SavedHoroscopeService delete write error:', err);
    }
  }
}

