# ROADMAP - 랜덤 룰렛 메이커

## Phase 1 - 구조 고정 + 뼈대 (2~3일)

### 목표
빌드 에러 없이 실행되는 최소 뼈대 + 문서 완성

### 할일 체크리스트

#### 문서 / 기획
- [x] PRD.md 작성
- [x] UX_FLOW.md 작성
- [x] DATA_MODEL.md 작성
- [x] ROADMAP.md 작성
- [x] QA_CHECKLIST.md 작성

#### 프로젝트 구조
- [x] lib/core/ 폴더 생성 (constants, utils)
- [x] lib/data/ 폴더 생성 (storage abstraction, repositories)
- [x] lib/domain/ 폴더 생성 (모델 클래스)
- [x] lib/features/ 폴더 생성 (6개 feature)
- [x] lib/app.dart 생성 (MaterialApp + named routes + theme)
- [x] lib/main.dart 수정 (app.dart 연결)

#### 도메인 모델
- [x] domain/roulette.dart (Roulette 모델 + fromJson/toJson)
- [x] domain/item.dart (Item 모델 + fromJson/toJson)
- [x] domain/history.dart (History 모델 + fromJson/toJson)
- [x] domain/settings.dart (Settings 모델 + fromJson/toJson)

#### 데이터 레이어
- [x] data/local_storage.dart (SharedPreferences 추상화)
- [x] data/roulette_repository.dart (CRUD + 제한 체크)
- [x] data/templates_data.dart (10개 템플릿 const)

#### 화면 뼈대 (Scaffold + TODO 주석)
- [x] features/splash/ui/splash_screen.dart
- [x] features/home/ui/home_screen.dart + 더미 데이터 1개
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

## Phase 2 - 핵심 기능 구현 (1주)

### 목표
룰렛 CRUD + 스핀 애니메이션 + 로컬 저장 완성

### 할일 체크리스트

#### 저장소 연동
- [ ] pubspec.yaml에 `shared_preferences` 추가
- [ ] LocalStorage 실제 구현 (read/write)
- [ ] RouletteRepository CRUD 구현
- [ ] HistoryRepository 구현 (FIFO 20개 정책)
- [ ] SettingsRepository 구현

#### Home 화면 완성
- [ ] 룰렛 목록 실제 로드 (ChangeNotifier)
- [ ] 룰렛 카드 위젯 완성 (이름, 항목 수, 마지막 플레이)
- [ ] 빈 상태 UI 구현
- [ ] 3개 제한 BottomSheet 구현
- [ ] 카드 스와이프 삭제 구현

#### Editor 화면 완성
- [ ] 룰렛 이름 입력 + 유효성 검사
- [ ] 항목 추가 / 삭제 / 순서변경 (ReorderableListView)
- [ ] 색상 자동 할당 (팔레트 순환)
- [ ] 저장 로직 연동
- [ ] 뒤로가기 변경사항 확인 다이얼로그

#### Play 화면 완성
- [ ] `CustomPainter`로 룰렛 휠 그리기
- [ ] `AnimationController`로 스핀 애니메이션 구현
- [ ] 감속 곡선 (deceleration curve) 적용
- [ ] 결과 판정 로직 (각도 → 당첨 항목)
- [ ] 결과 모달 구현
- [ ] 히스토리 저장 연동
- [ ] 히스토리 BottomSheet

#### Templates 화면 완성
- [ ] 10개 템플릿 그리드 표시
- [ ] 상세 BottomSheet (항목 미리보기)
- [ ] "이 템플릿 사용" → Editor 연동

#### Settings 화면 완성
- [ ] 사운드 토글 + 즉시 저장
- [ ] 진동 토글 + 즉시 저장
- [ ] 앱 버전 표시

---

## Phase 3 - 완성도 + 배포 준비 (2주)

### 목표
앱스토어 배포 가능한 품질 달성

### 할일 체크리스트

#### 사운드 / 진동
- [ ] `audioplayers` 패키지 추가
- [ ] 스핀 효과음 에셋 추가 (mp3)
- [ ] 결과 효과음 에셋 추가
- [ ] `flutter_vibrate` 또는 `vibration` 패키지로 진동 구현

#### UI 완성도
- [ ] 다크 모드 지원 (ThemeData.dark())
- [ ] 룰렛 애니메이션 이펙트 개선 (confetti 등)
- [ ] 빈 상태 일러스트 추가
- [ ] 로딩 스켈레톤 UI

#### 공유 기능
- [ ] `clipboard` 패키지로 결과 텍스트 복사
- [ ] 스크린샷 안내 토스트

#### 접근성
- [ ] 주요 위젯 Semantics 레이블 추가
- [ ] 색상 대비 검수 (WCAG AA)
- [ ] 폰트 크기 스케일 대응

#### 성능
- [ ] 프로파일 모드 FPS 측정
- [ ] 룰렛 휠 렌더링 최적화 (캐시 적용)

#### 테스트
- [ ] QA_CHECKLIST.md 기준 수동 테스트 전항목 통과
- [ ] 단위 테스트: 모델 직렬화/역직렬화
- [ ] 단위 테스트: Repository CRUD
- [ ] 위젯 테스트: 핵심 화면 3개

#### 배포 준비
- [ ] 앱 아이콘 제작 (1024x1024)
- [ ] 스토어 스크린샷 5장 제작
- [ ] Android: `flutter build appbundle`
- [ ] iOS: `flutter build ipa`
- [ ] Google Play Console 등록
- [ ] App Store Connect 등록

#### 프리미엄 준비 (선택)
- [ ] RevenueCat 또는 in_app_purchase 연동 설계
- [ ] 프리미엄 페이월 UI 설계
