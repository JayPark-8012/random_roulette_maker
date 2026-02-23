// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Random Roulette Maker';

  @override
  String get homeTitle => 'Random Tools';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get tabRoulette => 'Roulette';

  @override
  String get tabCoin => 'Coin';

  @override
  String get tabDice => 'Dice';

  @override
  String get tabNumber => 'Number';

  @override
  String get sectionMySets => 'My Roulette Sets';

  @override
  String get fabCreateNew => 'New Roulette';

  @override
  String get emptyTitle => 'No Roulettes Yet';

  @override
  String get emptySubtitle =>
      'Having trouble deciding?\nCreate your first roulette now!';

  @override
  String get emptyButton => 'Create First Roulette';

  @override
  String get createBlankTitle => 'Start Blank';

  @override
  String get createBlankSubtitle => 'Enter items yourself';

  @override
  String get createTemplateTitle => 'Starter Sets';

  @override
  String get createTemplateSubtitle => 'Start from a preset';

  @override
  String duplicated(String name) {
    return '\"$name\" duplicated.';
  }

  @override
  String get limitTitle => 'Roulette Limit';

  @override
  String limitContent(int count) {
    return 'Free plan allows up to $count roulettes.\nDelete existing ones or upgrade to premium.';
  }

  @override
  String get actionClose => 'Close';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionLeave => 'Leave';

  @override
  String get actionRename => 'Rename';

  @override
  String get premiumComingSoon => 'Premium features are coming soon.';

  @override
  String get premiumButton => 'Learn about Premium';

  @override
  String get editorTitleEdit => 'Edit Roulette';

  @override
  String get editorTitleNew => 'Create Roulette';

  @override
  String get deleteRouletteTooltip => 'Delete Roulette';

  @override
  String get addItemTooltip => 'Add Item';

  @override
  String get rouletteNameLabel => 'Roulette Name';

  @override
  String get rouletteNameHint => 'e.g. Today\'s Lunch';

  @override
  String get rouletteNameError => 'Please enter a name';

  @override
  String itemsHeader(int count) {
    return 'Items ($count)';
  }

  @override
  String get dragHint => 'Drag to reorder';

  @override
  String get previewLabel => 'Live Preview';

  @override
  String get emptyItemLabel => '(empty)';

  @override
  String moreItems(int count) {
    return '+ $count more';
  }

  @override
  String get exitTitle => 'Leave without Saving';

  @override
  String get exitContent => 'Changes won\'t be saved. Leave?';

  @override
  String get actionContinueEditing => 'Keep Editing';

  @override
  String get deleteRouletteTitle => 'Delete Roulette';

  @override
  String get deleteRouletteContent =>
      'Delete this roulette?\nHistory will also be deleted.';

  @override
  String cardDeleteContent(String name) {
    return 'Delete \"$name\"?\nHistory will also be deleted.';
  }

  @override
  String get renameTitle => 'Rename';

  @override
  String get playFallbackTitle => 'Roulette';

  @override
  String get notEnoughItems => 'Not enough items. Please add from the editor.';

  @override
  String get modeLottery => 'Lottery';

  @override
  String get modeRound => 'Round';

  @override
  String get modeCustom => 'Custom';

  @override
  String remainingItems(int count) {
    return 'Remaining: $count';
  }

  @override
  String roundStatus(int current, int total) {
    return 'Round $current / $total';
  }

  @override
  String get noRepeat => 'No Repeat';

  @override
  String get autoReset => 'Auto Reset';

  @override
  String get allPicked => 'All items drawn!';

  @override
  String get actionReset => 'Reset';

  @override
  String get spinLabel => 'SPIN';

  @override
  String get spinningLabel => 'Spinning...';

  @override
  String get historyTitle => 'Recent Results';

  @override
  String get noHistory => 'No records yet.';

  @override
  String get shareTitle => 'Share';

  @override
  String get shareTextTitle => 'Share as Text';

  @override
  String get shareTextSubtitle => 'Share roulette name and result';

  @override
  String get shareImageTitle => 'Share as Image';

  @override
  String get shareImageSubtitle => 'Share roulette screen as image';

  @override
  String get shareImageFailed => 'Failed to share image.';

  @override
  String get resultLabel => 'Result';

  @override
  String get actionReSpin => 'Spin Again';

  @override
  String get actionCopy => 'Copy';

  @override
  String get copiedMessage => 'Result copied to clipboard.';

  @override
  String get statsTooltip => 'Stats';

  @override
  String get historyTooltip => 'History';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get sectionTheme => 'Theme';

  @override
  String get screenModeLabel => 'Display Mode';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get colorPaletteLabel => 'Color Palette';

  @override
  String get premiumThemeTitle => 'Premium Theme';

  @override
  String get premiumThemeContent =>
      'This theme is a premium feature.\nUpgrade to use it.';

  @override
  String get sectionFeedback => 'Feedback';

  @override
  String get soundLabel => 'Sound';

  @override
  String get soundSubtitle => 'Spin and result sound effects';

  @override
  String get soundPackLabel => 'Sound Pack';

  @override
  String get packBasic => 'Basic';

  @override
  String get packClicky => 'Clicky';

  @override
  String get packParty => 'Party';

  @override
  String get vibrationLabel => 'Vibration';

  @override
  String get vibrationSubtitle => 'Vibrate on result';

  @override
  String get hapticOff => 'Off';

  @override
  String get hapticLight => 'Light';

  @override
  String get hapticStrong => 'Strong';

  @override
  String get sectionSpinTime => 'Spin Duration';

  @override
  String get spinShort => 'Short (2s)';

  @override
  String get spinNormal => 'Normal (4.5s)';

  @override
  String get spinLong => 'Long (7s)';

  @override
  String get sectionLanguage => 'Language';

  @override
  String get langSystem => 'System (Recommended)';

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
  String get sectionAppInfo => 'App Info';

  @override
  String get versionLabel => 'Version';

  @override
  String get openSourceLabel => 'Open Source Licenses';

  @override
  String get contactLabel => 'Contact Us';

  @override
  String get comingSoon => 'Coming soon.';

  @override
  String get coinFlipTitle => 'Coin Flip';

  @override
  String get coinHeads => 'H';

  @override
  String get coinTails => 'T';

  @override
  String get actionFlip => 'Flip';

  @override
  String get recent10 => 'Recent 10';

  @override
  String get diceTitle => 'Dice';

  @override
  String rollDice(int type) {
    return 'Roll D$type';
  }

  @override
  String get randomNumberTitle => 'Random Number';

  @override
  String get minLabel => 'Min';

  @override
  String get maxLabel => 'Max';

  @override
  String get actionGenerate => 'Generate';

  @override
  String get recent20 => 'Recent 20';

  @override
  String get minMaxError => 'Min must be less than max.';

  @override
  String get splashTitle => 'Random Roulette Maker';

  @override
  String get splashSubtitle => 'Create your own roulette';

  @override
  String get templatesTitle => 'Starter Sets';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count items';
  }

  @override
  String get useTemplate => 'Use This Starter Set';

  @override
  String freePlanLimit(int count) {
    return 'Free plan allows up to $count roulettes';
  }

  @override
  String itemCount(int count) {
    return '$count items';
  }

  @override
  String get menuEdit => 'Edit';

  @override
  String get menuDuplicate => 'Duplicate';

  @override
  String get menuRename => 'Rename';

  @override
  String get statsTitle => 'Stats';

  @override
  String statsRecentN(int count) {
    return '($count spins)';
  }

  @override
  String get statsRecentResults => 'Recent Results';

  @override
  String get statsFrequency => 'Frequency';

  @override
  String statsTimes(int count) {
    return '${count}x';
  }

  @override
  String statsExpected(String pct) {
    return 'E:$pct%';
  }

  @override
  String get starterSetsTitle => 'Starter Sets';

  @override
  String get starterSetYesNo => 'Yes / No';

  @override
  String get starterSetTruthDare => 'Truth or Dare';

  @override
  String get starterSetTeamSplit => 'Team Split';

  @override
  String get starterSetNumbers => 'Numbers 1-10';

  @override
  String get starterSetFood => 'Food';

  @override
  String get starterSetRandomOrder => 'Random Order';

  @override
  String get starterSetWinnerPick => 'Pick a Winner';

  @override
  String get starterCatDecision => 'Decision';

  @override
  String get starterCatFun => 'Fun';

  @override
  String get starterCatTeam => 'Team';

  @override
  String get starterCatNumbers => 'Numbers';

  @override
  String get starterCatFood => 'Food';

  @override
  String get starterCatGame => 'Game';

  @override
  String get itemYes => 'Yes';

  @override
  String get itemNo => 'No';

  @override
  String get itemTruth => 'Truth';

  @override
  String get itemDare => 'Dare';

  @override
  String get itemTeamA => 'Team A';

  @override
  String get itemTeamB => 'Team B';

  @override
  String get itemPlayer1 => 'Player 1';

  @override
  String get itemPlayer2 => 'Player 2';

  @override
  String get itemPlayer3 => 'Player 3';

  @override
  String get itemPlayer4 => 'Player 4';

  @override
  String get itemCandidateA => 'Candidate A';

  @override
  String get itemCandidateB => 'Candidate B';

  @override
  String get itemCandidateC => 'Candidate C';

  @override
  String get itemPizza => 'Pizza';

  @override
  String get itemBurger => 'Burger';

  @override
  String get itemPasta => 'Pasta';

  @override
  String get itemSalad => 'Salad';

  @override
  String get itemSushi => 'Sushi';
}
