# DESIGN_DIRECTION — 랜덤 룰렛 메이커

> 마지막 업데이트: 2026-02-24

---

## 진단 요약

### 현재 문제

| 요소 | 위치 | 문제 |
|---|---|---|
| Bokeh 블롭 4개 | `app_background.dart` | 방사형 그라데이션 중첩 → 흐릿한 haze |
| Box Shadow 고블러 | 홈/툴/Play 전반 | blur 12~24px → 경계 뭉개짐 |
| 카드 그라데이션 | `roulette_card.dart` | 반투명 tint 레이어 → 낮은 대비 |
| 로고 Rainbow 6색 | `home_screen.dart` | 방향성 없는 화려함 |
| 글로우 링 | 세그먼트 탭 active | 빛번짐 → 유틸 앱 느낌 |

### 왜 게임 느낌이 안 나는가

```
게임 앱 특징            현재 상태
────────────────────────────────────────
굵고 선명한 윤곽선   →  그라데이션+글로우로 뭉개짐
강한 색 대비          →  반투명 tint로 채도 낮음
"눌리는" 버튼감       →  flat 버튼, 반응 약함
명확한 주인공 요소   →  FAB + 카드 + 배지 동등 경쟁
파티클/이펙트 순간   →  결과 후 애니메이션 없음
짧고 강한 타이포     →  긴 설명, 작은 아이콘
```

---

## 디자인 컨셉: **"선명한 아케이드"** (Sharp Arcade)

> 흐릿함 → 선명함 / 소프트 → 크리스프 / 복잡 → 임팩트

---

## 개선 항목

### A. 배경 & 전체 분위기

- **Bokeh 블롭 제거** → 단색 어두운 배경
  - 다크: `#0D0D14` or `#111118` (순수 다크)
  - 라이트: `#F4F4F8` (오프-화이트)
- 배경 그라데이션 전면 제거
- 필요 시: 매우 얇은 노이즈 텍스처 오버레이만 허용

### B. 카드 디자인

```
Before: LinearGradient tint + 반투명 border + blur shadow 12~24px
After:  단색 배경 (#1A1A28) + 2px 선명한 컬러 border + shadow 없거나 최소
```

- `Border.all(color: accentColor, width: 2)` 스타일
- `borderRadius: 16`
- `elevation: 0` (Material elevation 제거)

### C. 세그먼트 탭 → 하단 네비게이션 바

```
Before: 상단 세그먼트 바, 아이콘+텍스트 세로 58px
After:  하단 NavigationBar (Material 3)
        active: filled icon + 컬러
        inactive: outlined icon + 회색
```

탭 구성:
| 탭 | 아이콘 (filled) | 아이콘 (outlined) |
|---|---|---|
| 룰렛 | `track_changes` | `track_changes_outlined` |
| 코인 | `monetization_on` | `monetization_on_outlined` |
| 주사위 | `casino` | `casino_outlined` |
| 숫자 | `tag` | `tag` (outlined) |

### D. 버튼 & 인터랙션

| 현재 | 개선 |
|---|---|
| FAB Extended (텍스트+아이콘) | 아이콘 FAB (라벨 선택적) |
| 텍스트 액션 버튼 | Icon prefix 필수 |
| SPIN 버튼 pulse glow | 3D 볼록 버튼 (gradient + inner highlight) |

### E. 박스 섀도우 정책

| 구분 | 현재 blur | 개선 blur |
|---|---|---|
| 카드 | 12~24px | 0~4px |
| 버튼 active | 12px | 4~6px |
| 아이콘 배지 | 10px | 제거 |
| 룰렛 베젤 | 유지 (CustomPainter 내부) | 유지 |

### F. 결과 화면 강화 (핵심 게임 모먼트)

- 결과 텍스트: 매우 큰 폰트 (72~96sp)
- 결과 배경: 당첨 항목 색상으로 Flash 애니메이션
- confetti 파티클 (CustomPainter 기반)
- 진동 패턴 강화

### G. 타이포그래피

```
제목:    FontWeight.w900, 적극적 크기
결과값:  매우 큰 폰트 (72~96sp), Tabular figures
설명:    FontWeight.w400, muted color
버튼:    FontWeight.w700
```

---

## 실행 우선순위

### Priority 1 — 즉각 효과 (Phase 6에서 처리)

- [ ] **P1-A** Bokeh 블롭 제거 → 단색 배경
- [ ] **P1-B** 박스 섀도우 blur 12~24px → 4~6px 축소
- [ ] **P1-C** 카드 그라데이션 → 단색 + 컬러 border
- [ ] **P1-D** 세그먼트 탭 → 하단 NavigationBar
- [ ] **P1-E** SPIN 버튼 3D 스타일

### Priority 2 — 중기 개선

- [ ] **P2-A** 결과 화면 confetti + Flash 효과
- [ ] **P2-B** 아이콘 통일 (filled/outlined 규칙)
- [ ] **P2-C** 타이포 스케일 재정의
- [ ] **P2-D** 앱 아이콘 + 스플래시 리뉴얼

### Priority 3 — 완성도

- [ ] **P3-A** WCAG AA 색상 대비 검수
- [ ] **P3-B** 다크/라이트 각각 QA
- [ ] **P3-C** 스토어 스크린샷 재촬영

---

## 참고 레퍼런스 스타일

- **배경 + 카드**: Wordle, NYT Games 계열 (깔끔 + 선명)
- **버튼 + 인터랙션**: 카카오 게임 스타일 (볼록한 3D 버튼)
- **결과 이펙트**: 로또/복권 앱 confetti 스타일
