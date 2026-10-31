import { AstroConstants } from '../constants/astroConstants';
import {
  ChartData,
  AshtakavargaData,
  PlanetShadbala,
  DashaPeriod,
  SpecialPointsResult,
  PanchangaData,
  DoshaAnalysis,
  DivisionalChartType,
  PlanetPosition,
} from '../models/astroModels';
import { DivisionalChartService } from './divisionalChartService';
import { DashaService } from './dashaService';

/**
 * Professional, complete 25-Page Telugu Vedic Astrology Report Generator
 * (|| శ్రీరస్తు శుభమస్తు విజయోస్తు || - సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం)
 */
export class TeluguPdfReportGenerator {
  static readonly blessingHeader = 'శ్రీరస్తు శుభమస్తు విజయోస్తు';
  static readonly guruBlessing = 'మా గురు,పితృదేవతల ఆశీర్వాదముతో';
  static readonly appTitle = 'సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం';
  static readonly expertiseLine = 'జ్యోతిష,వాస్తు,సంఖ్యాశాస్త్ర, ఆరాస్కానర్ నిపుణులు.';
  static readonly astrologerTitleAndMobile = 'జ్యోతిష విద్యాభూషణ-M.B.S.Sastry-9030166610';
  static readonly astrologerName = 'M.B.S.Sastry';
  static readonly astrologerMobile = '9030166610';
  static readonly astrologerAddress = 'భవానీపురం, విజయవాడ - 12 (BHAVANIPURAM VIJAYAWADA 12)';
  static readonly invocationShloka = 'జననీ జన్మ సౌఖ్యానాం,వర్ధనీ కుల సంపదాం!\nపదవీ పూర్వ పుణ్యానాం, లిఖ్యతే జన్మపత్రికా!!';

  static readonly weekdaysTelugu = [
    'ఆదివారం', 'సోమవారం', 'మంగళవారం', 'బుధవారం', 'గురువారం', 'శుక్రవారం', 'శనివారం'
  ];

  static readonly tithisTelugu = [
    'పాడ్యమి', 'విదియ', 'తదియ', 'చవితి', 'పంచమి',
    'షష్ఠి', 'సప్తమి', 'అష్టమి', 'నవమి', 'దశమి',
    'ఏకాదశి', 'ద్వాదశి', 'త్రయోదశి', 'చతుర్దశి', 'పూర్ణిమ',
    'పాడ్యమి', 'విదియ', 'తదియ', 'చవితి', 'పంచమి',
    'షష్ఠి', 'సప్తమి', 'అష్టమి', 'నవమి', 'దశమి',
    'ఏకాదశి', 'ద్వాదశి', 'త్రయోదశి', 'చతుర్దశి', 'అమావాస్య'
  ];

  static readonly yogasTelugu = [
    'విష్కంభం', 'ప్రీతి', 'ఆయుష్మాన్', 'సౌభాగ్యం', 'శోభనం',
    'అతిగండం', 'సుకర్మ', 'ధృతి', 'శూల', 'గండం',
    'వృద్ధి', 'ధ్రువం', 'వ్యాఘాతం', 'హర్షణ', 'వజ్రం',
    'సిద్ధి', 'వ్యతీపాతం', 'వరీయాన్', 'పరిఘ', 'శివ',
    'సిద్ధ', 'సాధ్య', 'శుభం', 'శుభ్రం', 'బ్రహ్మ',
    'ఐంద్రం', 'వైధృతి'
  ];

  static readonly karanasTelugu: Record<string, string> = {
    Bava: 'బవ',
    Balava: 'బాలవ',
    Kaulava: 'కౌలవ',
    Taitila: 'తైతుల',
    Gara: 'గరజ',
    Vanija: 'వణిజ',
    Vishti: 'విష్టి (భద్ర)',
    Kimstughna: 'కింస్తుఘ్నం',
    Shakuni: 'శకుని',
    Chatushpada: 'చతుష్పాత్',
    Naga: 'నాగవాని',
  };

  static generateHtml(params: {
    chartData: ChartData;
    ashtakavarga: AshtakavargaData;
    shadbala: PlanetShadbala[];
    special: SpecialPointsResult;
    panchanga: PanchangaData;
    dosha: DoshaAnalysis;
    dashas: DashaPeriod[];
  }): string {
    const { chartData, ashtakavarga, shadbala, special, panchanga, dashas } = params;
    const birth = chartData.birthData;
    const moon = chartData.planets.find(p => p.name === 'Moon') || chartData.planets[1];

    const weekdayTel = this.weekdaysTelugu[birth.dateTime.getDay() % 7];
    const tithiTel = `${panchanga.paksha === 'Shukla Paksha' ? 'శుక్ల పక్ష' : 'కృష్ణ పక్ష'} ${this.tithisTelugu[panchanga.tithiIndex % 30]}`;
    const nakTel = `${AstroConstants.nakshatrasTelugu[moon.nakshatraIndex]} (${moon.pada}వ పాదం)`;
    const yogaTel = this.yogasTelugu[panchanga.yogaIndex % 27];
    const karanaTel = this.karanasTelugu[panchanga.karana] || panchanga.karana;

    const now = new Date();
    const limit80 = new Date(birth.dateTime.getTime() + 80 * 365.2425 * 86400 * 1000);

    const out: string[] = [];

    out.push('<!DOCTYPE html>');
    out.push('<html lang="te">');
    out.push('<head>');
    out.push('<meta charset="UTF-8">');
    out.push(`<title>${this.blessingHeader} • ${this.appTitle} - ${birth.name || 'జాతక చక్రము'}</title>`);
    out.push('<style>');
    out.push('  @import url("https://fonts.googleapis.com/css2?family=Tiro+Telugu:ital@0;1&family=Ramabhadra&family=Noto+Sans+Telugu:wght@400;600;700;800&display=swap");');
    out.push('  @page { size: 210mm 297mm; margin: 0; }');
    out.push('  * { box-sizing: border-box; -webkit-print-color-adjust: exact !important; print-color-adjust: exact !important; }');
    out.push('  html, body { width: 210mm; margin: 0; padding: 0; background: #ffffff; font-family: "Tiro Telugu", "Noto Sans Telugu", "Ramabhadra", serif, "Arial Unicode MS"; color: #2b1d0c; font-size: 8.5pt; line-height: 1.3; }');
    out.push('  .page-card { width: 210mm; height: 297mm; max-height: 297mm; min-height: 297mm; box-sizing: border-box; padding: 6mm 8mm 6mm 8mm; margin: 0 !important; background: #ffffff; border: 1.5px solid #d4af37; page-break-after: always !important; break-after: page !important; page-break-inside: avoid !important; break-inside: avoid !important; overflow: hidden !important; display: flex; flex-direction: column; justify-content: space-between; }');
    out.push('  .page-card:last-child, .page-card:last-of-type { page-break-after: avoid !important; break-after: avoid !important; }');
    out.push('  .page-content { flex: 1; overflow: hidden; }');
    out.push('  .main-header { text-align: center; border: 1.5px solid #8b2500; outline: 1px solid #d4af37; outline-offset: -3px; background: radial-gradient(circle at 50% 20%, #ffffff 0%, #fffcf2 45%, #faedd7 100%); padding: 8px 12px 6px 12px; border-radius: 6px; margin-bottom: 8px; box-shadow: 0 2px 8px rgba(107, 17, 17, 0.06); }');
    out.push('  .top-blessing-row { display: flex; justify-content: center; align-items: center; gap: 6px; margin-bottom: 1px; }');
    out.push('  .top-blessing { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 11.5pt; font-weight: 800; color: #8b2500; margin: 0; letter-spacing: 0.5px; }');
    out.push('  .guru-blessing { font-family: "Tiro Telugu", "Noto Sans Telugu", serif; font-size: 9.5pt; font-weight: 700; color: #92400e; font-style: italic; margin: 1px 0 2px 0; }');
    out.push('  .title-ornament { color: #d4af37; font-size: 10pt; }');
    out.push('  .app-title { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 16pt; font-weight: 800; color: #6b1111; margin: 2px 0 1px 0; letter-spacing: 0.4px; }');
    out.push('  .title-divider { display: flex; align-items: center; justify-content: center; gap: 8px; margin: 2px 0; }');
    out.push('  .title-divider-line { flex: 1; max-width: 80px; height: 1px; background: linear-gradient(90deg, transparent, #d4af37, #8b2500, #d4af37, transparent); }');
    out.push('  .expertise-bar { font-size: 9pt; font-weight: 700; color: #78350f; margin-top: 1px; }');
    out.push('  .scholar-pill { display: inline-block; background: #6b1111; color: #ffffff; padding: 2px 10px; border-radius: 12px; font-size: 9.5pt; font-weight: 800; margin-top: 3px; letter-spacing: 0.2px; }');
    out.push('  .sloka-box { margin-top: 5px; font-size: 8.5pt; font-weight: 700; color: #6b1111; border-top: 1px dashed #d4af37; padding-top: 4px; line-height: 1.3; font-style: normal; }');
    out.push('  .sub-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1.2px solid #d4af37; background: #fffbf0; padding: 3px 6px; margin-bottom: 5px; font-size: 8pt; font-weight: 700; color: #6b1111; }');
    out.push('  .section-title { font-family: "Ramabhadra", "Noto Sans Telugu", serif; font-size: 9.5pt; font-weight: 700; color: #6b1111; background: #fdecc8; padding: 2.5px 6px; border-left: 4px solid #6b1111; border-radius: 2px; margin: 5px 0 3px 0; }');
    out.push('  .grid-2 { display: flex; gap: 8px; }');
    out.push('  .grid-2 > div { flex: 1; }');
    out.push('  table.data-table { width: 100%; border-collapse: collapse; margin: 2px 0 4px 0; font-size: 7.5pt; }');
    out.push('  table.data-table th { background: #6b1111; color: #ffffff; font-weight: 700; padding: 2px 4px; border: 1px solid #6b1111; text-align: center; font-size: 7.5pt; }');
    out.push('  table.data-table td { border: 1px solid #d4af37; padding: 2px 4px; color: #220f00; font-size: 7.5pt; }');
    out.push('  table.data-table tr:nth-child(even) { background: #fdfbf7; }');
    out.push('  .bold { font-weight: 700; }');
    out.push('  .center { text-align: center; }');
    out.push('  .gold-text { color: #8b2500; font-weight: 700; }');
    out.push('  .chart-header-title { text-align: center; font-weight: 700; color: #6b1111; font-size: 8pt; margin-bottom: 2px; background: #fffbf0; padding: 1.5px 3px; border-radius: 3px; border: 1px solid #d4af37; }');
    out.push('  .si-chart { display: grid; grid-template-columns: repeat(4, 1fr); grid-template-rows: repeat(4, 1fr); border: 1.5px solid #8b2500; width: 100%; max-width: 235px; height: 205px; margin: 0 auto; background: #ffffff; }');
    out.push('  .si-cell { border: 1px solid #d4af37; padding: 1px 2px; position: relative; font-size: 7pt; overflow: hidden; display: flex; flex-direction: column; justify-content: flex-start; }');
    out.push('  .si-cell.lagna-cell { background: #fff8eb; }');
    out.push('  .si-cell.center-box { grid-column: 2 / span 2; grid-row: 2 / span 2; background: #fffbf0; display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center; font-family: "Ramabhadra", serif; font-weight: 800; font-size: 9pt; color: #6b1111; border: 1.5px solid #8b2500; padding: 1.5px; line-height: 1.2; }');
    out.push('  .si-sign-name { font-size: 6pt; color: #78350f; font-weight: 700; line-height: 1; }');
    out.push('  .si-planets { font-size: 7pt; font-weight: 700; color: #1e293b; margin-top: 1px; line-height: 1.2; text-align: center; }');
    out.push('  .lagna-badge { color: #b91c1c; font-weight: 800; }');
    out.push('  .highlight-card { background: #fffbf0; border: 1.2px solid #d4af37; border-radius: 4px; padding: 4px 8px; margin: 4px 0; }');
    out.push('  .footer-note { margin-top: 4px; display: flex; justify-content: space-between; font-size: 7pt; color: #78350f; border-top: 1px solid #d4af37; padding-top: 2px; }');
    out.push('  @media print {');
    out.push('    @page { size: 210mm 297mm; margin: 0; }');
    out.push('    html, body { width: 210mm !important; margin: 0 !important; padding: 0 !important; background: #ffffff !important; }');
    out.push('    .no-print { display: none !important; }');
    out.push('    .page-card { width: 210mm !important; height: 297mm !important; max-height: 297mm !important; min-height: 297mm !important; margin: 0 !important; padding: 6mm 8mm 6mm 8mm !important; page-break-after: always !important; break-after: page !important; page-break-inside: avoid !important; break-inside: avoid !important; overflow: hidden !important; border: 1.5px solid #d4af37 !important; box-shadow: none !important; }');
    out.push('    .page-card:last-child, .page-card:last-of-type { page-break-after: avoid !important; break-after: avoid !important; }');
    out.push('  }');
    out.push('</style>');
    out.push('</head>');
    out.push('<body>');

    const totalReportPages = 25;

    // ── PAGE 1: ప్రాథమిక వివరాలు, పంచాంగం & నిరాయణ గ్రహ స్థానాలు ──
    out.push('<div class="page-card">');
    out.push('  <div class="page-content">');
    out.push('    <div class="main-header">');
    out.push('      <div class="top-blessing-row">');
    out.push('        <span class="title-ornament">卐</span>');
    out.push(`        <span class="top-blessing">|| ${this.blessingHeader} ||</span>`);
    out.push('        <span class="title-ornament">卐</span>');
    out.push('      </div>');
    out.push(`      <div class="guru-blessing">❖ ${this.guruBlessing} ❖</div>`);
    out.push('      <div class="title-divider">');
    out.push('        <div class="title-divider-line"></div>');
    out.push('        <span class="title-ornament">🪔</span>');
    out.push('        <div class="title-divider-line"></div>');
    out.push('      </div>');
    out.push(`      <h1 class="app-title">${this.appTitle}</h1>`);
    out.push(`      <div class="expertise-bar">${this.expertiseLine}</div>`);
    out.push(`      <div class="scholar-pill">${this.astrologerTitleAndMobile}</div>`);
    out.push(`      <div class="sloka-box">${this.invocationShloka.replace(/\n/g, '<br>')}</div>`);
    out.push('    </div>');

    out.push('    <div class="grid-2">');
    out.push('      <div>');
    out.push('        <div class="section-title">1. జాతక ప్రాథమిక వివరాలు</div>');
    out.push('        <table class="data-table">');
    out.push(`          <tr><td class="bold" style="width:38%;">పేరు:</td><td><b>${birth.name || 'శ్రీ / కుమారి'}</b></td></tr>`);
    out.push(`          <tr><td class="bold">తేదీ / వారం:</td><td>${this.formatDate(birth.dateTime)}, ${weekdayTel}</td></tr>`);
    out.push(`          <tr><td class="bold">సమయము:</td><td>${this.formatTime(birth.dateTime)}</td></tr>`);
    out.push(`          <tr><td class="bold">జన్మ స్థలము:</td><td>${birth.placeName}</td></tr>`);
    out.push(`          <tr><td class="bold">అక్షాంశ/రేఖాంశం:</td><td>${birth.latitude.toFixed(2)}° N, ${birth.longitude.toFixed(2)}° E</td></tr>`);
    out.push(`          <tr><td class="bold">ఆయనాంశము:</td><td>లాహిరి (${this.formatDms(chartData.ayanamsa)})</td></tr>`);
    out.push('        </table>');
    out.push('      </div>');
    out.push('      <div>');
    out.push('        <div class="section-title">2. జన్మ పంచాంగ వివరములు</div>');
    out.push('        <table class="data-table">');
    out.push(`          <tr><td class="bold" style="width:38%;">తిథి:</td><td><b>${tithiTel}</b></td></tr>`);
    out.push(`          <tr><td class="bold">జన్మ నక్షత్రం:</td><td><b>${nakTel}</b></td></tr>`);
    out.push(`          <tr><td class="bold">నిత్య యోగం:</td><td>${yogaTel}</td></tr>`);
    out.push(`          <tr><td class="bold">కరణం:</td><td>${karanaTel}</td></tr>`);
    out.push(`          <tr><td class="bold">సూర్యోదయ/అస్తమయం:</td><td>${this.formatTime(panchanga.sunrise)} / ${this.formatTime(panchanga.sunset)}</td></tr>`);
    out.push(`          <tr><td class="bold">రాహు కాలం:</td><td>${this.formatTime(panchanga.rahuKalam[0])} - ${this.formatTime(panchanga.rahuKalam[1])}</td></tr>`);
    out.push('        </table>');
    out.push('      </div>');
    out.push('    </div>');

    out.push('    <div class="section-title">3. నిరాయణ గ్రహ స్థితిగతుల సమగ్ర పట్టిక (Planetary Positions & Dignities)</div>');
    out.push('    <table class="data-table">');
    out.push('      <thead><tr><th>గ్రహము</th><th>రాశి</th><th>అంశలు (స్పష్టం)</th><th>నక్షత్రం</th><th>పాదం</th><th>నక్షత్రాధిపతి</th><th>స్థితి</th></tr></thead>');
    out.push('      <tbody>');
    out.push(`        <tr style="background:#fff3e0; font-weight:700;"><td class="center gold-text">లగ్నము</td><td class="center">${AstroConstants.rashisTelugu[chartData.ascendant.rashiIndex]}</td><td class="center">${this.formatDms(chartData.ascendant.degreesInRashi)}</td><td class="center">${AstroConstants.nakshatrasTelugu[chartData.ascendant.nakshatraIndex]}</td><td class="center">${chartData.ascendant.pada}</td><td class="center">${AstroConstants.nakshatraLordsTelugu[chartData.ascendant.nakshatraIndex]}</td><td class="center gold-text">లగ్న కేంద్రం</td></tr>`);
    for (const p of chartData.planets) {
      const pTel = AstroConstants.planetNamesTelugu[p.name] || p.name;
      const rTel = AstroConstants.rashisTelugu[p.rashiIndex];
      const nTel = AstroConstants.nakshatrasTelugu[p.nakshatraIndex];
      const lordTel = AstroConstants.nakshatraLordsTelugu[p.nakshatraIndex];
      const digTel = this.getTeluguDignity(p);
      const retro = p.isRetrograde ? ' <span style="color:#c2410c;">(వ)</span>' : '';
      const combust = p.isCombust ? ' <span style="color:#ea580c;">(మౌ)</span>' : '';
      out.push(`        <tr><td class="center bold">${pTel}${retro}${combust}</td><td class="center">${rTel}</td><td class="center">${this.formatDms(p.degreesInRashi)}</td><td class="center">${nTel}</td><td class="center">${p.pada}</td><td class="center">${lordTel}</td><td class="center bold">${digTel}</td></tr>`);
    }
    out.push('      </tbody></table>');
    out.push('    <div style="font-size:8pt; color:#6b1111; margin-top:4px;">సూచన: <span style="color:#c2410c; font-weight:700;">(వ)</span> = వక్ర గ్రహము (Retrograde) • <span style="color:#ea580c; font-weight:700;">(మౌ)</span> = మౌఢ్య / అస్తంగత గ్రహము (Combust by Sun).</div>');
    out.push('  </div>');
    out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట 1 / ${totalReportPages}</span></div>`);
    out.push('</div>');

    // ── PAGES 2 to 5: సమగ్ర షోడశవర్గ చక్రములు (16 Shodashavarga Charts) ──
    const vargaPages = [
      {
        pageNum: 2,
        title: 'షోడశవర్గ చక్రములు - భాగము 1 (D1, D9, D2, D3)',
        charts: [DivisionalChartType.d1, DivisionalChartType.d9, DivisionalChartType.d2, DivisionalChartType.d3],
      },
      {
        pageNum: 3,
        title: 'షోడశవర్గ చక్రములు - భాగము 2 (D4, D7, D10, D12)',
        charts: [DivisionalChartType.d4, DivisionalChartType.d7, DivisionalChartType.d10, DivisionalChartType.d12],
      },
      {
        pageNum: 4,
        title: 'షోడశవర్గ చక్రములు - భాగము 3 (D16, D20, D24, D27)',
        charts: [DivisionalChartType.d16, DivisionalChartType.d20, DivisionalChartType.d24, DivisionalChartType.d27],
      },
      {
        pageNum: 5,
        title: 'షోడశవర్గ చక్రములు - భాగము 4 (D30, D40, D45, D60)',
        charts: [DivisionalChartType.d30, DivisionalChartType.d40, DivisionalChartType.d45, DivisionalChartType.d60],
      },
    ];

    for (const vp of vargaPages) {
      out.push('<div class="page-card">');
      out.push('  <div class="page-content">');
      out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
      out.push(`    <div class="section-title">${vp.title}</div>`);

      out.push('    <div class="grid-2" style="margin-bottom: 8px;">');
      out.push('      <div>');
      out.push(`        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[0])}</div>`);
      out.push(this.buildDivisionalChartHtml(chartData, vp.charts[0]));
      out.push('      </div>');
      out.push('      <div>');
      out.push(`        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[1])}</div>`);
      out.push(this.buildDivisionalChartHtml(chartData, vp.charts[1]));
      out.push('      </div>');
      out.push('    </div>');

      out.push('    <div class="grid-2">');
      out.push('      <div>');
      out.push(`        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[2])}</div>`);
      out.push(this.buildDivisionalChartHtml(chartData, vp.charts[2]));
      out.push('      </div>');
      out.push('      <div>');
      out.push(`        <div class="chart-header-title">${DivisionalChartService.getDivisionalTitle(vp.charts[3])}</div>`);
      out.push(this.buildDivisionalChartHtml(chartData, vp.charts[3]));
      out.push('      </div>');
      out.push('    </div>');

      out.push('  </div>');
      out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట ${vp.pageNum} / ${totalReportPages}</span></div>`);
      out.push('</div>');
    }

    // ── PAGE 6: ద్వాదశ భావ స్ఫుట పట్టిక & సర్వాష్టకవర్గము ──
    out.push('<div class="page-card">');
    out.push('  <div class="page-content">');
    out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
    out.push('    <div class="section-title">4. ద్వాదశ భావ స్ఫుట పట్టిక (12 Houses Bhava Sputa Patika & Lords)</div>');
    out.push('    <table class="data-table">');
    out.push('      <thead><tr><th>భావము</th><th>భావ ఆరంభము</th><th>భావ మధ్యము (స్ఫుటం)</th><th>భావ అంత్యము</th><th>భావాధిపతి</th></tr></thead><tbody>');
    const lagnaLon = chartData.ascendant.longitude;
    for (let i = 0; i < 12; i++) {
      const h = i + 1;
      const midLon = (lagnaLon + (h - 1) * 30.0) % 360.0;
      const startLon = (midLon - 15.0 + 360.0) % 360.0;
      const endLon = (midLon + 15.0) % 360.0;
      const rIdx = Math.floor(midLon / 30.0) % 12;
      const lord = AstroConstants.rashiLordsTelugu[rIdx];
      out.push(`        <tr><td class="center bold gold-text">${h}వ భావము</td><td class="center">${this.formatDms(startLon)}</td><td class="center bold">${this.formatDms(midLon)}</td><td class="center">${this.formatDms(endLon)}</td><td class="center bold">${lord}</td></tr>`);
    }
    out.push('      </tbody></table>');

    out.push('    <div class="section-title">5. సర్వాష్టకవర్గ చక్రము & 337 బిందువుల సమగ్ర పట్టిక (SAV 337)</div>');
    out.push('    <div class="grid-2" style="align-items:center;">');
    out.push('      <div>');
    out.push(this.buildSavChartHtml(ashtakavarga));
    out.push('      </div>');
    out.push('      <div>');
    out.push('        <table class="data-table" style="font-size:8pt;">');
    out.push('          <thead><tr><th>రాశి</th><th>రవి</th><th>చం</th><th>కు</th><th>బు</th><th>గు</th><th>శు</th><th>శని</th><th>SAV</th></tr></thead><tbody>');
    const planets7 = ['Sun', 'Moon', 'Mars', 'Mercury', 'Jupiter', 'Venus', 'Saturn'];
    for (let rIdx = 0; rIdx < 12; rIdx++) {
      const savPts = ashtakavarga.sav[rIdx] || 0;
      const isHigh = savPts >= 28;
      let rowHtml = `          <tr style="${isHigh ? 'background:#f0fdf4;' : ''}"><td class="bold">${AstroConstants.rashisTelugu[rIdx]}</td>`;
      for (const p of planets7) {
        const pts = ashtakavarga.bav[p]?.[rIdx] || 0;
        rowHtml += `<td class="center">${pts}</td>`;
      }
      rowHtml += `<td class="center bold ${isHigh ? 'gold-text' : ''}">${savPts}</td></tr>`;
      out.push(rowHtml);
    }
    out.push('        </tbody></table>');
    out.push('      </div>');
    out.push('    </div>');
    out.push('  </div>');
    out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట 6 / ${totalReportPages}</span></div>`);
    out.push('</div>');

    // ── PAGE 7: షడ్బల బలాబలాలు, భృగు బిందువు, యోగీ-అవయోగీ & చరకారకములు ──
    out.push('<div class="page-card">');
    out.push('  <div class="page-content">');
    out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
    out.push('    <div class="section-title">6. షడ్బల బలాబలాల సమగ్ర పట్టిక (Shadbala Strength Analysis)</div>');
    out.push('    <table class="data-table" style="font-size:8pt;">');
    out.push('      <thead><tr><th>గ్రహము</th><th>స్థాన</th><th>దిగ్</th><th>కాల</th><th>చేష్ట</th><th>నైసర్గిక</th><th>దృగ్</th><th>మొత్తం రూపాలు</th><th>ర్యాంకు</th></tr></thead><tbody>');
    for (const sb of shadbala) {
      const pTel = AstroConstants.planetNamesTelugu[sb.planetName] || sb.planetName;
      out.push(`      <tr><td class="bold">${pTel}</td><td class="center">${sb.sthanaBala.toFixed(0)}</td><td class="center">${sb.digBala.toFixed(0)}</td><td class="center">${sb.kalaBala.toFixed(0)}</td><td class="center">${sb.chestaBala.toFixed(0)}</td><td class="center">${sb.naisargikaBala.toFixed(0)}</td><td class="center">${sb.drikBala.toFixed(0)}</td><td class="center bold">${sb.totalRupas.toFixed(1)}</td><td class="center bold gold-text">#${sb.rank}</td></tr>`);
    }
    out.push('    </tbody></table>');

    out.push('    <div class="section-title">7. భృగు బిందువు, యోగీ-అవయోగీ & జైమిని 7 చరకారకములు</div>');
    out.push('    <div class="grid-2">');
    out.push('      <div>');
    out.push('        <table class="data-table">');
    out.push(`          <tr><td class="bold" style="width:42%;">భృగు బిందువు (Bhrigu Bindu):</td><td><b>${special.bhriguBinduRashi} (${this.formatDms(special.bhriguBinduRashiDeg)})</b><br><span style="font-size:8pt; color:#8b2500;">భాగ్య బిందువు (${special.bhriguBinduHouse}వ భావం)</span></td></tr>`);
    out.push(`          <tr><td class="bold">యోగ గ్రహము (Yogi):</td><td><b>${special.yogiPlanet}</b> (${special.yogiRashi} - ${special.yogiNakshatra})</td></tr>`);
    out.push(`          <tr><td class="bold">సహయోగి గ్రహము:</td><td><b>${special.sahayogiPlanet}</b></td></tr>`);
    out.push(`          <tr><td class="bold">అవయోగ గ్రహము:</td><td><b>${special.avayogiPlanet}</b> (${special.avayogiRashi} - ${special.avayogiNakshatra})</td></tr>`);
    out.push('        </table>');
    out.push('      </div>');
    out.push('      <div>');
    out.push('        <table class="data-table">');
    out.push('          <thead><tr><th>చరకారకము</th><th>గ్రహము</th><th>రాశి స్థానం</th></tr></thead><tbody>');
    for (const k of special.charaKarakas) {
      out.push(`          <tr><td class="bold gold-text">${k.nameTelugu}</td><td class="center bold">${k.planetTelugu}</td><td class="center">${k.rashiTelugu} (${this.formatDms(k.degreeInRashi)})</td></tr>`);
    }
    out.push('        </tbody></table>');
    out.push('      </div>');
    out.push('    </div>');

    out.push('    <div class="highlight-card" style="margin-top: 8px;">');
    out.push('      <div style="font-weight:700; color:#6b1111; font-size:9pt; margin-bottom:2px;">✦ భృగు బిందువు విశేష ఫలితము:</div>');
    out.push('      <div style="font-size:8pt; color:#3e1b00; line-height:1.35;">రాహువు నుండి చంద్రుని వరకు గల దూరపు ఖచ్చితమైన మధ్య బిందువునే "భృగు బిందువు" (Destiny Point) అంటారు. గోచార గురుడు లేదా శుభ గ్రహములు ఈ బిందువును సంధించిన కాలంలో భాగ్యోదయము, వివాహము, ఉద్యోగ ప్రాప్తి మరియు విశేష ధనలాభములు సిద్ధించును.</div>');
    out.push('    </div>');
    out.push('  </div>');
    out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట 7 / ${totalReportPages}</span></div>`);
    out.push('</div>');

    // ── PAGES 8 to 20: సంపూర్ణ వింశోత్తరి దశా మహాపట్టిక (80 Years - 5 Levels) ──
    const allAntars80: Array<{ mahaPlanet: string; antar: DashaPeriod; startAge: number; endAge: number }> = [];
    for (const m of dashas) {
      if (m.startDate.getTime() > limit80.getTime()) continue;
      const antars = DashaService.getSubPeriods(m);
      for (const a of antars) {
        if (a.startDate.getTime() < limit80.getTime()) {
          const sAge = (a.startDate.getTime() - birth.dateTime.getTime()) / (365.2425 * 86400 * 1000);
          const eAge = (a.endDate.getTime() - birth.dateTime.getTime()) / (365.2425 * 86400 * 1000);
          allAntars80.push({
            mahaPlanet: m.planet,
            antar: a,
            startAge: Math.max(0, sAge),
            endAge: eAge,
          });
        }
      }
    }

    // ── PAGE 8: మహాదశల సమగ్ర పట్టిక & అంతర్దశలు (0 - 40 సంవత్సరాలు) ──
    out.push('<div class="page-card">');
    out.push('  <div class="page-content">');
    out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
    out.push('    <div class="section-title">8. వింశోత్తరి మహాదశల సమగ్ర కాలపరిమితి పట్టిక (120-Year Mahadasha Overview)</div>');
    out.push('    <table class="data-table">');
    out.push('      <thead><tr><th>మహాదశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>వయస్సు కాలపరిమితి</th><th>స్థితి</th></tr></thead><tbody>');
    for (const d of dashas) {
      const pTel = AstroConstants.planetNamesTelugu[d.planet] || d.planet;
      const dur = ((d.endDate.getTime() - d.startDate.getTime()) / (365.25 * 86400 * 1000)).toFixed(1);
      const isCurrent = now >= d.startDate && now < d.endDate;
      const startAge = Math.min(120, Math.max(0, (d.startDate.getTime() - birth.dateTime.getTime()) / (365.25 * 86400 * 1000))).toFixed(1);
      const endAge = Math.min(120, Math.max(0, (d.endDate.getTime() - birth.dateTime.getTime()) / (365.25 * 86400 * 1000))).toFixed(1);
      out.push(`      <tr style="${isCurrent ? 'background:#fef3c7; font-weight:700;' : ''}"><td class="center bold">${pTel} మహాదశ</td><td class="center">${this.formatDate(d.startDate)}</td><td class="center">${this.formatDate(d.endDate)}</td><td class="center">${dur} సం.</td><td class="center">${startAge} నుండి ${endAge} సం.</td><td class="center ${isCurrent ? 'gold-text' : ''}">${isCurrent ? '★ ప్రస్తుతం' : 'పూర్తి కాలం'}</td></tr>`);
    }
    out.push('    </tbody></table>');

    const antars0to40 = allAntars80.filter(x => x.startAge < 40.0);
    out.push('    <div class="section-title">9. అంతర్దశల సమగ్ర కాలచక్రం (జన్మ నుండి 40 సంవత్సరాల వయస్సు వరకు)</div>');
    out.push('    <table class="data-table" style="font-size:7.5pt;">');
    out.push('      <thead><tr><th>క్రమ</th><th>మహా / అంతర దశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>వయస్సు</th><th>స్థితి</th></tr></thead><tbody>');
    for (let i = 0; i < antars0to40.length; i++) {
      const item = antars0to40[i];
      const mTel = AstroConstants.planetNamesTelugu[item.mahaPlanet] || item.mahaPlanet;
      const aTel = AstroConstants.planetNamesTelugu[item.antar.planet] || item.antar.planet;
      const isActive = now >= item.antar.startDate && now < item.antar.endDate;
      const isPast = item.antar.endDate < now;
      const status = isActive ? '★ ప్రస్తుతం' : (isPast ? 'గతించినది' : 'రాబోవునది');
      out.push(`      <tr style="${isActive ? 'background:#fef3c7; font-weight:700;' : (isPast ? 'color:#6b7280;' : '')}"><td class="center">${i + 1}</td><td class="bold">${mTel} / ${aTel}</td><td class="center">${this.formatDate(item.antar.startDate)}</td><td class="center">${this.formatDate(item.antar.endDate)}</td><td class="center">${DashaService.formatDuration(item.antar.startDate, item.antar.endDate)}</td><td class="center">${item.startAge.toFixed(1)} - ${item.endAge.toFixed(1)} సం.</td><td class="center ${isActive ? 'gold-text' : ''}">${status}</td></tr>`);
    }
    out.push('    </tbody></table>');
    out.push('  </div>');
    out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట 8 / ${totalReportPages}</span></div>`);
    out.push('</div>');

    // ── PAGE 9: అంతర్దశల సమగ్ర పట్టిక (40 నుండి 80+ సంవత్సరాలు) ──
    const antars40to80 = allAntars80.filter(x => x.startAge >= 40.0);
    out.push('<div class="page-card">');
    out.push('  <div class="page-content">');
    out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
    out.push('    <div class="section-title">10. అంతర్దశల సమగ్ర కాలచక్రం (40 నుండి 80+ సంవత్సరాల వయస్సు వరకు)</div>');
    out.push('    <table class="data-table" style="font-size:7.5pt;">');
    out.push('      <thead><tr><th>క్రమ</th><th>మహా / అంతర దశ</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>వయస్సు</th><th>స్థితి</th></tr></thead><tbody>');
    for (let i = 0; i < antars40to80.length; i++) {
      const item = antars40to80[i];
      const mTel = AstroConstants.planetNamesTelugu[item.mahaPlanet] || item.mahaPlanet;
      const aTel = AstroConstants.planetNamesTelugu[item.antar.planet] || item.antar.planet;
      const isActive = now >= item.antar.startDate && now < item.antar.endDate;
      const isPast = item.antar.endDate < now;
      const status = isActive ? '★ ప్రస్తుతం' : (isPast ? 'గతించినది' : 'రాబోవునది');
      out.push(`      <tr style="${isActive ? 'background:#fef3c7; font-weight:700;' : (isPast ? 'color:#6b7280;' : '')}"><td class="center">${antars0to40.length + i + 1}</td><td class="bold">${mTel} / ${aTel}</td><td class="center">${this.formatDate(item.antar.startDate)}</td><td class="center">${this.formatDate(item.antar.endDate)}</td><td class="center">${DashaService.formatDuration(item.antar.startDate, item.antar.endDate)}</td><td class="center">${item.startAge.toFixed(1)} - ${item.endAge.toFixed(1)} సం.</td><td class="center ${isActive ? 'gold-text' : ''}">${status}</td></tr>`);
    }
    out.push('    </tbody></table>');
    out.push('  </div>');
    out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట 9 / ${totalReportPages}</span></div>`);
    out.push('</div>');

    // ── PAGES 10 to 12: ప్రత్యంతర దశల సమగ్ర కాలచక్రం (Level 3 Pratyantar Dashas up to 80 Years) ──
    // 3 focal Antar groups per page = ~27 rows total, fits comfortably on 1 A4 page (<170mm)
    for (let pIdx = 0; pIdx < 3; pIdx++) {
      const pageNum = 10 + pIdx;
      const pStart = pIdx * 3;
      const pageAntars = allAntars80.slice(pStart, pStart + 3);

      out.push('<div class="page-card">');
      out.push('  <div class="page-content">');
      out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
      out.push(`    <div class="section-title">11.${pIdx + 1} ప్రత్యంతర దశల సమగ్ర పట్టిక (Level 3: Pratyantar Dashas - భాగము ${pIdx + 1})</div>`);

      for (const aItem of pageAntars) {
        const a = aItem.antar;
        const mTel = AstroConstants.planetNamesTelugu[aItem.mahaPlanet] || aItem.mahaPlanet;
        const aTel = AstroConstants.planetNamesTelugu[a.planet] || a.planet;
        const pdList = DashaService.getSubPeriods(a);

        out.push(`    <div style="font-size:7.5pt; font-weight:700; color:#6b1111; margin-top:3px; background:#fff7ed; padding:2px 6px; border-left:3px solid #8b2500;">✦ ${mTel} మహాదశ / ${aTel} అంతర (${this.formatDate(a.startDate)} నుండి ${this.formatDate(a.endDate)}):</div>`);
        out.push('    <table class="data-table" style="font-size:6.8pt; margin-bottom:3px;">');
        out.push('      <thead><tr><th>ప్రత్యంతర నాథుడు</th><th>ప్రారంభ తేదీ</th><th>ముగింపు తేదీ</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
        for (const pd of pdList) {
          const pdTel = AstroConstants.planetNamesTelugu[pd.planet] || pd.planet;
          const isPdActive = now >= pd.startDate && now < pd.endDate;
          out.push(`      <tr style="${isPdActive ? 'background:#ecfdf5; font-weight:700;' : ''}"><td class="center bold">${mTel}/${aTel}/${pdTel}</td><td class="center">${this.formatDate(pd.startDate)}</td><td class="center">${this.formatDate(pd.endDate)}</td><td class="center">${DashaService.formatDuration(pd.startDate, pd.endDate)}</td><td class="center ${isPdActive ? 'gold-text' : ''}">${isPdActive ? '★ ప్రస్తుతం' : ''}</td></tr>`);
        }
        out.push('      </tbody></table>');
      }

      out.push('  </div>');
      out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట ${pageNum} / ${totalReportPages}</span></div>`);
      out.push('</div>');
    }

    // ── PAGES 13 & 14: సూక్ష్మ దశల సమగ్ర విశ్లేషణ (Level 4: Sookshma Dashas up to 80 Years) ──
    // 2 focal Pratyantars per page = ~18 rows total, fits comfortably on 1 A4 page (<160mm)
    const focalPds: Array<{ mTel: string; aTel: string; pdTel: string; pd: DashaPeriod }> = [];
    for (const aItem of allAntars80) {
      const a = aItem.antar;
      const pdList = DashaService.getSubPeriods(a);
      for (const pd of pdList) {
        const isPdActive = now >= pd.startDate && now < pd.endDate;
        if (isPdActive || focalPds.length < 8) {
          const mTel = AstroConstants.planetNamesTelugu[aItem.mahaPlanet] || aItem.mahaPlanet;
          const aTel = AstroConstants.planetNamesTelugu[a.planet] || a.planet;
          const pdTel = AstroConstants.planetNamesTelugu[pd.planet] || pd.planet;
          focalPds.push({ mTel, aTel, pdTel, pd });
        }
      }
    }

    for (let sPage = 0; sPage < 2; sPage++) {
      const sPageNum = 13 + sPage;
      const sStart = sPage * 2;
      const currentBatch = focalPds.slice(sStart, sStart + 2);

      out.push('<div class="page-card">');
      out.push('  <div class="page-content">');
      out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
      out.push(`    <div class="section-title">12.${sPage + 1} సూక్ష్మ దశల సమగ్ర పట్టిక (Level 4: Sookshma Dashas - భాగము ${sPage + 1})</div>`);

      for (const fItem of currentBatch) {
        const sdList = DashaService.getSubPeriods(fItem.pd);
        out.push(`    <div style="font-size:7.5pt; font-weight:700; color:#6b1111; margin-top:3px; background:#eff6ff; padding:2px 6px; border-left:3px solid #1e40af;">✦ ${fItem.mTel} / ${fItem.aTel} / ${fItem.pdTel} ప్రత్యంతర (${this.formatDate(fItem.pd.startDate)} నుండి ${this.formatDate(fItem.pd.endDate)}):</div>`);
        out.push('    <table class="data-table" style="font-size:6.5pt; margin-bottom:3px;">');
        out.push('      <thead><tr><th>సూక్ష్మ నాథుడు</th><th>ప్రారంభ తేదీ & సమయం</th><th>ముగింపు తేదీ & సమయం</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
        for (const sd of sdList) {
          const sdTel = AstroConstants.planetNamesTelugu[sd.planet] || sd.planet;
          const isSdActive = now >= sd.startDate && now < sd.endDate;
          out.push(`      <tr style="${isSdActive ? 'background:#e0f2fe; font-weight:700;' : ''}"><td class="center bold">${sdTel} సూక్ష్మ</td><td class="center">${this.formatDateTime(sd.startDate)}</td><td class="center">${this.formatDateTime(sd.endDate)}</td><td class="center">${DashaService.formatDuration(sd.startDate, sd.endDate)}</td><td class="center ${isSdActive ? 'gold-text' : ''}">${isSdActive ? '★ ప్రస్తుతం' : ''}</td></tr>`);
        }
        out.push('      </tbody></table>');
      }

      out.push('  </div>');
      out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట ${sPageNum} / ${totalReportPages}</span></div>`);
      out.push('</div>');
    }

    // ── PAGES 15 to 24: ప్రాణ దశల సమగ్ర విశ్లేషణ (Level 5: Prana Dashas for ALL 80 YEARS down to Seconds) ──
    const pranaStages: Array<[number, number, string]> = [
      [0, 8, 'బాల్య కాలం & ప్రాథమిక వికాసం (Childhood 0-8 yrs)'],
      [8, 16, 'విద్యాభ్యాస కాలం & కౌమార దశ (Education & Growth 8-16 yrs)'],
      [16, 24, 'ఉన్నత విద్యాభ్యాసం & యవ్వన ప్రవేశం (Higher Studies & Youth 16-24 yrs)'],
      [24, 32, 'ఉద్యోగ ప్రాప్తి, వివాహం & జీవిత స్థిరత్వం (Career Launch & Marriage 24-32 yrs)'],
      [32, 40, 'కుటుంబ సౌభాగ్యం & వృత్తిపర పురోగతి (Family Settlement & Growth 32-40 yrs)'],
      [40, 48, 'ఆర్థిక పురోభివృద్ధి & సామాజిక గౌరవం (Mid-Career & Prosperity 40-48 yrs)'],
      [48, 56, 'పరిపక్వత, ఉన్నత విజయాలు & స్థిరసంపద (Peak Achievements 48-56 yrs)'],
      [56, 64, 'కీర్తి ప్రతిష్టలు, సంతాన సౌఖ్యం (Senior Leadership & Honours 56-64 yrs)'],
      [64, 72, 'విశ్రాంతి, దైవచింతన & ఆధ్యాత్మికోన్నతి (Retirement & Spirituality 64-72 yrs)'],
      [72, 80, 'పూర్ణాయుర్దాయం, ఆత్మశాంతి & మోక్ష సాధన (Longevity & Final Destiny 72-80+ yrs)'],
    ];

    for (let pIndex = 0; pIndex < pranaStages.length; pIndex++) {
      const stage = pranaStages[pIndex];
      const startYr = stage[0];
      const endYr = stage[1];
      const stageDesc = stage[2];
      const pageNum = 15 + pIndex;

      out.push('<div class="page-card">');
      out.push('  <div class="page-content">');
      out.push(`    <div class="sub-header"><span>${this.blessingHeader} • ${this.appTitle}</span><span>${this.astrologerTitleAndMobile}</span></div>`);
      out.push(`    <div class="section-title">13.${pIndex + 1} ప్రాణ దశల సమగ్ర కాలచక్రం: వయస్సు ${startYr} నుండి ${endYr} సం. (${stageDesc})</div>`);

      out.push('    <div style="background: linear-gradient(135deg, #2b1104 0%, #4a1c06 100%); color: #fff; padding: 6px 12px; border-radius: 6px; border: 1.5px solid #d4af37; margin-bottom: 6px; font-size: 8.5pt;">');
      out.push(`      <span style="color: #fde047; font-weight: 800;">వయస్సు దశ:</span> <b>${startYr} నుండి ${endYr} సంవత్సరములు</b> • <span style="color:#f472b6; font-weight:700;">ప్రతి సంవత్సరం సమగ్ర దశ & సూక్ష్మ/ప్రాణ క్రమము (Level 5 down to Seconds)</span>`);
      out.push('    </div>');

      out.push(`    <div style="font-size:7.5pt; font-weight:700; color:#8b2500; margin: 3px 0 2px 0;">❖ వయస్సు ${startYr} నుండి ${endYr} సం. వరకు ప్రతి సంవత్సరం నడుచు సమగ్ర దశ & ప్రాణ నాథుడు:</div>`);
      out.push('    <table class="data-table" style="font-size:6.8pt; margin-bottom:5px;">');
      out.push('      <thead><tr><th>వయస్సు</th><th>సంవత్సర కాలం</th><th>మహా / అంతర / ప్రత్యంతర</th><th>సూక్ష్మ దశ</th><th>ప్రాణ నాథుడు</th><th>ప్రాణ ప్రారంభ సమయం</th><th>ప్రాణ ముగింపు సమయం</th><th>స్థితి</th></tr></thead><tbody>');

      let currentStageActiveSd: DashaPeriod | null = null;
      let stageMilestoneSd: DashaPeriod | null = null;

      for (let y = startYr; y < endYr; y++) {
        const yearStart = new Date(birth.dateTime.getTime() + y * 365.2425 * 86400 * 1000);
        const yearEnd = new Date(birth.dateTime.getTime() + (y + 1) * 365.2425 * 86400 * 1000);
        const midDate = new Date(birth.dateTime.getTime() + (y + 0.5) * 365.2425 * 86400 * 1000);

        const h = DashaService.findCurrentHierarchy(dashas, midDate);
        const mTel = h.maha ? (AstroConstants.planetNamesTelugu[h.maha.planet] || h.maha.planet) : '-';
        const aTel = h.antar ? (AstroConstants.planetNamesTelugu[h.antar.planet] || h.antar.planet) : '-';
        const pTel = h.pratyantar ? (AstroConstants.planetNamesTelugu[h.pratyantar.planet] || h.pratyantar.planet) : '-';
        const sTel = h.sookshma ? (AstroConstants.planetNamesTelugu[h.sookshma.planet] || h.sookshma.planet) : '-';
        const prTel = h.prana ? (AstroConstants.planetNamesTelugu[h.prana.planet] || h.prana.planet) : '-';

        const isYearActive = now >= yearStart && now < yearEnd;
        const isPastYear = yearEnd < now;
        const statusStr = isYearActive ? '★ ప్రస్తుత వయస్సు' : (isPastYear ? 'గతించినది' : 'రాబోవునది');

        const prStartStr = h.prana ? this.formatDateTime(h.prana.startDate) : '-';
        const prEndStr = h.prana ? this.formatDateTime(h.prana.endDate) : '-';

        if (isYearActive && h.sookshma) {
          currentStageActiveSd = h.sookshma;
        }
        if (y === startYr + 3 && h.sookshma) {
          stageMilestoneSd = h.sookshma;
        }

        out.push(`      <tr style="${isYearActive ? 'background:#fef3c7; font-weight:700;' : (isPastYear ? 'color:#6b7280;' : '')}">` +
          `<td class="center bold" style="color:${isYearActive ? '#8b2500' : 'inherit'};">${y} - ${y + 1} సం.</td>` +
          `<td class="center">${this.formatDate(yearStart)} - ${this.formatDate(yearEnd)}</td>` +
          `<td class="bold">${mTel} / ${aTel} / ${pTel}</td>` +
          `<td class="center">${sTel} సూక్ష్మ</td>` +
          `<td class="center bold" style="color:#b91c1c;">${prTel} ప్రాణ</td>` +
          `<td class="center">${prStartStr}</td>` +
          `<td class="center">${prEndStr}</td>` +
          `<td class="center bold" style="color:${isYearActive ? '#166534' : (isPastYear ? '#6b7280' : '#8b2500')};">${statusStr}</td>` +
        '</tr>');
      }
      out.push('      </tbody></table>');

      // Full 9 Prana Dashas sequence down to seconds for key focal period of this stage
      const fallbackMid = new Date(birth.dateTime.getTime() + (startYr + 1) * 365.2425 * 86400 * 1000);
      const detailedSd = currentStageActiveSd || stageMilestoneSd || DashaService.findCurrentHierarchy(dashas, fallbackMid).sookshma;

      if (detailedSd) {
        const testDate = new Date(detailedSd.startDate.getTime() + 3600 * 1000);
        const dHierarchy = DashaService.findCurrentHierarchy(dashas, testDate);
        const dM = dHierarchy.maha ? (AstroConstants.planetNamesTelugu[dHierarchy.maha.planet] || dHierarchy.maha.planet) : '';
        const dA = dHierarchy.antar ? (AstroConstants.planetNamesTelugu[dHierarchy.antar.planet] || dHierarchy.antar.planet) : '';
        const dP = dHierarchy.pratyantar ? (AstroConstants.planetNamesTelugu[dHierarchy.pratyantar.planet] || dHierarchy.pratyantar.planet) : '';
        const dS = AstroConstants.planetNamesTelugu[detailedSd.planet] || detailedSd.planet;

        const prList = DashaService.getSubPeriods(detailedSd);
        const isDetailedActive = now >= detailedSd.startDate && now < detailedSd.endDate;

        out.push('    <div style="font-size:7.5pt; font-weight:700; color:#6b1111; margin-top:4px; background:#fdf2f8; padding:3px 6px; border-left:3px solid #be185d;">');
        out.push(`      ✦ సమగ్ర 9 ప్రాణ దశల పట్టిక: ${dM} (మహా) → ${dA} (అంతర) → ${dP} (ప్రత్యంతర) → ${dS} (సూక్ష్మ)<br>`);
        out.push(`      <span style="color:#78350f; font-weight:600;">కాలపరిమితి: ${this.formatDateTime(detailedSd.startDate)} నుండి ${this.formatDateTime(detailedSd.endDate)} (${DashaService.formatDuration(detailedSd.startDate, detailedSd.endDate)}) ${isDetailedActive ? '★ [ప్రస్తుతం నడుస్తున్న సూక్ష్మ దశ]' : ''}</span>`);
        out.push('    </div>');

        out.push('    <table class="data-table" style="font-size:6.5pt; margin-bottom:3px;">');
        out.push('      <thead><tr><th>ప్రాణ నాథుడు</th><th>ప్రారంభ సమయం (సెకన్లతో)</th><th>ముగింపు సమయం (సెకన్లతో)</th><th>వ్యవధి</th><th>స్థితి</th></tr></thead><tbody>');
        for (const pr of prList) {
          const prTel = AstroConstants.planetNamesTelugu[pr.planet] || pr.planet;
          const isPrActive = now >= pr.startDate && now < pr.endDate;
          const isPrPast = pr.endDate < now;
          out.push(`      <tr style="${isPrActive ? 'background:#fce7f3; font-weight:700;' : (isPrPast ? 'color:#6b7280;' : '')}">` +
            `<td class="center bold" style="color:${isPrActive ? '#be185d' : 'inherit'};">${prTel} ప్రాణ</td>` +
            `<td class="center">${this.formatDateTimeSeconds(pr.startDate)}</td>` +
            `<td class="center">${this.formatDateTimeSeconds(pr.endDate)}</td>` +
            `<td class="center">${DashaService.formatDuration(pr.startDate, pr.endDate)}</td>` +
            `<td class="center bold" style="color:${isPrActive ? '#be185d' : (isPrPast ? '#6b7280' : '#8b2500')};">${isPrActive ? '★ ప్రస్తుతం' : (isPrPast ? 'గతించినది' : 'రాబోవునది')}</td>` +
          '</tr>');
        }
        out.push('      </tbody></table>');
      }

      out.push('  </div>');
      out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట ${pageNum} / ${totalReportPages}</span></div>`);
      out.push('</div>');
    }

    // ── PAGE 25: ఆశీర్వచన పత్రము & కార్యాలయ సంప్రదింపు సమాచారం ──
    out.push('<div class="page-card">');
    out.push('  <div class="page-content">');
    out.push('    <div class="main-header" style="margin-top:20px;">');
    out.push('      <div class="top-blessing-row">');
    out.push('        <span class="title-ornament">卐</span>');
    out.push(`        <span class="top-blessing">|| ${this.blessingHeader} ||</span>`);
    out.push('        <span class="title-ornament">卐</span>');
    out.push('      </div>');
    out.push(`      <div class="guru-blessing">❖ ${this.guruBlessing} ❖</div>`);
    out.push('      <div class="title-divider">');
    out.push('        <div class="title-divider-line"></div>');
    out.push('        <span class="title-ornament">🪔</span>');
    out.push('        <div class="title-divider-line"></div>');
    out.push('      </div>');
    out.push(`      <h1 class="app-title">${this.appTitle}</h1>`);
    out.push(`      <div class="expertise-bar">${this.expertiseLine}</div>`);
    out.push(`      <div class="scholar-pill">${this.astrologerTitleAndMobile}</div>`);
    out.push(`      <div class="sloka-box">${this.invocationShloka.replace(/\n/g, '<br>')}</div>`);
    out.push('    </div>');

    out.push('    <div style="margin-top: 24px; border: 2px solid #6b1111; background: linear-gradient(180deg, #fffbf0 0%, #ffeed0 100%); padding: 18px; border-radius: 8px; text-align: center;">');
    out.push('      <div style="font-size: 14pt; font-weight: 800; color: #6b1111;">|| శుభం భూయాత్ • సర్వేజనాః సుఖినో భవంతు ||</div>');
    out.push('      <div style="margin-top: 10px; font-size: 11pt; color: #3e1b00; font-weight: 700; line-height: 1.6;">');
    out.push('        జాతక పరిశీలన, వివాహ పొంతనలు, వాస్తు నిర్ణయాలు & సంఖ్యాశాస్త్ర సంప్రదింపులకు:<br>');
    out.push(`        <b style="font-size:13pt; color:#8b2500;">${this.astrologerTitleAndMobile}</b><br>`);
    out.push(`        కార్యాలయ చిరునామా: <b>${this.astrologerAddress}</b><br>`);
    out.push(`        <span style="font-size: 9.5pt; color: #6b1111;"><b>${this.appTitle}</b> — సంపూర్ణ వేద జ్యోతిష సేవా నిలయం</span>`);
    out.push('      </div>');
    out.push('    </div>');
    out.push('  </div>');
    out.push(`  <div class="footer-note"><span>${this.appTitle} • ${this.astrologerTitleAndMobile}</span><span>పుట 25 / ${totalReportPages}</span></div>`);
    out.push('</div>');

    out.push('</body></html>');
    return out.join('\n');
  }

  static buildDivisionalChartHtml(chart: ChartData, type: DivisionalChartType): string {
    const placements = DivisionalChartService.getPlacementsForType(chart, type);
    const lagnaIdx = DivisionalChartService.getLagnaForType(chart, type);

    const signOccupants: string[][] = Array.from({ length: 12 }, () => []);
    signOccupants[lagnaIdx].push('<span class="lagna-badge">ల</span>');

    for (let sign = 0; sign < 12; sign++) {
      const list = placements[sign] || [];
      for (const p of list) {
        const abbr = AstroConstants.planetAbbrTelugu[p.name] || p.abbreviation;
        const retro = p.isRetrograde ? '(వ)' : '';
        const combust = p.isCombust ? '(మౌ)' : '';
        signOccupants[sign].push(`${abbr}${retro}${combust}`);
      }
    }

    const grid = AstroConstants.southIndianGrid;
    const lagnaName = AstroConstants.rashisTelugu[lagnaIdx];
    const centerCode = DivisionalChartService.getDivisionalCenterName(type);
    const centerSignif = DivisionalChartService.getDivisionalSignificance(type);

    const lines: string[] = ['<div class="si-chart">'];

    for (let r = 0; r < 4; r++) {
      for (let c = 0; c < 4; c++) {
        if ((r === 1 || r === 2) && (c === 1 || c === 2)) {
          if (r === 1 && c === 1) {
            lines.push(`<div class="si-cell center-box">卐<br><span style="font-size:8.5pt; font-weight:800; color:#6b1111;">${centerCode}</span><br><span style="font-size:6.5pt; color:#8b2500;">${centerSignif}</span><br><span style="font-size:6.5pt; color:#166534; font-weight:700;">లగ్నం: ${lagnaName}</span></div>`);
          }
          continue;
        }
        const signIdx = grid[r][c];
        const signName = AstroConstants.rashisTelugu[signIdx];
        const isLagna = signIdx === lagnaIdx;
        const planetsHtml = signOccupants[signIdx].join(' ');
        lines.push(`<div class="si-cell ${isLagna ? 'lagna-cell' : ''}"><span class="si-sign-name">${isLagna ? '★ ' + signName : signName}</span><div class="si-planets">${planetsHtml}</div></div>`);
      }
    }
    lines.push('</div>');
    return lines.join('\n');
  }

  static buildSavChartHtml(av: AshtakavargaData): string {
    const grid = AstroConstants.southIndianGrid;
    const lines: string[] = ['<div class="si-chart" style="max-width:220px; height:220px;">'];
    for (let r = 0; r < 4; r++) {
      for (let c = 0; c < 4; c++) {
        if ((r === 1 || r === 2) && (c === 1 || c === 2)) {
          if (r === 1 && c === 1) {
            lines.push('<div class="si-cell center-box" style="font-size:9pt;"><span style="color:#6b1111;">SAV</span><br><b style="font-size:12pt; color:#8b2500;">337</b></div>');
          }
          continue;
        }
        const signIdx = grid[r][c];
        const signName = AstroConstants.rashisTelugu[signIdx];
        const pts = av.sav[signIdx] || 0;
        const isHigh = pts >= 28;
        lines.push(`<div class="si-cell" style="background:${isHigh ? '#f0fdf4' : '#ffffff'};"><span class="si-sign-name">${signName}</span><div class="si-planets" style="color:${isHigh ? '#166534' : '#991b1b'}; font-size:10pt;">${pts}</div></div>`);
      }
    }
    lines.push('</div>');
    return lines.join('\n');
  }

  static formatDms(deg: number): string {
    deg = ((deg % 360.0) + 360.0) % 360.0;
    let d = Math.floor(deg);
    const mTotal = (deg - d) * 60.0;
    let m = Math.floor(mTotal);
    let s = Math.round((mTotal - m) * 60.0);
    if (s === 60) {
      s = 0;
      m += 1;
    }
    if (m === 60) {
      m = 0;
      d += 1;
    }
    const mStr = String(m).padStart(2, '0');
    const sStr = String(s).padStart(2, '0');
    return `${d}°${mStr}'${sStr}"`;
  }

  static getTeluguDignity(p: PlanetPosition): string {
    switch (p.dignity) {
      case 'Exalted': return '<span style="color:#166534;">ఉచ్ఛ</span>';
      case 'Moolatrikona': return '<span style="color:#15803d;">మూలత్రికోణం</span>';
      case 'Own Sign': return '<span style="color:#0369a1;">స్వక్షేత్రం</span>';
      case 'Friendly': return 'మిత్రుడు';
      case 'Neutral': return 'సమం';
      case 'Enemy': return '<span style="color:#b45309;">శత్రువు</span>';
      case 'Debilitated': return '<span style="color:#b91c1c;">నీచ</span>';
      default: return p.dignity || 'సమం';
    }
  }

  static formatDate(d: Date): string {
    const dd = String(d.getDate()).padStart(2, '0');
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const yyyy = d.getFullYear();
    return `${dd}-${mm}-${yyyy}`;
  }

  static formatTime(d: Date): string {
    let hours = d.getHours();
    const minutes = String(d.getMinutes()).padStart(2, '0');
    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12;
    const hStr = String(hours).padStart(2, '0');
    return `${hStr}:${minutes} ${ampm}`;
  }

  static formatDateTime(d: Date): string {
    return `${this.formatDate(d)} ${this.formatTime(d)}`;
  }

  static formatDateTimeSeconds(d: Date): string {
    let hours = d.getHours();
    const minutes = String(d.getMinutes()).padStart(2, '0');
    const seconds = String(d.getSeconds()).padStart(2, '0');
    const ampm = hours >= 12 ? 'PM' : 'AM';
    hours = hours % 12;
    hours = hours ? hours : 12;
    const hStr = String(hours).padStart(2, '0');
    return `${this.formatDate(d)} ${hStr}:${minutes}:${seconds} ${ampm}`;
  }
}

