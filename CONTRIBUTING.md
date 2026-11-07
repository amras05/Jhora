# Contributing to SBJV Hora

Thank you for your interest in contributing to **SBJV Hora** (సాయి బాలా త్రిపుర సుందరీ జ్యోతిషాలయం). We welcome contributions from developers, Vedic astrology scholars, mathematical astronomers, translators, and open-source advocates.

---

## 1. Open Source Licensing Agreement

By contributing to this project, you agree that:
1. **License Terms**: All contributions (including code, documentation, scripts, astronomical models, and visual assets) are submitted under the **GNU Affero General Public License v3.0 or later (AGPL-3.0-or-later)**.
2. **Copyright Ownership**: **You retain your individual copyright.** We do **not** require a Contributor License Agreement (CLA), copyright assignment, or transfer of intellectual property rights. Your copyright notice will be respected alongside your contributions in accordance with applicable copyright law.
3. **Right to Contribute**: You represent and warrant that you are legally authorized to submit the contribution, that it is your original work or derived from properly attributed open-source works compatible with the GNU AGPL-3.0-or-later, and that it does not infringe upon any third-party copyrights, patents, or trade secrets.

---

## 2. Contribution Guidelines & Standards

### 2.1 Code Quality & Architecture
- **Astronomical Integrity**: Any changes to ephemeris logic, Ayanamsa calculations, or Parashara Shodashavarga algorithms must strictly reference classical literature (BPHS, Jataka Parijata, Phaladeepika, Saravali) or established astronomical formulas (Jean Meeus).
- **TypeScript & React Native**: Follow clean modular architecture, strict TypeScript types, and existing project conventions.
- **Offline First**: All user calculations and chart renders must function 100% offline without requiring internet access or third-party web tracking.

### 2.2 Adding SPDX Headers
When creating newly authored source files, please include the standard AGPL-3.0-or-later SPDX header at the top of the file:

```typescript
/*
 * Copyright (C) 2024-2026 <Your Name or Entity>
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
```

For Python source files (`.py`), use the hash (`#`) comment format:

```python
# Copyright (C) 2024-2026 <Your Name or Entity>
# SPDX-License-Identifier: AGPL-3.0-or-later
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
```

---

## 3. Remote Network Interaction (AGPL Section 13)

If you modify SBJV Hora and make it accessible over a network (e.g. hosting a calculation web app or remote API service):
- You must comply with **Section 13 of the AGPLv3** by prominently offering all network users access to the **Corresponding Source** of your modified version without charge.
- Do not remove existing `/source` endpoints, source attribution links, or licensing indicators from network services.

---

## 4. Reporting Licensing or Legal Concerns

We take open-source licensing, intellectual property rights, and copyright integrity very seriously.

If you believe that any file, font, ephemeris data, or dependency in this repository:
- Contains an incorrect or missing copyright notice;
- Exhibits a licensing incompatibility with GNU AGPL-3.0-or-later; or
- Infringes upon any third-party proprietary rights,

Please report your concern immediately by opening a focused issue on GitHub titled `[Licensing / Legal Inquiry]` or contacting the maintainers directly at:
- **Email**: `smkaarthikeya@gmail.com`
- **Project Maintainer**: Karrthikeya Sarma (SBJV Hora Team)

We will review and address any licensing concern promptly and transparently.

