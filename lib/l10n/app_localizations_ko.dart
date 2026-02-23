// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '랜덤 룰렛 메이커';

  @override
  String get homeTitle => '랜덤 툴';

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
  String get splashTitle => '랜덤 룰렛 메이커';

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
}
