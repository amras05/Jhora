# SBJV Hora Licensing & Dependency Audit Report

**Date of Audit**: November 2026  
**Auditor**: Senior Software Engineering & Open-Source Compliance Review  
**Project License**: GNU Affero General Public License v3.0 or later (`AGPL-3.0-or-later`)  
**Project Copyright**: Copyright (C) 2024–2026 Karrthikeya Sarma (SBJV Hora Team)  

---

## 1. Executive Summary

This document presents a comprehensive open-source licensing audit for **SBJV Hora** (సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం). The project has adopted the **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)** to ensure full compliance with upstream copyleft obligations stemming from **PyJHora** and **Swiss Ephemeris (`pyswisseph`)**, as well as to safeguard community software freedoms under Section 13 (Remote Network Interaction).

### Key Audit Findings:
1. **Upstream Compatibility Verified**:
   - **PyJHora** (`naturalstupid/PyJHora`) is officially licensed under **AGPL-3.0-or-later**. Adopting AGPL-3.0-or-later for SBJV Hora establishes seamless upstream and downstream license compatibility.
   - **Swiss Ephemeris (`pyswisseph`)** is licensed under **AGPL-3.0** (and dual-licensed under GPLv2+ or commercial terms). In the absence of an Astrodienst commercial license, AGPLv3 is the required licensing framework.
2. **Direct Dependencies (Frontend & Mobile)**:
   - All 12 direct npm dependencies (`expo`, `react`, `react-native`, `expo-print`, `expo-sharing`, etc.) are licensed under permissive open-source licenses (**MIT** or **Apache-2.0**). All are fully compatible with AGPL-3.0.
3. **Transitive Dependencies**:
   - Out of 429 transitive npm packages, **424** use standard permissive licenses (MIT, ISC, BSD-2-Clause, BSD-3-Clause, Apache-2.0, BlueOak-1.0.0, CC0, 0BSD, Unlicense).
   - **5** packages use non-MIT licenses requiring specific analysis: `lightningcss` (MPL-2.0), `node-forge` (dual BSD-3-Clause / GPL-2.0), `caniuse-lite` (CC-BY-4.0), and `argparse` (Python-2.0). All have been reviewed and determined to be legally compatible in their respective architectural roles.
4. **Embedded Assets & Fonts**:
   - Telugu typography (`NotoSansTelugu`) is licensed under the **SIL Open Font License 1.1 (OFL-1.1)**, which permits bundling with AGPL-3.0 software.
5. **AGPL-3.0 Section 13 Network Source Availability**:
   - The calculation microservice (`python_server/astro_server.py`) implements `/source` and `/license` endpoints, along with `X-License` and `X-Source-Code` headers.
   - The user-facing application (`HomeScreen.tsx`) includes an open-source licensing dialog ensuring remote web and mobile users can access the Corresponding Source at no charge.

---

## 2. Upstream Astrological Engine Analysis

### 2.1 PyJHora (`naturalstupid/PyJHora`)
- **Author**: Sundar Sundaresan (`naturalstupid`)
- **Foundation**: Algorithmic rules from *"Vedic Astrology - An Integrated Approach"* and the *Jagannatha Hora (JHora)* software by **P.V.R. Narasimha Rao**.
- **Upstream License**: **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)**.
- **Verification**: Verified via PyJHora's GitHub repository and PyPI distribution metadata.
- **Obligations & Implications**:
  - Because PyJHora is licensed under AGPL-3.0-or-later, any application that statically or dynamically links to, incorporates, or derives from PyJHora logic must be licensed under AGPL-3.0 or later.
  - Prior versions of this project listed "GPL-3.0" in the root `README.md`. While GPL-3.0 and AGPL-3.0 are mutually compatible for combining code under Section 13 of GPLv3, re-licensing the unified project under **AGPL-3.0-or-later** resolves any ambiguity and enforces source availability across network deployments.

### 2.2 Swiss Ephemeris (`pyswisseph`)
- **Authors**: Astrodienst AG (Dieter Koch, Alois Treindl) & Thomas Mack (`pyswisseph`).
- **License**: **GNU AGPL-3.0** / **GNU GPL v2 or later** / Commercial License from Astrodienst AG.
- **Obligations & Implications**:
  - The C library and its Python extension `pyswisseph` follow a copyleft/commercial dual model.
  - When used in open-source projects without purchasing a proprietary commercial license, the host application is bound by the AGPLv3 copyleft terms.
  - Ephemeris data files (`.se1` files) are public domain or subject to Astrodienst distribution terms.

---

## 3. Direct Dependency Inventory

The table below lists all direct dependencies specified in `jhora_rn/package.json` and verifies their licensing compatibility with GNU AGPL-3.0-or-later:

| Package | Version | License | Compatibility with AGPL-3.0 | Notes |
| :--- | :--- | :--- | :--- | :--- |
| `expo` | `~58.0.22` | **MIT** | Compatible | Permissive core framework |
| `expo-file-system` | `~58.0.0` | **MIT** | Compatible | Permissive native storage bridge |
| `expo-print` | `~58.0.0` | **MIT** | Compatible | Permissive HTML-to-PDF compiler |
| `expo-sharing` | `~58.0.0` | **MIT** | Compatible | Permissive native file share sheet |
| `expo-status-bar` | `~58.0.4` | **MIT** | Compatible | Permissive system status bar helper |
| `react` | `19.3.0` | **MIT** | Compatible | Permissive UI library |
| `react-dom` | `19.3.0` | **MIT** | Compatible | Permissive DOM rendering bridge |
| `react-native` | `0.88.1` | **MIT** | Compatible | Permissive mobile runtime |
| `react-native-svg` | `15.12.1` | **MIT** | Compatible | Permissive vector graphics engine |
| `react-native-web` | `^0.21.4` | **MIT** | Compatible | Permissive web platform adapter |
| `@types/react` | `~19.3.0` | **MIT** | Compatible | Dev dependency (type definitions only) |
| `typescript` | `~6.0.3` | **Apache-2.0** | Compatible | Dev dependency (compiler only) |

---

## 4. Transitive Dependency Audit & License Categories

A full scan of all 429 packages in `jhora_rn/node_modules` revealed the following breakdown:

```
MIT                          : 369 packages
ISC                          :  22 packages
BSD-2-Clause                 :  10 packages
BSD-3-Clause                 :   6 packages
Apache-2.0                   :   6 packages
BlueOak-1.0.0                :   5 packages
MPL-2.0                      :   2 packages (lightningcss, lightningcss-darwin-arm64)
Unlicense                    :   2 packages
0BSD                         :   1 package
CC0-1.0                      :   1 package
Python-2.0                   :   1 package  (argparse)
CC-BY-4.0                    :   1 package  (caniuse-lite)
(BSD-3-Clause OR GPL-2.0)    :   1 package  (node-forge)
(MIT OR Apache-2.0)          :   1 package
(MIT OR CC0-1.0)             :   1 package
--------------------------------------------------
Total Evaluated Packages     : 429 packages
```

---

## 5. In-Depth Compatibility Analysis for Non-MIT Licenses

### 5.1 Apache License 2.0 (`Apache-2.0`)
- **Relevant Packages**: `typescript`, `@babel/*` helpers.
- **FSF Evaluation**: The Free Software Foundation (FSF) has officially evaluated Apache-2.0 as compatible with GPLv3 and AGPLv3. While Apache-2.0 code cannot be backported into GPLv2 due to patent termination clauses, it can be freely incorporated into works distributed under AGPL-3.0.
- **Conclusion**: **Compatible**.

### 5.2 Mozilla Public License 2.0 (`MPL-2.0`)
- **Relevant Packages**: `lightningcss`, `lightningcss-darwin-arm64`.
- **Role**: Build-time CSS compilation tooling utilized by Metro bundler during development and APK generation.
- **Compatibility Analysis**:
  - MPL-2.0 is a file-level (weak copyleft) license. The copyleft obligations apply solely to modifications made to the MPL-covered source files itself.
  - Section 3.3 of MPL-2.0 ("Distribution of a Larger Work") explicitly allows distributing an executable or larger work combining MPL-2.0 code with software under other licenses (including AGPLv3), provided the source code of the MPL-covered component remains accessible under MPL-2.0.
  - In our architecture, `lightningcss` is an external Node.js build tool and is not embedded into the application bytecode.
- **Conclusion**: **Compatible**.

### 5.3 `node-forge` (`(BSD-3-Clause OR GPL-2.0)`)
- **Role**: Build-time cryptographic helper used by developer server tooling.
- **Compatibility Analysis**:
  - `node-forge` is dual-licensed under both `BSD-3-Clause` and `GPL-2.0`.
  - Under dual-licensing principles, licensees may choose which set of terms to adopt. SBJV Hora exercises the `BSD-3-Clause` option.
  - `BSD-3-Clause` is a permissive license that is universally recognized as fully compatible with AGPL-3.0.
- **Conclusion**: **Compatible**.

### 5.4 `caniuse-lite` (`CC-BY-4.0`)
- **Role**: Build-time database providing browser support data to Babel/Autoprefixer.
- **Compatibility Analysis**:
  - `caniuse-lite` contains statistical data tables and is licensed under Creative Commons Attribution 4.0 International.
  - It is used strictly during build compilation and is appropriately attributed in `THIRD_PARTY_LICENSES`.
- **Conclusion**: **Compatible**.

### 5.5 SIL Open Font License 1.1 (`OFL-1.1`)
- **Relevant Assets**: `NotoSansTelugu.ttf`, `NotoSansTelugu-Bold.ttf`.
- **Role**: Embedded typography for offline Telugu rendering and PDF report generation.
- **Compatibility Analysis**:
  - Section 1 of OFL-1.1 states: *"The Font Software, including any derivative works, can be bundled, embedded, redistributed and/or sold with any software, provided that each copy contains the above copyright notice and this license."*
  - It prohibits selling the font *by itself*. Bundling it with an AGPL-3.0 application is standard, sanctioned practice.
- **Conclusion**: **Compatible**.

---

## 6. AGPL-3.0 Section 13 Network Interaction Compliance

Section 13 is the defining provision of the GNU Affero General Public License:
> *"if you modify the Program, your modified version must prominently offer all users interacting with it remotely through a computer network (if your version supports such interaction) an opportunity to receive the Corresponding Source of your version by providing access to the Corresponding Source from a network server at no charge..."*

### Implementation in SBJV Hora:
1. **Python Ephemeris Microservice (`python_server/astro_server.py`)**:
   - Implemented `GET /source`: returns structured metadata specifying the exact AGPL-3.0 terms, maintainer contact, and link to Corresponding Source.
   - Implemented `GET /license`: returns license information.
   - Outgoing HTTP responses include response headers:
     - `X-License: AGPL-3.0-or-later`
     - `X-Source-Code: /source`
2. **Frontend UI (`jhora_rn/src/screens/HomeScreen.tsx`)**:
   - Features a prominent open-source license attribution badge (`⚖️ GNU AGPL-3.0-or-later • Open Source`).
   - Tapping the badge presents a dialog informing the user of their rights to the Corresponding Source under AGPL Section 13.
3. **Deployment Compliance**:
   - Any organization deploying a hosted or SaaS instance of SBJV Hora must keep the source code repository or archive synchronized with the live deployed build.

---

## 7. Unresolved Questions & Legal Review Recommendations

While this technical audit verifies open-source compatibility across all active code and dependencies, legal counsel should be consulted for the following commercial and operational considerations:

1. **Astrodienst Swiss Ephemeris Commercialization**:
   - If SBJV Hora is ever intended to be distributed as proprietary software or integrated into a closed-source commercial ecosystem, an Astrodienst Swiss Ephemeris commercial license must be purchased. Under the current AGPL-3.0-or-later open-source distribution, this is not required.
2. **Apple App Store & Copyleft Interaction**:
   - The FSF maintains that the standard Apple iOS App Store terms of service contain restrictions (such as DRM and device limits) that may conflict with the GPL/AGPL requirement that no additional restrictions be imposed. If releasing on iOS in the future, legal counsel should evaluate whether dual-licensing or App Store exception clauses are advisable.
3. **Contributor Agreement Policy**:
   - As established in `CONTRIBUTING.md`, contributors retain their individual copyrights under the AGPL-3.0-or-later. If the project ever contemplates relicensing in the future, a formal Contributor License Agreement (CLA) would be required; however, none is implemented at this time in adherence to project constraints.

---

## 8. Audit Verification Summary

| Item | Requirement | Status |
| :--- | :--- | :--- |
| Root `LICENSE` File | Official AGPL-3.0 text with project copyright | **Verified & Implemented** |
| `README.md` License Section | AGPL-3.0-or-later, user rights, Section 13 notice | **Verified & Implemented** |
| `THIRD_PARTY_LICENSES` | Full inventory of direct/transitive packages & PyJHora | **Verified & Implemented** |
| `CONTRIBUTING.md` | Clear contribution licensing, no unauthorized CLA | **Verified & Implemented** |
| Source Code Headers | SPDX-License-Identifier: AGPL-3.0-or-later on 60 files | **Verified & Implemented** |
| Network Source Access | Endpoints on Python server + UI indicator | **Verified & Implemented** |
| TypeScript Compilation | 0 type errors after header insertions | **Verified & Passed** |

