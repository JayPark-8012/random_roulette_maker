# DATA_MODEL - 랜덤 룰렛 메이커

## 1. 도메인 모델 정의

### 1.1 Roulette (룰렛)

```dart
class Roulette {
  final String id;           // UUID v4
  final String name;         // 룰렛 이름 (최대 30자)
  final List<Item> items;    // 항목 목록 (최소 2개)
  final DateTime createdAt;  // 생성 시각
  final DateTime updatedAt;  // 마지막 수정 시각
  final DateTime? lastPlayedAt; // 마지막 플레이 시각 (null: 한 번도 안 함)
}
```

| 필드 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | String | UUID, PK | 고유 식별자 |
| name | String | 1~30자, 필수 | 사용자 지정 이름 |
| items | List\<Item\> | 최소 2개 | 룰렛 항목 목록 |
| createdAt | DateTime | ISO 8601 | 생성 시각 |
| updatedAt | DateTime | ISO 8601 | 마지막 수정 시각 |
| lastPlayedAt | DateTime? | nullable | 마지막 플레이 시각 |

---

### 1.2 Item (항목)

```dart
class Item {
  final String id;      // UUID v4
  final String label;   // 표시 텍스트 (최대 20자)
  final int colorValue; // Color.value (ARGB int)
  final int order;      // 표시 순서 (0-based)
  final int weight;     // 가중치 1~10 (기본값 1)
}
```

| 필드 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | String | UUID | 항목 고유 식별자 |
| label | String | 1~20자, 필수 | 룰렛 섹터에 표시될 텍스트 |
| colorValue | int | ARGB int | 섹터 배경색 |
| order | int | 0 이상 | 표시 순서 |
| weight | int | 1~10, 기본값 1 | 당첨 가중치. weight=1이면 균등 확률과 동일. 기존 데이터 `fromJson`에서 null → 1로 마이그레이션 |

**기본 색상 팔레트** (순환 할당):
```dart
const List<int> kDefaultColors = [
  0xFFE57373, // Red 300
  0xFF64B5F6, // Blue 300
  0xFF81C784, // Green 300
  0xFFFFD54F, // Amber 300
  0xFFBA68C8, // Purple 300
  0xFF4DB6AC, // Teal 300
  0xFFFF8A65, // Deep Orange 300
  0xFF90A4AE, // Blue Grey 300
];
```

---

### 1.3 History (히스토리)

```dart
class History {
  final String id;           // UUID v4
  final String rouletteId;   // 해당 룰렛 ID (FK)
  final String resultLabel;  // 당첨 항목 텍스트 (스냅샷)
  final int resultColorValue; // 당첨 항목 색상 (스냅샷)
  final DateTime playedAt;   // 플레이 시각
}
```

| 필드 | 타입 | 제약 | 설명 |
|------|------|------|------|
| id | String | UUID | 히스토리 고유 식별자 |
| rouletteId | String | FK | 어떤 룰렛의 결과인지 |
| resultLabel | String | 1~20자 | 당첨 항목 텍스트 스냅샷 |
| resultColorValue | int | ARGB int | 당첨 항목 색상 스냅샷 |
| playedAt | DateTime | ISO 8601 | 플레이 시각 |

> **주의**: 룰렛이 삭제되면 관련 히스토리도 함께 삭제 (cascade delete)

---

### 1.4 Settings (앱 설정)

```dart
enum SpinSpeed { normal, fast }

class Settings {
  final bool soundEnabled;         // 사운드 ON/OFF (기본: true)
  final bool hapticEnabled;        // 진동(햅틱) ON/OFF (기본: true)
  final SpinSpeed spinSpeed;       // 스핀 속도 (기본: normal)
  final String? lastUsedRouletteId; // 마지막으로 플레이한 룰렛 ID
  final String atmosphereId;       // Atmosphere 배경 프리셋 ID (기본: 'deep_space')
  final String themeId;            // 앱 팔레트 테마 ID (기본: 'indigo')
  final String wheelThemeId;       // 휠 렌더링 테마 ID (기본: 'classic')
}
```

| 필드 | 타입 | 기본값 | 설명 |
|------|------|--------|------|
| soundEnabled | bool | true | 스핀 효과음 재생 여부 |
| hapticEnabled | bool | true | 결과 발표 시 HapticFeedback.mediumImpact() 여부 |
| spinSpeed | SpinSpeed | normal | normal(3~5초) / fast(1~2초) |
| lastUsedRouletteId | String? | null | 마지막 플레이 룰렛 ID (홈 진입 시 활용 예정) |
| atmosphereId | String | 'deep_space' | Atmosphere 배경 프리셋 ID. 유효하지 않은 값 시 기본값 fallback |
| themeId | String | 'indigo' | 앱 색상 팔레트 ID |
| wheelThemeId | String | 'classic' | 휠 렌더링 스타일 ID |

> **이전 키 호환**: `vibrationEnabled` → `hapticEnabled`로 변경. `fromJson`에서 fallback 처리.
> **테마 모드 제거**: `AppThemeMode`(system/light/dark) enum 삭제. 항상 다크 베이스 고정. 기존 `themeMode` 키는 fromJson에서 무시.

---

### 1.5 AtmospherePreset (배경 프리셋, 하드코딩)

> 런타임 수정 없이 앱 내 Dart const로 정의. 저장소에 저장하지 않음.

```dart
class AtmospherePreset {
  final String id;           // 'deep_space', 'aurora', ...
  final String nameKey;      // i18n 키 (예: 'atmosphere_deep_space')
  final bool isLocked;       // 프리미엄 전용 여부
  final bool hasPattern;     // CustomPainter 오버레이 패턴 여부
  // gradient, solidColor, surfaceColor, overlayColor는 런타임 생성
}
```

| ID | 이름 | 스타일 | 프리미엄 |
|---|---|---|---|
| `deep_space` | Deep Space | 딥 네이비→블랙 리니어 그래디언트 | Free |
| `charcoal` | Charcoal | 뉴트럴 다크 그레이 솔리드 | Free |
| `aurora` | Aurora | 보라→틸→핑크 멀티 리니어 | Premium |
| `sunset_glow` | Sunset Glow | 딥 오렌지→다크 퍼플 리니어 | Premium |
| `ocean_depth` | Ocean Depth | 딥 블루→다크 시안 리니어 | Premium |
| `neon_city` | Neon City | 다크 + 핑크/블루 엣지 래디얼 글로우 | Premium |
| `forest_night` | Forest Night | 다크 그린→블랙 리니어 | Premium |
| `rose_gold` | Rose Gold | 다크 로즈→골드 틴트 리니어 | Premium |
| `starfield` | Starfield | 블랙 + 미세 도트 패턴 | Premium |
| `lava` | Lava | 딥 레드→다크 오렌지 래디얼 | Premium |

---

## 2. JSON 직렬화 스키마

### Roulette JSON
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "점심 메뉴 룰렛",
  "items": [
    {
      "id": "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
      "label": "짜장면",
      "colorValue": -1717452299,
      "order": 0,
      "weight": 2
    },
    {
      "id": "6ba7b811-9dad-11d1-80b4-00c04fd430c8",
      "label": "짬뽕",
      "colorValue": -10148534,
      "order": 1,
      "weight": 1
    }
  ],
  "createdAt": "2025-01-15T09:00:00.000Z",
  "updatedAt": "2025-01-15T09:00:00.000Z",
  "lastPlayedAt": null
}
```

### History JSON
```json
{
  "id": "7c9e6679-7425-40de-944b-e07fc1f90ae7",
  "rouletteId": "550e8400-e29b-41d4-a716-446655440000",
  "resultLabel": "짜장면",
  "resultColorValue": -1717452299,
  "playedAt": "2025-01-15T12:30:00.000Z"
}
```

### Settings JSON
```json
{
  "soundEnabled": true,
  "hapticEnabled": true,
  "spinSpeed": "normal",
  "lastUsedRouletteId": "550e8400-e29b-41d4-a716-446655440000",
  "atmosphereId": "deep_space",
  "themeId": "indigo",
  "wheelThemeId": "classic",
  "schemaVersion": 2
}
```
> `spinSpeed` 허용값: `"normal"` | `"fast"`
> `atmosphereId`: 유효하지 않은 ID 시 `"deep_space"`로 fallback
> **스키마 버전 2 마이그레이션**: `themeMode` 키 삭제, `atmosphereId` 기본값 추가

---

## 3. 로컬 저장 정책

### 3.1 저장소 선택
- **MVP**: `SharedPreferences` 패키지 사용
  - 룰렛 목록: JSON 문자열 배열로 저장
  - 히스토리: 룰렛별 분리 저장
  - 설정: 개별 키로 저장
- **Post-MVP 고려**: `sqflite` 또는 `drift` (히스토리 쿼리 복잡도 증가 시)

### 3.2 SharedPreferences 키 구조
```
app_data_version         → int    (현재: 1 — 스키마 버전)
roulette_list            → String (JSON Array of Roulette)
history_{rouletteId}     → String (JSON Array of History, 최대 20개)
settings                 → String (JSON Settings)
spin_mode_{rouletteId}   → String (JSON SpinMode — 중복 제외 상태, 재시작 후에도 유지)
```

#### SpinMode JSON 포맷
```json
{
  "noRepeat": true,
  "autoReset": false,
  "excludedIds": [
    "6ba7b810-9dad-11d1-80b4-00c04fd430c8",
    "6ba7b811-9dad-11d1-80b4-00c04fd430c8"
  ]
}
```

| 필드 | 타입 | 설명 |
|------|------|------|
| noRepeat | bool | 중복 제외 ON/OFF (기본: false) |
| autoReset | bool | 모두 뽑히면 자동 리셋 ON/OFF (기본: false) |
| excludedIds | List\<String\> | 이미 뽑힌 Item.id 목록. noRepeat OFF 시 무시됨 |

> **삭제 정책**: 룰렛 삭제 시 해당 `spin_mode_{rouletteId}` 키 함께 삭제 필요 (RouletteRepository.delete()에서 처리)

### 3.3 히스토리 보존 정책
- 룰렛당 최대 **20개** 히스토리 유지
- 21번째 저장 시 가장 오래된 항목(index 0) 자동 제거 (FIFO)
- 룰렛 삭제 시 해당 `history_{rouletteId}` 키 즉시 삭제 (cascade)

### 3.4 스키마 버전 및 마이그레이션
- `app_data_version` 키(int)로 버전 관리
- 현재 버전: **2**
- `LocalStorage._ensureSchemaVersion()`에서 초기화
- 향후 스키마 변경 시 `stored < currentVersion` 분기로 마이그레이션

#### 버전 1 → 2 마이그레이션
- `settings.themeMode` 키 무시 (삭제)
- `settings.atmosphereId` 없으면 기본값 `"deep_space"` 추가

### 3.5 무료 제한 정책 (코드 적용 완료)
| 제한 항목 | 값 | 위반 시 처리 |
|---------|---|-----------|
| 룰렛 최대 개수 | 3개 | `RouletteRepository.create()` Exception → 프리미엄 다이얼로그 |
| 히스토리 최대 개수 | 20개 | FIFO 자동 삭제 |
| 룰렛 이름 최대 길이 | 30자 | TextField maxLength |
| 항목 텍스트 최대 길이 | 20자 | TextField maxLength |
| 항목 최소 개수 | 2개 | `EditorNotifier.save()` 차단 + 빨간 테두리 하이라이트 |
| 항목 가중치 범위 | 1~10 | Editor 가중치 모드에서 +/- 버튼으로 조절. `clamp(1, 10)` 적용 |

### 3.6 데이터 용량 추정
| 항목 | 용량 추정 |
|------|---------|
| 룰렛 1개 (항목 10개) | ~2KB |
| 히스토리 20개 | ~3KB |
| 설정 | ~100B |
| **총 최대 (룰렛 3개 기준)** | **~20KB** |

---

## 4. 템플릿 데이터 (하드코딩)

템플릿은 런타임 수정 없이 앱 내 Dart const로 정의.
저장소에 저장하지 않고, 사용 시 복사본을 Roulette으로 변환하여 저장.

```dart
// lib/data/templates_data.dart
const List<Map<String, dynamic>> kTemplates = [
  {
    'id': 'template_001',
    'name': '점심 메뉴',
    'category': '식사',
    'items': ['짜장면', '짬뽕', '냉면', '삼겹살', '피자', '치킨'],
  },
  // ... 10개
];
```
