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
import { TeluguPdfReportGenerator } from './teluguPdfReportGenerator';

export class PdfExportService {
  /**
   * Generates the 25-page Telugu report and saves directly as a PDF document.
   * Does NOT open the print dialog; saves directly to user's storage/device.
   */
  static async exportTeluguPdfReport(params: {
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    special: SpecialPointsResult;
    panchanga: PanchangaData;
    dosha: DoshaAnalysis;
    dashas: DashaPeriod[];
  }): Promise<{ uri?: string; success: boolean; message: string }> {
    try {
      // 1. Generate full 25-page HTML
      const html = TeluguPdfReportGenerator.generateHtml(params);
      const safeName = (params.chartData.birthData.name || 'Jathaka_Chakram')
        .replace(/[^a-zA-Z0-9_\u0C00-\u0C7F]/g, '_');

      // 2. Generate PDF file (with base64 data)
      const { uri, base64 } = await Print.printToFileAsync({
        html,
        base64: true,
      });

      // 3. Web direct file download
      if (Platform.OS === 'web' && typeof window !== 'undefined' && base64) {
        try {
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
          link.download = `${safeName}_25_Pages_Report.pdf`;
          document.body.appendChild(link);
          link.click();
          document.body.removeChild(link);
          URL.revokeObjectURL(blobUrl);
          return { uri, success: true, message: 'PDF నేరుగా డౌన్‌లోడ్ చేయబడింది (PDF downloaded directly)' };
        } catch (webErr) {
          console.warn('Web download error:', webErr);
        }
      }

      // 4. Android Direct Storage Save (StorageAccessFramework)
      if (Platform.OS === 'android' && base64) {
        try {
          // Ask user to pick destination directory (e.g., Downloads, Documents)
          const permissions = await FileSystem.StorageAccessFramework.requestDirectoryPermissionsAsync();
          if (permissions.granted) {
            const destinationUri = await FileSystem.StorageAccessFramework.createFileAsync(
              permissions.directoryUri,
              `${safeName}_25_Pages_Report.pdf`,
              'application/pdf'
            );
            await FileSystem.writeAsStringAsync(destinationUri, base64, {
              encoding: FileSystem.EncodingType.Base64,
            });
            return {
              uri: destinationUri,
              success: true,
              message: 'PDF మీ ఎంచుకున్న ఫోల్డర్‌లో విజయవంతంగా భద్రపరచబడింది (Saved directly to folder)',
            };
          }
        } catch (safErr) {
          console.warn('StorageAccessFramework failed, trying content URI sharing:', safErr);
        }
      }

      // 5. Fallback via Native FileProvider Content URI (Save to Files / Share dialog)
      let targetUri = uri;
      if (Platform.OS === 'android') {
        try {
          targetUri = await FileSystem.getContentUriAsync(uri);
        } catch (_) {
          targetUri = uri;
        }
      }

      const isAvailable = await Sharing.isAvailableAsync();
      if (isAvailable) {
        await Sharing.shareAsync(targetUri, {
          UTI: '.pdf',
          mimeType: 'application/pdf',
          dialogTitle: `${safeName} - సంపూర్ణ 25 పుటల జాతక చక్రం PDF`,
        });
        return {
          uri: targetUri,
          success: true,
          message: 'PDF విజయవంతంగా భద్రపరచబడింది (PDF saved successfully)',
        };
      }

      return {
        uri,
        success: true,
        message: `PDF భద్రపరచబడింది: ${uri}`,
      };
    } catch (error: any) {
      console.error('PDF Export Error:', error);
      return {
        success: false,
        message: error?.message || 'Error occurred while saving PDF',
      };
    }
  }
}
