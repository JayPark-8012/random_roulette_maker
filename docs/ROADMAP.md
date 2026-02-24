# ROADMAP - 랜덤 룰렛 메이커

> 마지막 업데이트: 2026-02-24

---

## Phase 1 ✅ — 구조 고정 + 뼈대

### 목표
빌드 에러 없이 실행되는 최소 뼈대 + 문서 완성

### 체크리스트

#### 문서 / 기획
- [x] PRD.md 작성
- [x] UX_FLOW.md 작성
- [x] DATA_MODEL.md 작성
- [x] ROADMAP.md 작성
- [x] QA_CHECKLIST.md 작성

#### 프로젝트 구조
- [x] lib/core/ 폴더 (constants, utils)
- [x] lib/data/ 폴더 (storage abstraction, repositories)
- [x] lib/domain/ 폴더 (모델 클래스)
- [x] lib/features/ 폴더 (6개 feature)
- [x] lib/app.dart (MaterialApp + named routes + theme)
- [x] lib/main.dart (app.dart 연결)

#### 도메인 모델
- [x] domain/roulette.dart (Roulette 모델 + fromJson/toJson)
- [x] domain/item.dart (Item 모델 + fromJson/toJson)
- [x] domain/history.dart (History 모델 + fromJson/toJson)
- [x] domain/settings.dart (Settings 모델 + fromJson/toJson)

#### 데이터 레이어
- [x] data/local_storage.dart (인메모리 저장소)
- [x] data/roulette_repository.dart (CRUD + FIFO 히스토리 20개)
- [x] data/templates_data.dart (10개 템플릿 const)

#### 화면 뼈대
- [x] features/splash/ui/splash_screen.dart
- [x] features/home/ui/home_screen.dart
- [x] features/editor/ui/editor_screen.dart
- [x] features/play/ui/play_screen.dart
- [x] features/templates/ui/templates_screen.dart
- [x] features/settings/ui/settings_screen.dart

#### 상태 관리 (ChangeNotifier)
- [x] features/home/state/home_notifier.dart
- [x] features/editor/state/editor_notifier.dart
- [x] features/play/state/play_notifier.dart
- [x] features/settings/state/settings_notifier.dart

---

## Phase 2 ✅ — 핵심 기능 구현

### 목표
룰렛 CRUD + 스핀 로직 + 저장 기능 완성

### 체크리스트

#### 저장소 연동
- [x] RouletteRepository CRUD 완전 구현
- [x] HistoryRepository FIFO 20개 정책
- [x] SettingsRepository 구현
- [ ] LocalStorage → SharedPreferences 교체 *(현재 인메모리, Phase 6에서 처리)*

#### Home 화면
- [x] 룰렛 목록 실제 로드 (ChangeNotifier)
- [x] 룰렛 카드 위젯 (이름, 항목 수, 마지막 플레이)
- [x] 빈 상태 UI
- [x] 3개 제한 BottomSheet
- [x] 카드 스와이프 삭제

#### Editor 화면
- [x] 룰렛 이름 입력 + 유효성 검사
- [x] 항목 추가 / 삭제 / 순서변경 (ReorderableListView)
- [x] 색상 자동 할당 (팔레트 순환)
- [x] 저장 로직 연동
- [x] 뒤로가기 변경사항 확인 다이얼로그

#### Play 화면 (기능)
- [x] CustomPainter 룰렛 휠 그리기
- [x] AnimationController 스핀 애니메이션
- [x] 감속 곡선 적용
- [x] 결과 판정 로직 (각도 → 당첨 항목)
- [x] 결과 모달
- [x] 히스토리 저장 연동
- [x] 히스토리 BottomSheet

#### Templates 화면
- [x] 10개 템플릿 그리드 표시
- [x] 상세 BottomSheet (항목 미리보기)
- [x] "이 템플릿 사용" → Editor 연동

#### Settings 화면 (기능)
- [x] 사운드 토글 저장
- [x] 진동 토글 저장
- [x] 앱 버전 표시

---

## Phase 3 ✅ — Home 화면 UI 고도화

### 목표
Home 화면을 게임 앱 수준의 비주얼로 업그레이드

### 체크리스트

- [x] 앱 이름 텍스트 → 로고 스타일 커스텀 위젯
- [x] 룰렛 카드 BoxDecoration (LinearGradient + border + glow shadow)
- [x] 카드 헤더 아이콘 배지 스타일
- [x] 사용량 뱃지 `ValueListenableBuilder<PremiumState>` ("2/3", "2/∞" 동적 표시)
- [x] FAB → 게임스러운 커스텀 추가 버튼
- [x] 빈 상태 일러스트 개선

---

## Phase 4 ✅ — Premium / 수익화 연동

### 목표
프리미엄 서비스 구조 완성 + 광고 서비스 더미 구현

### 체크리스트

#### Premium 서비스
- [x] PremiumService 싱글턴 (ValueNotifier<PremiumState>)
- [x] MockPurchaseProvider 구현 (개발/테스트용)
- [x] SplashNotifier.initializeApp()에서 PremiumService.initialize() 호출
- [x] 헬퍼: `maxSets`, `isUnlimitedSets`, `formatSetCountLabel(n)`, `canCreateNewSet(n)`
- [x] HomeNotifier.canCreate → PremiumService 위임 (하드코딩 제거)

#### UI 연동
- [x] home_screen _UsageBadge: ValueListenableBuilder로 실시간 갱신
- [x] settings_screen GridView: ValueListenableBuilder로 테마 잠금 즉시 반영
- [x] _ThemePreviewCard.isLocked 동적 계산 (`!isPremium && theme.isLocked`)

#### 광고 서비스
- [x] lib/data/ad_service.dart 생성
- [x] showInterstitial / showRewarded / showBanner 더미 구현
- [x] 프리미엄 유저 광고 차단 guard

---

## Phase 5 ✅ — Play / Tools UI 고도화

### 목표
Play 화면과 도구 탭을 게임 앱 수준의 비주얼로 업그레이드

### 체크리스트

#### Play 화면 UI (Phase A~C)
- [x] **A** — 룰렛 휠 메탈릭 베젤 (6레이어) + 허브 (4레이어) + 앰버 포인터
- [x] **A** — primaryColor 파라미터 기반 글로우 링
- [x] **B** — SPIN 버튼 pulse glow 애니메이션 (1500ms, 비활성 시 정지)
- [x] **C1** — 모드 세그먼트 컬러화 (Lottery=#22C55E, Round=#3B82F6, Custom=#F59E0B)
- [x] **C2** — AppBar 제거 → SafeArea + 슬림 커스텀 헤더 (뒤로가기 + 룰렛명 + 아이콘 버튼)

#### Tools 탭 UI (Phase A~D)
- [x] **A** — 카드 BoxDecoration (LinearGradient + 컬러 border + glow)
- [x] **A** — 아이콘 배지 헤더 위젯 (`_cardHeader`)
- [x] **A** — 가로 스크롤 히스토리 배지 (`_historyRow`)
- [x] **A** — `_PremiumButton` pulse glow (1200ms repeat reverse)
- [x] **B** — `_CoinCard` StatefulWidget + 3D 플립 애니메이션 (600ms easeInOut)
- [x] **B** — 코인 앞면 골드 메탈릭 / 뒷면 실버 메탈릭 + 광택 하이라이트
- [x] **B** — `_DiceFacePainter` D6 눈 위치 CustomPainter
- [x] **C** — `_DiceCard` StatefulWidget + 감속 카운터 (10틱: 35→190ms)
- [x] **C** — 굴리는 중 면수 토글·버튼 비활성 + 눈 dim (rolling 파라미터)
- [x] **C** — 종료 시 `_ResultBounce` 바운스 트리거
- [x] **D** — `_NumberCard` StatefulWidget + 감속 카운터 (12틱: 30→240ms)
- [x] **D** — 생성 중 TextField 비활성 + 숫자 dim
- [x] **D** — 검증 로직 `_startGenerate()`로 이동 (SnackBar 후 조기 리턴)

---

## Phase 6 ⏳ — 사운드 / 진동 / 결제 실제 연동

### 목표
실제 게임 피드백 + 프리미엄 결제 완성

### 체크리스트

#### 사운드
- [ ] `audioplayers` 패키지 추가 (pubspec.yaml)
- [ ] 스핀 효과음 에셋 추가 (mp3)
- [ ] 결과 효과음 에셋 추가
- [ ] SettingsNotifier 사운드 토글 실제 연동

#### 진동
- [ ] `vibration` 패키지 추가
- [ ] 스핀 시작 / 결과 확정 햅틱 구현
- [ ] SettingsNotifier 진동 토글 실제 연동

#### 결제 (인앱 결제)
- [ ] `in_app_purchase` 패키지 추가
- [ ] MockPurchaseProvider → 실제 PurchaseProvider 교체
- [ ] 상품 ID 등록 (Google Play / App Store)
- [ ] 구매 복원 기능 구현
- [ ] 프리미엄 페이월 UI 완성

#### 영속성 저장소
- [ ] `shared_preferences` 패키지 연동
- [ ] LocalStorage 인메모리 → SharedPreferences 교체

#### 기타 기능
- [ ] 결과 클립보드 복사 (`flutter/services` Clipboard API)
- [ ] 결과 공유 스크린샷 안내 토스트

---

## Phase 7 ⏳ — QA / 접근성 / 배포 준비

### 목표
앱스토어 배포 가능한 품질 달성

### 체크리스트

#### 테스트
- [ ] QA_CHECKLIST.md 전항목 수동 테스트 통과
- [ ] 단위 테스트: 모델 직렬화/역직렬화
- [ ] 단위 테스트: Repository CRUD
- [ ] 위젯 테스트: 핵심 화면 3개

#### 접근성
- [ ] 주요 위젯 Semantics 레이블 추가
- [ ] 색상 대비 검수 (WCAG AA)
- [ ] 폰트 크기 스케일 대응

#### 성능
- [ ] 프로파일 모드 FPS 측정 (룰렛 스핀 60fps 목표)
- [ ] 룰렛 휠 렌더링 최적화 (RepaintBoundary / 캐시)

#### 배포 준비
- [ ] 앱 아이콘 제작 (1024×1024)
- [ ] 스토어 스크린샷 5장 제작
- [ ] Android: `flutter build appbundle --release`
- [ ] iOS: `flutter build ipa --release`
- [ ] Google Play Console 등록
- [ ] App Store Connect 등록
