// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Spin Wheel – Random Roulette';

  @override
  String get homeTitle => 'Spin Wheel – Random Roulette';

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
  String get wheelThemeLabel => 'Wheel Theme';

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
  String get diceD4Name => 'Tetrahedron';

  @override
  String get diceD6Name => 'Cube';

  @override
  String get diceD8Name => 'Octahedron';

  @override
  String get diceD10Name => 'Decahedron';

  @override
  String get diceD12Name => 'Dodecahedron';

  @override
  String get diceD20Name => 'Icosahedron';

  @override
  String diceRange(int max) {
    return '1 ~ $max';
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
  String get splashTitle => 'Spin Wheel – Random Roulette';

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

  @override
  String get paywallTitle => 'Upgrade to Premium';

  @override
  String get paywallSubtitle => 'Unlock all tools and features forever.';

  @override
  String get paywallFree => 'Free';

  @override
  String get paywallPremium => 'Premium';

  @override
  String get paywallAds => 'Ads';

  @override
  String get paywallRouletteSets => 'Roulette Sets';

  @override
  String get paywallUnlimited => 'Unlimited';

  @override
  String get paywallRouletteRow => 'Roulette Sets';

  @override
  String get paywallLadderRow => 'Ladder Participants';

  @override
  String get paywallDiceRow => 'Dice Types';

  @override
  String get paywallNumberRow => 'Number Range';

  @override
  String get paywallAdsRow => 'Ads';

  @override
  String get paywallFreeRoulette => '3';

  @override
  String get paywallFreeLadder => 'Up to 6';

  @override
  String get paywallFreeDice => 'D6 only';

  @override
  String get paywallFreeNumber => 'Up to 9,999';

  @override
  String get paywallPremiumRoulette => 'Unlimited';

  @override
  String get paywallPremiumLadder => 'Up to 12';

  @override
  String get paywallPremiumDice => 'D4 – D20';

  @override
  String get paywallPremiumNumber => 'Up to 999,999,999';

  @override
  String get paywallOneTimePrice => 'One-time purchase';

  @override
  String get paywallForever => 'Forever';

  @override
  String get paywallPurchaseButton => 'Purchase Premium';

  @override
  String get paywallRestoreButton => 'Restore Purchase';

  @override
  String get paywallPurchaseSuccess => '✅ Premium purchase successful!';

  @override
  String get paywallPurchaseFailed => '❌ Purchase failed';

  @override
  String get paywallRestoreSuccess => '✅ Purchase restored successfully.';

  @override
  String get paywallNoRestorableItems => '❌ No purchase history found.';

  @override
  String get paywallNoPreviousPurchase => 'No previous purchases found.';

  @override
  String get paywallError => 'Error occurred';

  @override
  String get paywallTryAgain => 'Please try again.';

  @override
  String get paywallMockNotice => '(Mock implementation: Not real purchase)';

  @override
  String get paywallRouletteLimitTitle => 'Create Limit Reached';

  @override
  String get paywallRouletteLimitContent =>
      'Free users can create up to 3 roulette sets.\nUpgrade to Premium for unlimited sets.';

  @override
  String get paywallUnlockButton => 'Unlock Premium';

  @override
  String get paywallDiceLockTitle => 'Dice Type Locked';

  @override
  String get paywallDiceLockContent =>
      'D4, D8, D10, D12, D20 are available in Premium.';

  @override
  String get paywallLadderLimitTitle => 'Participant Limit Reached';

  @override
  String get paywallLadderLimitContent =>
      'Free users can add up to 6 participants. Upgrade to add up to 12.';

  @override
  String get paywallNumberLimitTitle => 'Range Limit Reached';

  @override
  String get paywallNumberLimitContent =>
      'Free users can set a max of 9,999. Upgrade for up to 999,999,999.';

  @override
  String get premiumStatusFree => 'Free Version';

  @override
  String get premiumStatusActive => 'Premium Active';

  @override
  String get premiumFeatureAds => 'No Ads';

  @override
  String get premiumFeatureSets => 'Unlimited Sets';

  @override
  String get premiumFeaturePalettes => 'All Palettes';

  @override
  String premiumPurchaseDate(String date) {
    return 'Purchased: $date';
  }

  @override
  String get premiumMockNotice => '(Mock implementation: Not real purchase)';

  @override
  String get premiumPurchaseButtonActive => 'Purchased';

  @override
  String get premiumPurchaseButtonInactive => 'Get Premium';

  @override
  String get premiumRestoreButton => 'Restore';

  @override
  String get premiumRestoreSuccess => '✅ Restore Success!';

  @override
  String get premiumRestoreEmpty => '❌ No History';

  @override
  String get settingsPremiumFreeTitle => 'FREE PLAN';

  @override
  String settingsPremiumFreeLimitRoulette(int count) {
    return 'Roulette: max $count sets';
  }

  @override
  String settingsPremiumFreeLimitLadder(int count) {
    return 'Ladder: max $count players';
  }

  @override
  String get settingsPremiumFreeLimitDice => 'Dice: D6 only';

  @override
  String settingsPremiumFreeLimitNumber(String limit) {
    return 'Number: max $limit';
  }

  @override
  String get settingsPremiumBenefitNoAds => 'No Ads';

  @override
  String get settingsPremiumBenefitUnlimitedSets => 'Unlimited Sets';

  @override
  String get settingsPremiumBenefitAllDice => 'All Dice';

  @override
  String get settingsPremiumBenefitExtRange => 'Extended Range';

  @override
  String get settingsPremiumBenefitAllBg => 'All Backgrounds';

  @override
  String get settingsPremiumUnlockAll => 'Unlock All Features';

  @override
  String get settingsPremiumRestore => 'Restore Purchase';

  @override
  String get settingsPremiumProTitle => 'PREMIUM';

  @override
  String get settingsPremiumProBenefitAds => 'Ad-free experience';

  @override
  String get settingsPremiumProBenefitSets => 'Unlimited roulette sets';

  @override
  String get settingsPremiumProBenefitTools => 'All tools fully unlocked';

  @override
  String get settingsPremiumProBenefitBg => 'All backgrounds available';

  @override
  String get createManualTitle => 'Start Blank';

  @override
  String get createManualSubtitle => 'Enter items manually';

  @override
  String get createTemplateSubtitleNew => 'Start with a template';

  @override
  String get atmosphereLabel => 'Background';

  @override
  String get firstRunWelcomeTitle => 'Welcome!';

  @override
  String get firstRunWelcomeSubtitle => 'Try spinning a starter set right now';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => 'Create Your Own';

  @override
  String get firstRunViewMore => 'Browse All Starter Sets';

  @override
  String get firstRunSaveTitle => 'Save this roulette?';

  @override
  String get firstRunSaveMessage =>
      'Save it to My Sets so you can use it anytime.';

  @override
  String get firstRunSaveButton => 'Save';

  @override
  String get firstRunSkipButton => 'Skip';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingSlide1Title => 'Can\'t decide?';

  @override
  String get onboardingSlide1Desc =>
      'Roulette, Ladder, Dice, Coin — all in one place.';

  @override
  String get onboardingSlide2Title => 'Ladder Game Too';

  @override
  String get onboardingSlide2Desc => 'Enter participants and start right away.';

  @override
  String get onboardingSlide3Title => 'Start for Free';

  @override
  String get onboardingSlide3Desc => 'Core features are completely free.';

  @override
  String get sectionQuickLaunch => 'Quick Launch';

  @override
  String get quickLaunchSpin => 'Spin';

  @override
  String lastResultWithDate(String result, String date) {
    return 'Last: $result · $date';
  }

  @override
  String recentResult(String result) {
    return 'Last: $result';
  }

  @override
  String get sectionRecommend => 'Try These Roulettes';

  @override
  String get showMore => 'Show More';

  @override
  String get showLess => 'Show Less';

  @override
  String get tabLadder => 'Ladder';

  @override
  String get ladderTitle => 'Ladder';

  @override
  String get ladderParticipants => 'Participants';

  @override
  String get ladderResults => 'Results (optional)';

  @override
  String get ladderResultHint => 'Leave blank for auto 1st, 2nd...';

  @override
  String get ladderStart => 'Start Ladder';

  @override
  String get ladderRetry => 'Retry';

  @override
  String get ladderShare => 'Share Results';

  @override
  String get ladderAddParticipant => '+ Add Participant';

  @override
  String ladderCountBadge(int current, int max) {
    return '$current / $max';
  }

  @override
  String ladderPerson(int index) {
    return 'Person $index';
  }

  @override
  String ladderResult(int index) {
    return 'Result $index';
  }

  @override
  String get ladderResultDefault1st => '1st';

  @override
  String get ladderResultDefault2nd => '2nd';

  @override
  String get ladderResultDefault3rd => '3rd';

  @override
  String ladderResultDefaultNth(int n) {
    return '${n}th';
  }

  @override
  String get ladderMinParticipants => 'At least 2 participants required';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String dateDaysAgo(int days) {
    return '$days days ago';
  }

  @override
  String shareResultText(String name, String result) {
    return '[$name] Result: $result\nDecided with Spin Wheel 🎡';
  }

  @override
  String errorRouletteMaxLimit(int max) {
    return 'You can create up to $max roulettes.';
  }

  @override
  String errorRouletteNotFound(String id) {
    return 'Roulette not found: $id';
  }

  @override
  String editorErrorMinItems(int min) {
    return 'At least $min items required.';
  }

  @override
  String get editorErrorNoName => 'Please enter a roulette name.';

  @override
  String editorErrorItemsRequired(int min) {
    return 'Please enter at least $min items.';
  }

  @override
  String get editorErrorEmptyItems => 'Please fill in empty items.';

  @override
  String get editorErrorNotFound => 'Roulette not found.';

  @override
  String get itemNameHint => 'Item name';

  @override
  String get itemNameRequired => 'Required';

  @override
  String get itemDeleteTooltip => 'Delete item';

  @override
  String get itemColorPickerTitle => 'Choose Color';

  @override
  String rouletteCopyPrefix(String name) {
    return '[Copy] $name';
  }

  @override
  String get homeNewSetButton => '+ New Set';

  @override
  String homeItemCount(String category, int count) {
    return '$category · $count items';
  }

  @override
  String get coinFront => 'H';

  @override
  String get coinBack => 'T';

  @override
  String get coinFlipButton => '🪙 Flip';

  @override
  String get toolsStatTotal => 'Total';

  @override
  String get numberProSnackbar => 'Larger ranges available with PRO';

  @override
  String get numberProSnackbarAction => 'View PRO';

  @override
  String get numberCardTitle => 'Random Number';

  @override
  String get numberRangeHintPro => 'Max 999,999,999';

  @override
  String get numberRangeHintFree => 'Max 9,999 · PRO for bigger';

  @override
  String get diceGenerateButton => '🎲 Generate';

  @override
  String get ladderMaxParticipantsPro => '🔒 Max 12 (PRO)';
}
