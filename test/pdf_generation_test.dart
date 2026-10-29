import 'package:flutter_test/flutter_test.dart';
import 'package:jhora_mobile/data/models/birth_data.dart';
import 'package:jhora_mobile/data/services/astro_engine.dart';
import 'package:jhora_mobile/data/services/ashtakavarga_service.dart';
import 'package:jhora_mobile/data/services/shadbala_service.dart';
import 'package:jhora_mobile/data/services/yoga_service.dart';
import 'package:jhora_mobile/data/services/dosha_service.dart';
import 'package:jhora_mobile/data/services/dasha_service.dart';
import 'package:jhora_mobile/data/services/transit_service.dart';
import 'package:jhora_mobile/data/services/telugu_pdf_document_builder.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Generate Telugu Horoscope PDF bytes', () async {
    final birthData = BirthData(
      name: 'శ్రీనివాస రావు',
      dateTime: DateTime(1990, 5, 15, 10, 30),
      latitude: 16.5925,
      longitude: 81.3789,
      timezone: 5.5,
      placeName: 'ఆకివీడు (Akividu)',
    );

    final chartData = AstroEngine.calculateChart(birthData);
    final ashtakavarga = AshtakavargaService.calculate(chartData);
    final shadbala = ShadbalaService.calculate(chartData);
    final yogas = YogaService.detectYogas(chartData);
    final dosha = DoshaService.analyze(chartData);
    final dashas = DashaService.calculateMahaDasha(
      chartData.getPlanet('Moon')!,
      birthData.dateTime,
    );
    final gochar = TransitService.calculateGochar(
      natalChart: chartData,
      transitDate: DateTime.now(),
      ashtakavarga: ashtakavarga,
    );

    final pdfBytes = await TeluguPdfDocumentBuilder.generatePdfBytes(
      chartData: chartData,
      ashtakavarga: ashtakavarga,
      shadbala: shadbala,
      yogas: yogas,
      dosha: dosha,
      dashas: dashas,
      gochar: gochar,
    );

    expect(pdfBytes.isNotEmpty, true);
    final header = String.fromCharCodes(pdfBytes.take(5));
    expect(header, '%PDF-');
    // print('SUCCESS: Valid Telugu PDF generated with size: ${pdfBytes.length} bytes');
  });
}
