# Dasha Engine — Implementation Plan (verified against the code)

9 Nov 2026. Replaces the "Antigravity Build Plan" where it disagrees with the repo.
M0 (recon) is done and recorded below, so the first agent task is M1.

## M0 recon results

| Question | Answer (file:line) |
|---|---|
| Where do `dashas` come from? | Always local. `ChartResultScreen.calculateAll` → `AstroEngine.calculateChart` (server or local fallback) → then **always** `DashaService.calculateVimshottariDashas(moon.longitude, birthData.dateTime)` (`src/screens/ChartResultScreen.tsx:114`). The server's `dashas` field is never read by the app. `App.tsx:131` passes the same list into the PDF screen through ProfileContext. |
| TS equivalent of `get_varga_sign`? | `DivisionalChartService.calculateVargaSign(longitude, DivisionalChartType)` in `src/services/divisionalChartService.ts:90`; returns sign 0–11. `DivisionalChartType` enum (`d1`…`d60`, 16 values) in `src/models/astroModels.ts:148`. |
| Profile persistence | `SavedHoroscopeService` (`src/services/savedHoroscopeService.ts`), `expo-file-system` `File(Paths.document, 'saved_horoscopes.json')`, a JSON array of `BirthData`. `load()` spreads `...item`, so a new optional `dashaConfig` field survives a round-trip with no migration. |
| `DashaPeriod` fields read | `planet`, `startDate`, `endDate`, `years`, `level`, `subPeriods`, `nominalStart`. **Consumers also call `DashaService` directly:** `DashaBrowser.tsx` (`getSubPeriods` ×4, `findCurrentHierarchy`) and `teluguPdfReportGenerator.ts` (`getSubPeriods` ×5, `findCurrentHierarchy` ×3, `formatDuration` ×6). |

## Corrections to the earlier plan

1. **The "first-MD sub-period bug" does not exist.** `DashaService.getSubPeriods` already splits from `nominalStart`
   (the full first-MD start before birth) and clips at birth (`dashaService.ts`, `baseMs = parent.nominalStart ?? parent.startDate`).
   Server and app agree. So M3 must change **no** dates under the default config; drop the "accept changed dates" decision.
2. **Real timezone bug to fix in the engine.** `BirthInputScreen` builds `dateTime` with `new Date(y, m-1, d, h, …)` in the
   *device* timezone, and `DashaService` uses `dateTime.getTime()` as the birth instant. `astroEngine` instead uses the wall-clock
   fields + `birthData.timezone`. When the device timezone ≠ birth timezone (e.g. phone in the US, birth in India) every dasha date
   is shifted by the difference. The engine's birth JD must come from wall clock + `birthData.timezone`, like `astroEngine._julianDay`.
3. **An adapter alone won't keep the PDF consistent.** The PDF generator builds sub-periods itself through `DashaService.getSubPeriods`,
   which is always lord-forward from Moon. With a non-standard config it would print different periods than the screen.
   M3 must move `DashaBrowser` **and** `teluguPdfReportGenerator.ts` to a config-aware `children()`/`findCurrentHierarchy()`.
4. **The server is irrelevant to what users see** (point 1 in the recon table). M5 is a nice-to-have only; it changes nothing on phones.
5. **Running `scripts/print-dasha.ts`:** no `tsx`/`ts-node` is installed. Node v26 strips TypeScript types natively, but it needs
   explicit `.ts` extensions on relative imports. Either the engine uses `.ts` import extensions (and tsconfig
   `allowImportingTsExtensions` with `noEmit`) or the script is plain `.mjs` duplicating nothing but I/O. Decide in M1.

Unrelated issue seen: `SavedHoroscopeService.load()` swallows read/parse errors with `catch (_)`.

## Design (unchanged unless noted)

- Engine: pure TS in `jhora_rn/src/services/dasha/`. No React, no fetch, no `Date.now()`, no storage. Times are Julian Days.
- Inputs: `{ birthJd, moonLon, lagnaLon, planetLons }` — sidereal, as produced by `AstroEngine.calculateChart`.
- `DashaConfig` and `DEFAULT_DASHA_CONFIG` as in the earlier plan (`yearDays` default 365.2425 → today's dates exactly).
- Lord list and years: import `AstroConstants.dashaSequence` / `dashaYears`; don't copy them.
- Varga longitude: `calculateVargaSign(lon, type) × 30 + fraction-through-D1-division × 30`. Tara offset applied before the varga
  mapping, in one named function so the order can be flipped.
- Output: `DashaNode { path, level, lord, startJd, endJd, nominalStartJd?, years }`. One adapter `toDashaPeriod(node)`:
  JD → `Date` such that the Date's device-local wall clock equals the birth-timezone wall clock (matches today's display when
  device tz = birth tz, and stays correct when they differ).
- Antizodiacal: exported under an `EXPERIMENTAL` comment and labelled experimental in the UI until JHora fixtures match.

## Milestones (one agent task each; you commit after each check)

### M1 — Engine core, default config only
Create `types.ts`, `lords.ts`, `balance.ts`, `tree.ts`, `time.ts` (wall clock + tz ⇄ JD), `index.ts` under `src/services/dasha/`.
Only Moon / D1 / Krittika / zodiacal / `lord_fwd` must work; other values throw `not implemented`. No screen changes.
**Done when:** `npx tsc --noEmit` passes, and for 3 charts with device tz = birth tz the MD + AD dates equal today's app output
(`DashaService`) to the minute and the server's `/calculate` dates to the day.

### M2 — All options + `scripts/print-dasha.ts`
`seed.ts` (Moon, Lagna, any graha; Kshema/Utpanna/Adhana = Moon + (k−1)×13°20′, k = 4/5/8), `varga.ts` (16 vargas via
`calculateVargaSign`), seed-nakshatra shift, the four antardasha orders at every level, antizodiacal (experimental).
**Done when:** for each fixture chart/option, printed MD and AD starts match JHora within 1 hour.

### M3 — Wire into the app
- `ChartResultScreen` builds `birthJd` from wall clock + `birthData.timezone` and calls `mahadashas(..., DEFAULT_DASHA_CONFIG)`.
- Add `children(period, cfg)` and `findCurrentHierarchy(periods, date, cfg)` to the engine's adapter. Replace every
  `DashaService.getSubPeriods` / `findCurrentHierarchy` call in `DashaBrowser.tsx` and `teluguPdfReportGenerator.ts`.
  `formatDuration` can stay where it is (pure formatting).
- Mark `calculateVimshottariDashas` / `getSubPeriods` / `findCurrentHierarchy` `@deprecated`; keep the file.
**Done when:** web + phone run; with device tz = birth tz, all dates are identical to before; with device tz ≠ birth tz, dates
are now shifted by the tz difference (the bug fix) and match the device-tz = birth-tz output.

### M4 — Options modal + saved presets
`src/components/DashaOptionsModal.tsx` (RN `Modal`) from a settings button on the dasha tab: start point, varga (16),
seed nakshatra (27), antardasha order, antizodiacal switch (experimental). Telugu + English labels and one helper line each.
"Non-standard settings" badge + Reset. Seed summary above the tree (nakshatra, pada, lord, balance).
Persist as optional `BirthData.dashaConfig` through `SavedHoroscopeService.save`; pass it through ProfileContext to the PDF,
which prints a one-line settings note when non-standard.
**Done when:** a changed option updates the tree, survives an app restart for a saved profile, and the PDF matches the screen.

### M5 — Python mirror (optional, low value)
`python_server/dasha_engine.py` mirroring the TS engine; `/calculate` accepts optional `dashaConfig`; response unchanged
without it. Do not touch `*report*.py`, `write_*.py`, `fix_generator.py`.

## JHora fixtures (your work, before M2)
As in the earlier plan: 10 charts (nakshatra start/end/boundary, all 9 lords, one southern-hemisphere), JHora set to Lahiri +
mean node, record JHora's year length, one JSON per chart in `jhora_rn/src/services/dasha/fixtures/`.

## Open decisions
- [ ] **Fixture checks vs the no-tests rule** (AGENTS.md §2): allow a comparison script as an exception, or compare
      `print-dasha.ts` output by eye. Without one, the varga and antizodiacal options can't be trusted.
- [ ] Default year length: keep 365.2425 or switch to JHora's after fixtures.
- [ ] M5: do it at all? (Phones never use the server's dashas.)
