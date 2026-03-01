// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Spin Wheel – 랜덤 룰렛';

  @override
  String get homeTitle => 'Spin Wheel – 랜덤 룰렛';

  @override
  String get settingsTooltip => '설정';

  @override
  String get tabRoulette => '룰렛';

  @override
  String get tabCoin => '코인';

  @override
  String get tabDice => '주사위';

  @override
  String get tabNumber => '숫자';

  @override
  String get sectionMySets => '내 룰렛 세트';

  @override
  String get fabCreateNew => '새 룰렛 만들기';

  @override
  String get emptyTitle => '아직 생성된 룰렛이 없어요';

  @override
  String get emptySubtitle => '결정하기 힘든 고민이 있다면\n지금 바로 첫 번째 룰렛을 만들어 보세요!';

  @override
  String get emptyButton => '첫 룰렛 만들기';

  @override
  String get createBlankTitle => '빈 룰렛으로 시작';

  @override
  String get createBlankSubtitle => '항목을 직접 입력합니다';

  @override
  String get createTemplateTitle => '스타터 세트';

  @override
  String get createTemplateSubtitle => '미리 설정된 세트로 시작';

  @override
  String duplicated(String name) {
    return '\"$name\"을(를) 복제했습니다.';
  }

  @override
  String get limitTitle => '룰렛 제한';

  @override
  String limitContent(int count) {
    return '무료 플랜은 최대 $count개까지 저장할 수 있습니다.\n기존 룰렛을 삭제하거나 프리미엄으로 업그레이드해 보세요.';
  }

  @override
  String get actionClose => '닫기';

  @override
  String get actionCancel => '취소';

  @override
  String get actionDelete => '삭제';

  @override
  String get actionSave => '저장';

  @override
  String get actionConfirm => '확인';

  @override
  String get actionLeave => '나가기';

  @override
  String get actionRename => '변경';

  @override
  String get premiumComingSoon => '프리미엄 기능은 준비 중입니다.';

  @override
  String get premiumButton => '프리미엄 알아보기';

  @override
  String get editorTitleEdit => '룰렛 편집';

  @override
  String get editorTitleNew => '룰렛 만들기';

  @override
  String get deleteRouletteTooltip => '룰렛 삭제';

  @override
  String get addItemTooltip => '항목 추가';

  @override
  String get rouletteNameLabel => '룰렛 이름';

  @override
  String get rouletteNameHint => '예: 오늘 점심 메뉴';

  @override
  String get rouletteNameError => '이름을 입력해 주세요';

  @override
  String itemsHeader(int count) {
    return '항목 ($count개)';
  }

  @override
  String get dragHint => '드래그하여 순서 변경';

  @override
  String get previewLabel => '실시간 프리뷰';

  @override
  String get emptyItemLabel => '(빈 항목)';

  @override
  String moreItems(int count) {
    return '+ $count개 더';
  }

  @override
  String get exitTitle => '저장하지 않고 나가기';

  @override
  String get exitContent => '변경사항이 저장되지 않습니다. 나가시겠어요?';

  @override
  String get actionContinueEditing => '계속 편집';

  @override
  String get deleteRouletteTitle => '룰렛 삭제';

  @override
  String get deleteRouletteContent => '이 룰렛을 삭제할까요?\n히스토리도 함께 삭제됩니다.';

  @override
  String cardDeleteContent(String name) {
    return '\"$name\"을(를) 삭제할까요?\n히스토리도 함께 삭제됩니다.';
  }

  @override
  String get renameTitle => '이름 변경';

  @override
  String get playFallbackTitle => '룰렛';

  @override
  String get notEnoughItems => '항목이 부족합니다. 편집 화면에서 추가해 주세요.';

  @override
  String get modeLottery => '추첨';

  @override
  String get modeRound => '라운드';

  @override
  String get modeCustom => '커스텀';

  @override
  String remainingItems(int count) {
    return '남은 항목 $count개';
  }

  @override
  String roundStatus(int current, int total) {
    return '라운드 $current / $total개';
  }

  @override
  String get noRepeat => '중복 제외';

  @override
  String get autoReset => '자동 리셋';

  @override
  String get allPicked => '모든 항목을 뽑았습니다!';

  @override
  String get actionReset => '리셋';

  @override
  String get spinLabel => 'SPIN';

  @override
  String get spinningLabel => '돌아가는 중...';

  @override
  String get historyTitle => '최근 결과';

  @override
  String get noHistory => '아직 기록이 없습니다.';

  @override
  String get shareTitle => '공유';

  @override
  String get shareTextTitle => '텍스트 공유';

  @override
  String get shareTextSubtitle => '룰렛명과 결과를 텍스트로';

  @override
  String get shareImageTitle => '이미지 공유';

  @override
  String get shareImageSubtitle => '룰렛 화면을 이미지로';

  @override
  String get shareImageFailed => '이미지 공유에 실패했습니다.';

  @override
  String get resultLabel => '당첨 항목';

  @override
  String get actionReSpin => '다시 돌리기';

  @override
  String get actionCopy => '내용 복사';

  @override
  String get copiedMessage => '결과를 클립보드에 복사했습니다.';

  @override
  String get statsTooltip => '통계';

  @override
  String get historyTooltip => '히스토리';

  @override
  String get settingsTitle => '설정';

  @override
  String get sectionTheme => '테마';

  @override
  String get screenModeLabel => '화면 모드';

  @override
  String get themeModeSystem => '시스템';

  @override
  String get themeModeLight => '라이트';

  @override
  String get themeModeDark => '다크';

  @override
  String get colorPaletteLabel => '색상 팔레트';

  @override
  String get wheelThemeLabel => '룰렛 휠 테마';

  @override
  String get premiumThemeTitle => '프리미엄 테마';

  @override
  String get premiumThemeContent => '이 테마는 프리미엄 기능입니다.\n업그레이드 후 사용하실 수 있습니다.';

  @override
  String get sectionFeedback => '피드백';

  @override
  String get soundLabel => '사운드';

  @override
  String get soundSubtitle => '스핀 및 결과 효과음';

  @override
  String get soundPackLabel => '사운드 팩';

  @override
  String get packBasic => '기본';

  @override
  String get packClicky => '클리키';

  @override
  String get packParty => '파티';

  @override
  String get vibrationLabel => '진동(햅틱)';

  @override
  String get vibrationSubtitle => '결과 발표 시 진동';

  @override
  String get hapticOff => '없음';

  @override
  String get hapticLight => '약하게';

  @override
  String get hapticStrong => '강하게';

  @override
  String get sectionSpinTime => '스핀 시간';

  @override
  String get spinShort => '짧게 (2초)';

  @override
  String get spinNormal => '기본 (4.5초)';

  @override
  String get spinLong => '길게 (7초)';

  @override
  String get sectionLanguage => '언어';

  @override
  String get langSystem => '시스템(권장)';

  @override
  String get langEn => 'English';

  @override
  String get langKo => '한국어';

  @override
  String get langEs => 'Español';

  @override
  String get langPtBr => 'Português (Brasil)';

  @override
  String get langJa => '日本語';

  @override
  String get langZhHans => '简体中文';

  @override
  String get sectionAppInfo => '앱 정보';

  @override
  String get versionLabel => '버전';

  @override
  String get openSourceLabel => '오픈소스 라이선스';

  @override
  String get contactLabel => '문의하기';

  @override
  String get comingSoon => '준비 중입니다.';

  @override
  String get coinFlipTitle => '코인 플립';

  @override
  String get coinHeads => '앞';

  @override
  String get coinTails => '뒤';

  @override
  String get actionFlip => '뒤집기';

  @override
  String get recent10 => '최근 10회';

  @override
  String get diceTitle => '주사위';

  @override
  String rollDice(int type) {
    return 'D$type 굴리기';
  }

  @override
  String get diceD4Name => '정사면체';

  @override
  String get diceD6Name => '정육면체';

  @override
  String get diceD8Name => '정팔면체';

  @override
  String get diceD10Name => '정십면체';

  @override
  String get diceD12Name => '정십이면체';

  @override
  String get diceD20Name => '정이십면체';

  @override
  String diceRange(int max) {
    return '1 ~ $max 사이';
  }

  @override
  String get randomNumberTitle => '랜덤 숫자';

  @override
  String get minLabel => '최솟값';

  @override
  String get maxLabel => '최댓값';

  @override
  String get actionGenerate => '생성';

  @override
  String get recent20 => '최근 20회';

  @override
  String get minMaxError => '최솟값은 최댓값보다 작아야 합니다.';

  @override
  String get splashTitle => 'Spin Wheel – 랜덤 룰렛';

  @override
  String get splashSubtitle => '나만의 룰렛을 만들어 보세요';

  @override
  String get templatesTitle => '스타터 세트';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count개 항목';
  }

  @override
  String get useTemplate => '이 세트 사용';

  @override
  String freePlanLimit(int count) {
    return '무료 플랜은 최대 $count개까지 가능합니다';
  }

  @override
  String itemCount(int count) {
    return '항목 $count개';
  }

  @override
  String get menuEdit => '편집';

  @override
  String get menuDuplicate => '복제';

  @override
  String get menuRename => '이름 변경';

  @override
  String get statsTitle => '통계';

  @override
  String statsRecentN(int count) {
    return '(최근 $count회)';
  }

  @override
  String get statsRecentResults => '최근 결과';

  @override
  String get statsFrequency => '항목별 빈도';

  @override
  String statsTimes(int count) {
    return '$count회';
  }

  @override
  String statsExpected(String pct) {
    return '기대$pct%';
  }

  @override
  String get starterSetsTitle => '스타터 세트';

  @override
  String get starterSetYesNo => '예 / 아니오';

  @override
  String get starterSetTruthDare => '진실 또는 도전';

  @override
  String get starterSetTeamSplit => '팀 나누기';

  @override
  String get starterSetNumbers => '숫자 1-10';

  @override
  String get starterSetFood => '음식';

  @override
  String get starterSetRandomOrder => '랜덤 순서';

  @override
  String get starterSetWinnerPick => '우승자 선택';

  @override
  String get starterCatDecision => '결정';

  @override
  String get starterCatFun => '재미';

  @override
  String get starterCatTeam => '팀';

  @override
  String get starterCatNumbers => '숫자';

  @override
  String get starterCatFood => '음식';

  @override
  String get starterCatGame => '게임';

  @override
  String get itemYes => '예';

  @override
  String get itemNo => '아니오';

  @override
  String get itemTruth => '진실';

  @override
  String get itemDare => '도전';

  @override
  String get itemTeamA => '팀 A';

  @override
  String get itemTeamB => '팀 B';

  @override
  String get itemPlayer1 => '플레이어 1';

  @override
  String get itemPlayer2 => '플레이어 2';

  @override
  String get itemPlayer3 => '플레이어 3';

  @override
  String get itemPlayer4 => '플레이어 4';

  @override
  String get itemCandidateA => '후보 A';

  @override
  String get itemCandidateB => '후보 B';

  @override
  String get itemCandidateC => '후보 C';

  @override
  String get itemPizza => '피자';

  @override
  String get itemBurger => '버거';

  @override
  String get itemPasta => '파스타';

  @override
  String get itemSalad => '샐러드';

  @override
  String get itemSushi => '초밥';

  @override
  String get paywallTitle => '프리미엄으로 업그레이드';

  @override
  String get paywallSubtitle => '모든 도구와 기능을 영구히 잠금 해제하세요.';

  @override
  String get paywallFree => '무료';

  @override
  String get paywallPremium => '프리미엄';

  @override
  String get paywallAds => '광고';

  @override
  String get paywallRouletteSets => '룰렛 세트';

  @override
  String get paywallUnlimited => '무제한';

  @override
  String get paywallRouletteRow => '룰렛 세트';

  @override
  String get paywallLadderRow => '사다리 참가자';

  @override
  String get paywallDiceRow => '주사위 종류';

  @override
  String get paywallNumberRow => '숫자 범위';

  @override
  String get paywallAdsRow => '광고';

  @override
  String get paywallFreeRoulette => '3개';

  @override
  String get paywallFreeLadder => '최대 6명';

  @override
  String get paywallFreeDice => 'D6 전용';

  @override
  String get paywallFreeNumber => '최대 9,999';

  @override
  String get paywallPremiumRoulette => '무제한';

  @override
  String get paywallPremiumLadder => '최대 12명';

  @override
  String get paywallPremiumDice => 'D4 – D20';

  @override
  String get paywallPremiumNumber => '최대 999,999,999';

  @override
  String get paywallOneTimePrice => '한 번의 구매';

  @override
  String get paywallForever => '영구히 사용';

  @override
  String get paywallPurchaseButton => '프리미엄 구매';

  @override
  String get paywallRestoreButton => '구매 복원';

  @override
  String get paywallPurchaseSuccess => '✅ 프리미엄 구매 성공!';

  @override
  String get paywallPurchaseFailed => '❌ 구매 실패';

  @override
  String get paywallRestoreSuccess => '✅ 구매가 복구되었습니다.';

  @override
  String get paywallNoRestorableItems => '❌ 구매 기록이 없습니다.';

  @override
  String get paywallNoPreviousPurchase => '이전에 구매한 항목이 없습니다.';

  @override
  String get paywallError => '오류 발생';

  @override
  String get paywallTryAgain => '다시 시도해주세요.';

  @override
  String get paywallMockNotice => '(Mock 구현: 실제 결제 아님)';

  @override
  String get paywallRouletteLimitTitle => '생성 제한 도달';

  @override
  String get paywallRouletteLimitContent =>
      '무료 사용자는 최대 3개의 룰렛 세트를 만들 수 있습니다.\n프리미엄으로 업그레이드하면 무제한으로 생성할 수 있습니다.';

  @override
  String get paywallUnlockButton => '프리미엄 잠금 해제';

  @override
  String get paywallDiceLockTitle => '주사위 잠금';

  @override
  String get paywallDiceLockContent =>
      'D4, D8, D10, D12, D20은 프리미엄에서 사용할 수 있어요.';

  @override
  String get paywallLadderLimitTitle => '참가자 제한 도달';

  @override
  String get paywallLadderLimitContent =>
      '무료 사용자는 최대 6명까지 추가할 수 있어요. 프리미엄으로 최대 12명까지 가능해요.';

  @override
  String get paywallNumberLimitTitle => '범위 제한 도달';

  @override
  String get paywallNumberLimitContent =>
      '무료 사용자는 최대 9,999까지 설정할 수 있어요. 프리미엄으로 최대 999,999,999까지 가능해요.';

  @override
  String get premiumStatusFree => '무료 버전';

  @override
  String get premiumStatusActive => '프리미엄 구독 중';

  @override
  String get premiumFeatureAds => '광고 제거';

  @override
  String get premiumFeatureSets => '룰렛 무제한';

  @override
  String get premiumFeaturePalettes => '전체 팔레트';

  @override
  String premiumPurchaseDate(String date) {
    return '구매: $date';
  }

  @override
  String get premiumMockNotice => '(Mock 구현: 실제 결제 아님)';

  @override
  String get premiumPurchaseButtonActive => '구매 완료';

  @override
  String get premiumPurchaseButtonInactive => '프리미엄 구매';

  @override
  String get premiumRestoreButton => '복구';

  @override
  String get premiumRestoreSuccess => '✅ 복구 성공!';

  @override
  String get premiumRestoreEmpty => '❌ 구매 기록 없음';

  @override
  String get settingsPremiumFreeTitle => '무료 플랜';

  @override
  String settingsPremiumFreeLimitRoulette(int count) {
    return '룰렛: 최대 $count개 세트';
  }

  @override
  String settingsPremiumFreeLimitLadder(int count) {
    return '사다리: 최대 $count명';
  }

  @override
  String get settingsPremiumFreeLimitDice => '주사위: D6만 사용';

  @override
  String settingsPremiumFreeLimitNumber(String limit) {
    return '숫자 뽑기: 최대 $limit';
  }

  @override
  String get settingsPremiumBenefitNoAds => '광고 없음';

  @override
  String get settingsPremiumBenefitUnlimitedSets => '무제한 세트';

  @override
  String get settingsPremiumBenefitAllDice => '모든 주사위';

  @override
  String get settingsPremiumBenefitExtRange => '확장 범위';

  @override
  String get settingsPremiumBenefitAllBg => '모든 배경';

  @override
  String get settingsPremiumUnlockAll => '모든 기능 잠금 해제';

  @override
  String get settingsPremiumRestore => '구매 복원';

  @override
  String get settingsPremiumProTitle => '프리미엄';

  @override
  String get settingsPremiumProBenefitAds => '광고 없는 경험';

  @override
  String get settingsPremiumProBenefitSets => '무제한 룰렛 세트';

  @override
  String get settingsPremiumProBenefitTools => '모든 도구 완전 해금';

  @override
  String get settingsPremiumProBenefitBg => '모든 배경 사용 가능';

  @override
  String get createManualTitle => '빈 룰렛으로 시작';

  @override
  String get createManualSubtitle => '항목을 직접 입력합니다';

  @override
  String get createTemplateSubtitleNew => '미리 만들어진 구성으로 시작합니다';

  @override
  String get atmosphereLabel => '배경';

  @override
  String get firstRunWelcomeTitle => '어서오세요!';

  @override
  String get firstRunWelcomeSubtitle => '스타터 세트를 바로 돌려보세요';

  @override
  String get firstRunSubtitle => '룰렛부터 사다리까지\n선택의 고민을 해결해드려요';

  @override
  String get firstRunCreateManual => '직접 만들기';

  @override
  String get firstRunViewMore => '스타터 세트 더 보기';

  @override
  String get firstRunSaveTitle => '이 룰렛을 저장할까요?';

  @override
  String get firstRunSaveMessage => '내 세트에 저장하면 언제든 다시 사용할 수 있어요.';

  @override
  String get firstRunSaveButton => '저장하기';

  @override
  String get firstRunSkipButton => '건너뛰기';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingSlide1Title => '결정이 어려울 땐?';

  @override
  String get onboardingSlide1Desc => '룰렛, 사다리, 주사위, 코인 — 하나로 해결.';

  @override
  String get onboardingSlide2Title => '사다리 게임도 여기서';

  @override
  String get onboardingSlide2Desc => '참가자 입력하고 바로 시작해요.';

  @override
  String get onboardingSlide3Title => '완전 무료로 시작';

  @override
  String get onboardingSlide3Desc => '핵심 기능은 모두 무료예요.';

  @override
  String get sectionQuickLaunch => '빠른 실행';

  @override
  String get quickLaunchSpin => '스핀';

  @override
  String lastResultWithDate(String result, String date) {
    return '마지막 결과: $result · $date';
  }

  @override
  String recentResult(String result) {
    return '최근: $result';
  }

  @override
  String get sectionRecommend => '이런 룰렛 어때요?';

  @override
  String get showMore => '더 보기';

  @override
  String get showLess => '접기';

  @override
  String get tabLadder => '사다리';

  @override
  String get ladderTitle => '사다리';

  @override
  String get ladderParticipants => '참가자';

  @override
  String get ladderResults => '결과 (선택사항)';

  @override
  String get ladderResultHint => '비워두면 1등, 2등... 자동 배정';

  @override
  String get ladderStart => '사다리 시작';

  @override
  String get ladderRetry => '다시 뽑기';

  @override
  String get ladderShare => '결과 공유';

  @override
  String get ladderAddParticipant => '+ 참가자 추가';

  @override
  String ladderCountBadge(int current, int max) {
    return '$current / $max';
  }

  @override
  String ladderPerson(int index) {
    return '참가자 $index';
  }

  @override
  String ladderResult(int index) {
    return '결과 $index';
  }

  @override
  String get ladderResultDefault1st => '1등';

  @override
  String get ladderResultDefault2nd => '2등';

  @override
  String get ladderResultDefault3rd => '3등';

  @override
  String ladderResultDefaultNth(int n) {
    return '$n등';
  }

  @override
  String get ladderMinParticipants => '최소 2명 이상 필요합니다';

  @override
  String get dateToday => '오늘';

  @override
  String get dateYesterday => '어제';

  @override
  String dateDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String shareResultText(String name, String result) {
    return '[$name]의 결과: $result\nSpin Wheel 앱으로 결정했어요 🎡';
  }

  @override
  String errorRouletteMaxLimit(int max) {
    return '룰렛은 최대 $max개까지 생성할 수 있습니다.';
  }

  @override
  String errorRouletteNotFound(String id) {
    return '룰렛을 찾을 수 없습니다: $id';
  }

  @override
  String editorErrorMinItems(int min) {
    return '최소 $min개 항목이 필요합니다.';
  }

  @override
  String get editorErrorNoName => '룰렛 이름을 입력해 주세요.';

  @override
  String editorErrorItemsRequired(int min) {
    return '항목을 최소 $min개 입력해 주세요.';
  }

  @override
  String get editorErrorEmptyItems => '비어있는 항목을 채워 주세요.';

  @override
  String get editorErrorNotFound => '룰렛을 찾을 수 없습니다.';

  @override
  String get itemNameHint => '항목 이름';

  @override
  String get itemNameRequired => '필수 입력';

  @override
  String get itemDeleteTooltip => '항목 삭제';

  @override
  String get itemColorPickerTitle => '색상 선택';

  @override
  String rouletteCopyPrefix(String name) {
    return '[복사] $name';
  }

  @override
  String get homeNewSetButton => '+ 새 세트';

  @override
  String homeItemCount(String category, int count) {
    return '$category · $count items';
  }

  @override
  String get coinFront => '앞';

  @override
  String get coinBack => '뒤';

  @override
  String get coinFlipButton => '🪙 뒤집기';

  @override
  String get toolsStatTotal => '총';

  @override
  String get numberProSnackbar => '더 큰 범위는 PRO에서 사용 가능해요';

  @override
  String get numberProSnackbarAction => 'PRO 보기';

  @override
  String get numberCardTitle => '랜덤 숫자';

  @override
  String get numberRangeHintPro => '최대 999,999,999';

  @override
  String get numberRangeHintFree => '최대 9,999 · 더 큰 범위는 PRO';

  @override
  String get diceGenerateButton => '🎲 생성';

  @override
  String get ladderMaxParticipantsPro => '🔒 최대 12명 (PRO)';
}
