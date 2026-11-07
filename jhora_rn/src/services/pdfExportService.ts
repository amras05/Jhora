import { Platform } from 'react-native';
import * as Print from 'expo-print';
import * as Sharing from 'expo-sharing';
import * as FileSystem from 'expo-file-system/legacy';
import {
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  DashaPeriod,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
} from '../models/astroModels';
import {
  TeluguPdfReportGenerator,
  PdfOptions,
} from './teluguPdfReportGenerator';

export type PdfStage = 'idle' | 'preparing' | 'generating' | 'saving' | 'complete' | 'error';

import { VedicYoga } from './yogaService';
import { GocharAnalysis } from './transitService';

export interface SavedReport {
  name: string;
  fileName: string;
  uri: string;
  sizeBytes: number;
  sizeFormatted: string;
  pageCount: number;
  createdAt: number;
  dateFormatted: string;
}

export interface PdfReportParams {
  chartData: ChartData;
  ashtakavarga: AshtakavargaData;
  shadbala: PlanetShadbala[];
  special: SpecialPointsResult;
  panchanga: PanchangaData;
  dosha: DoshaAnalysis;
  dashas: DashaPeriod[];
  yogas?: VedicYoga[];
  gochar?: GocharAnalysis;
}

export class PdfExportService {
  static get reportDir(): string {
    const docDir = FileSystem.documentDirectory || '';
    return `${docDir}reports/`;
  }

  static get safPrefFile(): string {
    const docDir = FileSystem.documentDirectory || '';
    return `${docDir}saf_pref_dir.txt`;
  }

  /**
   * Format byte count into human readable KB / MB
   */
  static formatBytes(bytes: number): string {
    if (!bytes || bytes <= 0) return '0 KB';
    if (bytes < 1024 * 1024) {
      return `${(bytes / 1024).toFixed(1)} KB`;
    }
    return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
  }

  /**
   * Generates PDF completely offline, moves to persistent in-app storage,
   * without giant base64 memory overhead.
   */
  static async createReport(
    params: PdfReportParams,
    options?: PdfOptions,
    onStage?: (stage: PdfStage, message?: string) => void
  ): Promise<{
    uri: string;
    fileName: string;
    sizeBytes: number;
    pageCount: number;
    report: SavedReport;
  }> {
    try {
      onStage?.('preparing', 'సమాచారం సిద్ధం చేస్తోంది (Preparing data...)');

      const pageCount = TeluguPdfReportGenerator.countTotalPages(options);
      const html = TeluguPdfReportGenerator.generateHtml(params, options);

      const rawName = params.chartData.birthData.name || 'Jathaka_Chakram';
      const safeName = rawName.replace(/[^a-zA-Z0-9_\u0C00-\u0C7F]/g, '_');
      const timeStamp = new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19);
      const fileName = `${safeName}_${pageCount}Pages_${timeStamp}.pdf`;

      onStage?.('generating', `PDF రూపకల్పన జరుగుతోంది (${pageCount} పుటలు)...`);

      // Expo Print: A4 format is 595 x 842 points.
      // base64: false ensures minimal memory footprint even on 25-page reports.
      const printResult = await Print.printToFileAsync({
        html,
        width: 595,
        height: 842,
        base64: false,
      });

      onStage?.('saving', 'నివేదికను భద్రపరుస్తోంది (Saving report...)');

      const dir = this.reportDir;
      const dirInfo = await FileSystem.getInfoAsync(dir);
      if (!dirInfo.exists) {
        await FileSystem.makeDirectoryAsync(dir, { intermediates: true });
      }

      const persistentUri = `${dir}${fileName}`;
      await FileSystem.copyAsync({
        from: printResult.uri,
        to: persistentUri,
      });

      // Obtain file size
      const fileInfo = await FileSystem.getInfoAsync(persistentUri);
      const sizeBytes = (fileInfo as any).size || 0;
      const createdAt = Date.now();

      const report: SavedReport = {
        name: rawName,
        fileName,
        uri: persistentUri,
        sizeBytes,
        sizeFormatted: this.formatBytes(sizeBytes),
        pageCount,
        createdAt,
        dateFormatted: new Date(createdAt).toLocaleDateString('te-IN', {
          year: 'numeric',
          month: 'short',
          day: 'numeric',
        }),
      };

      onStage?.('complete', 'PDF విజయవంతంగా రూపొందించబడింది');

      return {
        uri: persistentUri,
        fileName,
        sizeBytes,
        pageCount,
        report,
      };
    } catch (err: any) {
      onStage?.('error', err?.message || 'PDF Generation Error');
      throw err;
    }
  }

  /**
   * Save the PDF directly to device user storage (Downloads / Documents / Files).
   * Remembers Android SAF directory preference for one-tap subsequent saves.
   */
  static async saveToPhone(
    uri: string,
    fileName: string
  ): Promise<{ ok: boolean; message: string; where?: string }> {
    try {
      // 1. Web direct download
      if (Platform.OS === 'web' && typeof window !== 'undefined') {
        const base64 = await FileSystem.readAsStringAsync(uri, {
          encoding: FileSystem.EncodingType.Base64,
        });
        const byteCharacters = atob(base64);
        const byteNumbers = new Array(byteCharacters.length);
        for (let i = 0; i < byteCharacters.length; i++) {
          byteNumbers[i] = byteCharacters.charCodeAt(i);
        }
        const byteArray = new Uint8Array(byteNumbers);
        const blob = new Blob([byteArray], { type: 'application/pdf' });
        const blobUrl = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = blobUrl;
        link.download = fileName;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        URL.revokeObjectURL(blobUrl);
        return { ok: true, message: 'PDF బ్రౌజర్‌లో డౌన్‌లోడ్ చేయబడింది', where: 'Downloads' };
      }

      // 2. Android StorageAccessFramework (Direct folder save without repeated prompts)
      if (Platform.OS === 'android' && FileSystem.StorageAccessFramework) {
        let destinationDirUri: string | null = null;

        // Check if we already have a remembered folder permission
        try {
          const prefInfo = await FileSystem.getInfoAsync(this.safPrefFile);
          if (prefInfo.exists) {
            const savedUri = await FileSystem.readAsStringAsync(this.safPrefFile);
            if (savedUri && savedUri.trim().length > 0) {
              destinationDirUri = savedUri.trim();
            }
          }
        } catch (_) {
          // ignore pref read error
        }

        const base64 = await FileSystem.readAsStringAsync(uri, {
          encoding: FileSystem.EncodingType.Base64,
        });

        // Try writing to remembered directory first
        if (destinationDirUri) {
          try {
            const destFileUri = await FileSystem.StorageAccessFramework.createFileAsync(
              destinationDirUri,
              fileName,
              'application/pdf'
            );
            await FileSystem.writeAsStringAsync(destFileUri, base64, {
              encoding: FileSystem.EncodingType.Base64,
            });
            return {
              ok: true,
              message: 'PDF మీ ఎంచుకున్న ఫోల్డర్‌లో విజయవంతంగా భద్రపరచబడింది',
              where: 'Selected Folder',
            };
          } catch (safWriteErr) {
            // Permission might have expired or folder moved, fallback to requesting permission
            destinationDirUri = null;
          }
        }

        // Request directory permission from user
        try {
          const permissions = await FileSystem.StorageAccessFramework.requestDirectoryPermissionsAsync();
          if (permissions.granted) {
            // Save directory permission for next time
            try {
              await FileSystem.writeAsStringAsync(this.safPrefFile, permissions.directoryUri);
            } catch (_) {}

            const destFileUri = await FileSystem.StorageAccessFramework.createFileAsync(
              permissions.directoryUri,
              fileName,
              'application/pdf'
            );
            await FileSystem.writeAsStringAsync(destFileUri, base64, {
              encoding: FileSystem.EncodingType.Base64,
            });
            return {
              ok: true,
              message: 'PDF మీ ఎంచుకున్న ఫోల్డర్‌లో విజయవంతంగా భద్రపరచబడింది',
              where: 'Selected Folder',
            };
          }
        } catch (promptErr) {
          console.warn('SAF directory prompt error, falling back to Sharing:', promptErr);
        }
      }

      // 3. Fallback: Native Share Sheet (Save to Files on iOS / Android)
      const isAvailable = await Sharing.isAvailableAsync();
      if (isAvailable) {
        let shareTarget = uri;
        if (shareTarget.startsWith('content://')) {
          const cacheDir = FileSystem.cacheDirectory || FileSystem.documentDirectory || '';
          const tempPath = `${cacheDir}share_${Date.now()}.pdf`;
          await FileSystem.copyAsync({
            from: shareTarget,
            to: tempPath,
          });
          shareTarget = tempPath;
        } else if (!shareTarget.startsWith('file://')) {
          shareTarget = `file://${shareTarget}`;
        }

        await Sharing.shareAsync(shareTarget, {
          UTI: '.pdf',
          mimeType: 'application/pdf',
          dialogTitle: `${fileName} - జాతక చక్రం PDF`,
        });
        return {
          ok: true,
          message: 'PDF షేర్ / ఫైల్స్‌లో భద్రపరచబడింది',
          where: 'Files / Share',
        };
      }

      return {
        ok: true,
        message: `PDF భద్రపరచబడింది: ${uri}`,
        where: 'App Storage',
      };
    } catch (err: any) {
      console.error('Save to phone error:', err);
      return {
        ok: false,
        message: err?.message || 'ఫైల్ భద్రపరచడంలో లోపం ఏర్పడింది',
      };
    }
  }

  /**
   * Opens / Shares the PDF file safely with Android file:// scheme requirement
   */
  static async openReport(uri: string): Promise<void> {
    const isAvailable = await Sharing.isAvailableAsync();
    if (!isAvailable) {
      throw new Error('Sharing is not available on this device');
    }

    let targetUri = uri;
    if (targetUri.startsWith('content://')) {
      const cacheDir = FileSystem.cacheDirectory || FileSystem.documentDirectory || '';
      const tempPath = `${cacheDir}share_${Date.now()}.pdf`;
      await FileSystem.copyAsync({
        from: targetUri,
        to: tempPath,
      });
      targetUri = tempPath;
    } else if (!targetUri.startsWith('file://')) {
      targetUri = `file://${targetUri}`;
    }

    await Sharing.shareAsync(targetUri, {
      UTI: '.pdf',
      mimeType: 'application/pdf',
    });
  }

  /**
   * Lists all previously generated reports stored in app
   */
  static async listReports(): Promise<SavedReport[]> {
    try {
      const dir = this.reportDir;
      const dirInfo = await FileSystem.getInfoAsync(dir);
      if (!dirInfo.exists) return [];

      const files = await FileSystem.readDirectoryAsync(dir);
      const pdfFiles = files.filter(f => f.toLowerCase().endsWith('.pdf'));

      const reports: SavedReport[] = [];
      for (const f of pdfFiles) {
        const fileUri = `${dir}${f}`;
        const fileInfo = await FileSystem.getInfoAsync(fileUri);
        const sizeBytes = (fileInfo as any).size || 0;
        const modifiedTime = (fileInfo as any).modificationTime
          ? (fileInfo as any).modificationTime * 1000
          : Date.now();

        // Extract name & page count from filename if matched
        const parts = f.split('_');
        const name = parts[0] || 'Jathaka';
        let pageCount = 25;
        const pageMatch = f.match(/_(\d+)Pages_/);
        if (pageMatch && pageMatch[1]) {
          pageCount = parseInt(pageMatch[1], 10);
        }

        reports.push({
          name,
          fileName: f,
          uri: fileUri,
          sizeBytes,
          sizeFormatted: this.formatBytes(sizeBytes),
          pageCount,
          createdAt: modifiedTime,
          dateFormatted: new Date(modifiedTime).toLocaleDateString('te-IN', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
          }),
        });
      }

      // Sort newest first
      reports.sort((a, b) => b.createdAt - a.createdAt);
      return reports;
    } catch (err) {
      console.warn('Failed to list reports:', err);
      return [];
    }
  }

  /**
   * Deletes a report from persistent storage
   */
  static async deleteReport(uri: string): Promise<boolean> {
    try {
      await FileSystem.deleteAsync(uri, { idempotent: true });
      return true;
    } catch (err) {
      console.warn('Failed to delete report:', err);
      return false;
    }
  }

  /**
   * Backward compatible export method
   */
  static async exportTeluguPdfReport(params: PdfReportParams): Promise<{
    uri?: string;
    success: boolean;
    message: string;
  }> {
    try {
      const created = await this.createReport(params);
      const saveRes = await this.saveToPhone(created.uri, created.fileName);
      return {
        uri: created.uri,
        success: saveRes.ok,
        message: saveRes.message,
      };
    } catch (e: any) {
      return {
        success: false,
        message: e?.message || 'Error occurred while exporting PDF',
      };
    }
  }
}
