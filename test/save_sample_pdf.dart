import 'dart:io';
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

  test('Save sample Telugu Horoscope PDF', () async {
    final birthData = BirthData(
      name: 'కార్తికేయ శర్మ (Karthikeya Sarma)',
      dateTime: DateTime(2003, 10, 6, 10, 35),
      latitude: 16.5823,
      longitude: 81.3811,
      timezone: 5.5,
      placeName: 'ఆకివీడు (Akividu), West Godavari',
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

    final file = File('/home/karrthikuuuuu/Documents/Projects/jhora_mobile/sample_report.pdf');
    await file.writeAsBytes(pdfBytes);
  });
}
