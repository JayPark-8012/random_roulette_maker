# DESIGN_DIRECTION — 랜덤 룰렛 메이커

> 마지막 업데이트: 2026-02-25

---

## 진단 요약

### Phase 5.5에서 해결한 문제 (완료)

| 요소 | 문제 | 조치 |
|---|---|---|
| Bokeh 블롭 | 방사형 그라데이션 중첩 → 흐릿한 haze | 제거 → 단색 배경 |
| Box Shadow 과다 | blur 12~24px → 경계 뭉개짐 | 4~6px로 축소 |
| 카드 그라데이션 | 반투명 tint → 낮은 대비 | 단색 + 컬러 border |
| 상단 세그먼트 탭 | 레이아웃 비효율 | 하단 NavigationBar 교체 |
| SPIN 버튼 glow | 빛번짐 | 3D 아케이드 버튼 |

### 현재 남은 문제

| 요소 | 문제 |
|---|---|
| **라이트/다크 이중 관리** | 모든 위젯에서 `isDark` 분기 → 디자인 자유도 절반, 코드 복잡도 증가 |
| **배경이 무채색 단색** | Dark `#0D0818` / Light `#FAFAFA` — 밋밋하고 개성 없음 |
| **컬러 충돌** | 룰렛 10색 팔레트가 밝은 배경에서 채도 경쟁 |
| **프리미엄 시각적 차별화 부족** | 테마=팔레트 교체뿐, 배경이 바뀌지 않아 임팩트 약함 |
| **카드/네비바 솔리드** | 글래스모피즘 없이 솔리드 컬러 → 깊이감 부족 |

---

## 핵심 결론

> **라이트/다크 모드 제거 → 다크 베이스 단일 모드 + 배경 프리셋("Atmosphere") 시스템**

- 룰렛 앱의 본질은 **컬러풀한 휠**. 어두운 배경에서 색이 훨씬 돋보임
- 게임/엔터테인먼트 앱(룰렛, 슬롯 등)은 거의 대부분 다크 베이스 채택
- "배경 자체가 개성"이 되는 구조 → 프리미엄 수익화 핵심 축

---

## 디자인 컨셉: **"Atmosphere"** (배경 프리셋 시스템)

> 라이트/다크 이분법 → **배경이 곧 분위기** / 다크 베이스 위에 그래디언트로 개성 표현

---

## 3축 커스터마이징 구조

```
현재 구조:
  AppThemeMode(light/dark) + AppThemeData(6개 팔레트) + WheelTheme(8개)

신규 구조:
  AtmospherePreset(10개 배경) + AppThemeData(팔레트) + WheelTheme(휠 스타일)
  ─────────────────────────────  ───────────────────   ─────────────────────
  배경 레이어 (새 축)             색상 팔레트 (유지)      휠 렌더링 (유지)
```

| 축 | 역할 | 프리미엄 구분 |
|---|---|---|
| **Atmosphere (배경)** | 앱 전체 분위기 — 그래디언트/패턴 | Free 2개 + Premium 8개 |
| **Palette (팔레트)** | 룰렛 아이템 색상 | Free 2개 + Premium 4개 (기존 유지) |
| **Wheel Style (휠)** | 룰렛 렌더링 효과 | Free 2개 + Premium 6개 (기존 유지) |

---

## A. 모드 제거 → 다크 베이스 고정

```
Before:  AppThemeMode { system, light, dark }
After:   제거 — 항상 Brightness.dark 기반
```

- `ColorScheme.fromSeed(brightness: Brightness.dark)` 고정
- `isDark` 분기 코드 전부 제거 → 코드 단순화
- 텍스트/아이콘 = 항상 밝은 색 (`onSurface` = white 계열)
- Settings 화면에서 "테마 모드" SegmentedButton 제거

---

## B. Atmosphere 배경 프리셋

### 프리셋 목록

| # | ID | 이름 | 스타일 | Free/Premium |
|---|---|---|---|---|
| 1 | `deep_space` | **Deep Space** | 딥 네이비(`#0A0E27`) → 블랙(`#050510`) 리니어 그래디언트 (top→bottom) | Free |
| 2 | `charcoal` | **Charcoal** | 뉴트럴 다크 그레이(`#1A1A2E`) 솔리드 (현재와 유사한 클래식) | Free |
| 3 | `aurora` | **Aurora** | 보라(`#1A0533`) → 틸(`#0A2E3D`) → 핑크(`#2D1B3D`) 멀티스톱 리니어 | Premium |
| 4 | `sunset_glow` | **Sunset Glow** | 딥 오렌지(`#2D1810`) → 다크 퍼플(`#1A0A2E`) 리니어 | Premium |
| 5 | `ocean_depth` | **Ocean Depth** | 딥 블루(`#0A1628`) → 다크 시안(`#0A2832`) 리니어 | Premium |
| 6 | `neon_city` | **Neon City** | 다크(`#0D0D1A`) 베이스 + 핑크/블루 엣지 래디얼 글로우 오버레이 | Premium |
| 7 | `forest_night` | **Forest Night** | 다크 그린(`#0A1F0A`) → 블랙(`#080810`) 리니어 | Premium |
| 8 | `rose_gold` | **Rose Gold** | 다크 로즈(`#2D1420`) → 골드 틴트(`#2D2818`) 리니어 | Premium |
| 9 | `starfield` | **Starfield** | 블랙(`#060610`) 솔리드 + CustomPainter 미세 도트 패턴 오버레이 | Premium |
| 10 | `lava` | **Lava** | 딥 레드(`#2D0A0A`) → 다크 오렌지(`#2D1A0A`) 래디얼 그래디언트 (center→edge) | Premium |

### AtmospherePreset 데이터 구조

```dart
class AtmospherePreset {
  final String id;           // 'deep_space', 'aurora', ...
  final String nameKey;      // i18n 키 (예: 'atmosphere_deep_space')
  final Gradient? gradient;  // LinearGradient / RadialGradient (null이면 solid)
  final Color solidColor;    // gradient null 시 사용하는 단색 배경
  final Color surfaceColor;  // 카드/컨테이너용 반투명 색상
  final Color overlayColor;  // 모달/시트용 반투명 색상
  final bool isLocked;       // 프리미엄 전용 여부
  final bool hasPattern;     // CustomPainter 오버레이 패턴 여부
}
```

---

## C. AppBackground 위젯 개편

```
현재:
  ColoredBox(color: isDark ? Color(0xFF0D0818) : Color(0xFFFAFAFA))

변경:
  Container(
    decoration: BoxDecoration(
      gradient: atmosphere.gradient,    // 각 프리셋별 그래디언트
      color: atmosphere.solidColor,     // gradient null 시 단색
    ),
    child: atmosphere.hasPattern
        ? CustomPaint(painter: _PatternPainter(...), child: child)
        : child,
  )
```

---

## D. 카드/UI 글래스모피즘 업그레이드

| 요소 | 현재 | 개선 |
|---|---|---|
| **카드 배경** | `surfaceContainerLow` 솔리드 | `atmosphere.surfaceColor` 반투명 (`Colors.white.withOpacity(0.06~0.10)`) + `BackdropFilter(blur)` |
| **네비게이션 바** | 솔리드 서페이스 색 | 반투명 배경 + `BackdropFilter(sigmaX: 12, sigmaY: 12)` |
| **헤더 영역** | 하드코딩 색상 | Atmosphere 그래디언트와 자연스럽게 이어짐 (투명 or 반투명) |
| **바텀시트** | 솔리드 서페이스 | `atmosphere.overlayColor` + `BackdropFilter(blur)` |
| **룰렛 카드 보더** | 아이템 컬러 40% alpha | 아이템 컬러 + 미세 glow (`BoxShadow(blurRadius: 6~8)`) |

### 글래스모피즘 규칙

```
반투명 레이어: Colors.white.withOpacity(0.06~0.12)
블러 강도: sigmaX/Y = 10~16
보더: 1px Colors.white.withOpacity(0.08)
쉐도우: 최소 (blur 4~6px, black 0.15~0.25 opacity)
```

---

## E. Settings 화면 변경

```
현재 Settings:
  ┌─ 테마 모드 (System / Light / Dark)  ← 삭제
  ├─ 앱 테마 (6개 팔레트 그리드)
  └─ 휠 테마 (8개 스타일 그리드)

변경 Settings:
  ┌─ 배경 (Atmosphere 프리셋 그리드)     ← 신규 (프리미엄 핵심)
  ├─ 앱 테마 (팔레트 그리드)             ← 유지
  └─ 휠 테마 (스타일 그리드)             ← 유지
```

### Atmosphere 프리뷰 카드

- 2열 그리드 (기존 3열 팔레트보다 크게)
- 실제 그래디언트를 미니 카드로 렌더링 → 시각적 구매 욕구 자극
- 잠금 아이콘 + "Premium" 배지
- 선택된 프리셋: 체크마크 + 하이라이트 보더

---

## F. 기존 유지 사항

### "Sharp Arcade" 원칙 (Phase 5.5에서 확립)

- 굵고 선명한 윤곽선 (blur 최소화)
- 강한 색 대비 (다크 베이스로 더욱 강화)
- "눌리는" 3D 버튼감
- 짧고 강한 타이포그래피 (w900 제목, 72~96sp 결과)
- confetti 파티클 결과 효과 (계획 유지)

### 타이포그래피 (변경 없음)

```
제목:    FontWeight.w900, 적극적 크기
결과값:  매우 큰 폰트 (72~96sp), Tabular figures
설명:    FontWeight.w400, muted color
버튼:    FontWeight.w700
```

### 박스 섀도우 정책 (변경 없음)

| 구분 | blur |
|---|---|
| 카드 | 0~4px |
| 버튼 active | 4~6px |
| 아이콘 배지 | 제거 |
| 룰렛 베젤 | 유지 (CustomPainter 내부) |

---

## 실행 우선순위

### Priority 1 — Atmosphere 시스템 구축

- [ ] **P1-A** `AtmospherePreset` 모델 + 10개 프리셋 데이터 정의 (`lib/core/atmosphere_presets.dart`)
- [ ] **P1-B** `AppBackground` 위젯 그래디언트 렌더링으로 교체
- [ ] **P1-C** `AppThemeData.buildTheme()` → `Brightness.dark` 고정, `isDark` 파라미터 제거
- [ ] **P1-D** Settings 화면 — "테마 모드" 섹션 제거, Atmosphere 그리드 추가
- [ ] **P1-E** `PremiumService`에 `canUseAtmosphere(String id)` 추가
- [ ] **P1-F** `SettingsNotifier`/`SettingsRepository`에 `atmosphereId` 저장/로드 연동

### Priority 2 — isDark 분기 정리 + 글래스모피즘

- [ ] **P2-A** 전체 화면/위젯에서 `isDark` 분기 코드 제거
- [ ] **P2-B** 카드/네비바/바텀시트에 `BackdropFilter` 글래스모피즘 적용
- [ ] **P2-C** 헤더 영역 투명화 (Atmosphere 그래디언트 이어짐)
- [ ] **P2-D** 룰렛 카드 보더에 미세 glow 효과

### Priority 3 — 완성도

- [ ] **P3-A** WCAG AA 색상 대비 검수 (다크 베이스 기준)
- [ ] **P3-B** 전 화면 Atmosphere 적용 QA
- [ ] **P3-C** 스토어 스크린샷 재촬영

---

## 프리미엄 수익화 전략

```
Free:       2 Atmosphere + 2 Palette + 2 Wheel Style
Premium:    8 Atmosphere + 4 Palette + 6 Wheel Style
            ────────────
            ↑ 새로운 수익 축 추가
```

- Atmosphere는 **가장 직관적인 프리미엄 상품**: 앱을 열 때마다 보이는 것 = 배경
- 프리뷰만으로 구매 욕구 자극 (그래디언트는 시각적 임팩트 큼)
- 향후 시즌 한정 Atmosphere 추가 가능 (할로윈, 크리스마스 등)

---

## 참고 레퍼런스 스타일

- **배경 + 카드**: 게임 앱 다크 UI (Clash Royale, Coin Master 계열)
- **글래스모피즘**: iOS Control Center, macOS Dock 스타일
- **버튼 + 인터랙션**: 카카오 게임 스타일 (볼록한 3D 버튼) — 유지
- **결과 이펙트**: 로또/복권 앱 confetti 스타일 — 유지
