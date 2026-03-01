import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Spin Wheel – Random Roulette'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Spin Wheel – Random Roulette'**
  String get homeTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @tabRoulette.
  ///
  /// In en, this message translates to:
  /// **'Roulette'**
  String get tabRoulette;

  /// No description provided for @tabCoin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get tabCoin;

  /// No description provided for @tabDice.
  ///
  /// In en, this message translates to:
  /// **'Dice'**
  String get tabDice;

  /// No description provided for @tabNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get tabNumber;

  /// No description provided for @sectionMySets.
  ///
  /// In en, this message translates to:
  /// **'My Roulette Sets'**
  String get sectionMySets;

  /// No description provided for @fabCreateNew.
  ///
  /// In en, this message translates to:
  /// **'New Roulette'**
  String get fabCreateNew;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Roulettes Yet'**
  String get emptyTitle;

  /// No description provided for @emptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Having trouble deciding?\nCreate your first roulette now!'**
  String get emptySubtitle;

  /// No description provided for @emptyButton.
  ///
  /// In en, this message translates to:
  /// **'Create First Roulette'**
  String get emptyButton;

  /// No description provided for @createBlankTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Blank'**
  String get createBlankTitle;

  /// No description provided for @createBlankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter items yourself'**
  String get createBlankSubtitle;

  /// No description provided for @createTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Starter Sets'**
  String get createTemplateTitle;

  /// No description provided for @createTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start from a preset'**
  String get createTemplateSubtitle;

  /// No description provided for @duplicated.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" duplicated.'**
  String duplicated(String name);

  /// No description provided for @limitTitle.
  ///
  /// In en, this message translates to:
  /// **'Roulette Limit'**
  String get limitTitle;

  /// No description provided for @limitContent.
  ///
  /// In en, this message translates to:
  /// **'Free plan allows up to {count} roulettes.\nDelete existing ones or upgrade to premium.'**
  String limitContent(int count);

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionConfirm;

  /// No description provided for @actionLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get actionLeave;

  /// No description provided for @actionRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get actionRename;

  /// No description provided for @premiumComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Premium features are coming soon.'**
  String get premiumComingSoon;

  /// No description provided for @premiumButton.
  ///
  /// In en, this message translates to:
  /// **'Learn about Premium'**
  String get premiumButton;

  /// No description provided for @editorTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Roulette'**
  String get editorTitleEdit;

  /// No description provided for @editorTitleNew.
  ///
  /// In en, this message translates to:
  /// **'Create Roulette'**
  String get editorTitleNew;

  /// No description provided for @deleteRouletteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete Roulette'**
  String get deleteRouletteTooltip;

  /// No description provided for @addItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItemTooltip;

  /// No description provided for @rouletteNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Roulette Name'**
  String get rouletteNameLabel;

  /// No description provided for @rouletteNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Today\'s Lunch'**
  String get rouletteNameHint;

  /// No description provided for @rouletteNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get rouletteNameError;

  /// No description provided for @itemsHeader.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String itemsHeader(int count);

  /// No description provided for @dragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragHint;

  /// No description provided for @previewLabel.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get previewLabel;

  /// No description provided for @emptyItemLabel.
  ///
  /// In en, this message translates to:
  /// **'(empty)'**
  String get emptyItemLabel;

  /// No description provided for @moreItems.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more'**
  String moreItems(int count);

  /// No description provided for @exitTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave without Saving'**
  String get exitTitle;

  /// No description provided for @exitContent.
  ///
  /// In en, this message translates to:
  /// **'Changes won\'t be saved. Leave?'**
  String get exitContent;

  /// No description provided for @actionContinueEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get actionContinueEditing;

  /// No description provided for @deleteRouletteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Roulette'**
  String get deleteRouletteTitle;

  /// No description provided for @deleteRouletteContent.
  ///
  /// In en, this message translates to:
  /// **'Delete this roulette?\nHistory will also be deleted.'**
  String get deleteRouletteContent;

  /// No description provided for @cardDeleteContent.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?\nHistory will also be deleted.'**
  String cardDeleteContent(String name);

  /// No description provided for @renameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameTitle;

  /// No description provided for @playFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Roulette'**
  String get playFallbackTitle;

  /// No description provided for @notEnoughItems.
  ///
  /// In en, this message translates to:
  /// **'Not enough items. Please add from the editor.'**
  String get notEnoughItems;

  /// No description provided for @modeLottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery'**
  String get modeLottery;

  /// No description provided for @modeRound.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get modeRound;

  /// No description provided for @modeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get modeCustom;

  /// No description provided for @remainingItems.
  ///
  /// In en, this message translates to:
  /// **'Remaining: {count}'**
  String remainingItems(int count);

  /// No description provided for @roundStatus.
  ///
  /// In en, this message translates to:
  /// **'Round {current} / {total}'**
  String roundStatus(int current, int total);

  /// No description provided for @noRepeat.
  ///
  /// In en, this message translates to:
  /// **'No Repeat'**
  String get noRepeat;

  /// No description provided for @autoReset.
  ///
  /// In en, this message translates to:
  /// **'Auto Reset'**
  String get autoReset;

  /// No description provided for @allPicked.
  ///
  /// In en, this message translates to:
  /// **'All items drawn!'**
  String get allPicked;

  /// No description provided for @actionReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// No description provided for @spinLabel.
  ///
  /// In en, this message translates to:
  /// **'SPIN'**
  String get spinLabel;

  /// No description provided for @spinningLabel.
  ///
  /// In en, this message translates to:
  /// **'Spinning...'**
  String get spinningLabel;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Results'**
  String get historyTitle;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No records yet.'**
  String get noHistory;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTitle;

  /// No description provided for @shareTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Share as Text'**
  String get shareTextTitle;

  /// No description provided for @shareTextSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share roulette name and result'**
  String get shareTextSubtitle;

  /// No description provided for @shareImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Share as Image'**
  String get shareImageTitle;

  /// No description provided for @shareImageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share roulette screen as image'**
  String get shareImageSubtitle;

  /// No description provided for @shareImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to share image.'**
  String get shareImageFailed;

  /// No description provided for @resultLabel.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultLabel;

  /// No description provided for @actionReSpin.
  ///
  /// In en, this message translates to:
  /// **'Spin Again'**
  String get actionReSpin;

  /// No description provided for @actionCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// No description provided for @copiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Result copied to clipboard.'**
  String get copiedMessage;

  /// No description provided for @statsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTooltip;

  /// No description provided for @historyTooltip.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTooltip;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get sectionTheme;

  /// No description provided for @screenModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get screenModeLabel;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @colorPaletteLabel.
  ///
  /// In en, this message translates to:
  /// **'Color Palette'**
  String get colorPaletteLabel;

  /// No description provided for @wheelThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Wheel Theme'**
  String get wheelThemeLabel;

  /// No description provided for @premiumThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Theme'**
  String get premiumThemeTitle;

  /// No description provided for @premiumThemeContent.
  ///
  /// In en, this message translates to:
  /// **'This theme is a premium feature.\nUpgrade to use it.'**
  String get premiumThemeContent;

  /// No description provided for @sectionFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get sectionFeedback;

  /// No description provided for @soundLabel.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get soundLabel;

  /// No description provided for @soundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Spin and result sound effects'**
  String get soundSubtitle;

  /// No description provided for @soundPackLabel.
  ///
  /// In en, this message translates to:
  /// **'Sound Pack'**
  String get soundPackLabel;

  /// No description provided for @packBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get packBasic;

  /// No description provided for @packClicky.
  ///
  /// In en, this message translates to:
  /// **'Clicky'**
  String get packClicky;

  /// No description provided for @packParty.
  ///
  /// In en, this message translates to:
  /// **'Party'**
  String get packParty;

  /// No description provided for @vibrationLabel.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibrationLabel;

  /// No description provided for @vibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibrate on result'**
  String get vibrationSubtitle;

  /// No description provided for @hapticOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get hapticOff;

  /// No description provided for @hapticLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get hapticLight;

  /// No description provided for @hapticStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get hapticStrong;

  /// No description provided for @sectionSpinTime.
  ///
  /// In en, this message translates to:
  /// **'Spin Duration'**
  String get sectionSpinTime;

  /// No description provided for @spinShort.
  ///
  /// In en, this message translates to:
  /// **'Short (2s)'**
  String get spinShort;

  /// No description provided for @spinNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal (4.5s)'**
  String get spinNormal;

  /// No description provided for @spinLong.
  ///
  /// In en, this message translates to:
  /// **'Long (7s)'**
  String get spinLong;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get sectionLanguage;

  /// No description provided for @langSystem.
  ///
  /// In en, this message translates to:
  /// **'System (Recommended)'**
  String get langSystem;

  /// No description provided for @langEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEn;

  /// No description provided for @langKo.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get langKo;

  /// No description provided for @langEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get langEs;

  /// No description provided for @langPtBr.
  ///
  /// In en, this message translates to:
  /// **'Português (Brasil)'**
  String get langPtBr;

  /// No description provided for @langJa.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get langJa;

  /// No description provided for @langZhHans.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get langZhHans;

  /// No description provided for @sectionAppInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get sectionAppInfo;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @openSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLabel;

  /// No description provided for @contactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactLabel;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon.'**
  String get comingSoon;

  /// No description provided for @coinFlipTitle.
  ///
  /// In en, this message translates to:
  /// **'Coin Flip'**
  String get coinFlipTitle;

  /// No description provided for @coinHeads.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get coinHeads;

  /// No description provided for @coinTails.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get coinTails;

  /// No description provided for @actionFlip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get actionFlip;

  /// No description provided for @recent10.
  ///
  /// In en, this message translates to:
  /// **'Recent 10'**
  String get recent10;

  /// No description provided for @diceTitle.
  ///
  /// In en, this message translates to:
  /// **'Dice'**
  String get diceTitle;

  /// No description provided for @rollDice.
  ///
  /// In en, this message translates to:
  /// **'Roll D{type}'**
  String rollDice(int type);

  /// No description provided for @diceD4Name.
  ///
  /// In en, this message translates to:
  /// **'Tetrahedron'**
  String get diceD4Name;

  /// No description provided for @diceD6Name.
  ///
  /// In en, this message translates to:
  /// **'Cube'**
  String get diceD6Name;

  /// No description provided for @diceD8Name.
  ///
  /// In en, this message translates to:
  /// **'Octahedron'**
  String get diceD8Name;

  /// No description provided for @diceD10Name.
  ///
  /// In en, this message translates to:
  /// **'Decahedron'**
  String get diceD10Name;

  /// No description provided for @diceD12Name.
  ///
  /// In en, this message translates to:
  /// **'Dodecahedron'**
  String get diceD12Name;

  /// No description provided for @diceD20Name.
  ///
  /// In en, this message translates to:
  /// **'Icosahedron'**
  String get diceD20Name;

  /// No description provided for @diceRange.
  ///
  /// In en, this message translates to:
  /// **'1 ~ {max}'**
  String diceRange(int max);

  /// No description provided for @randomNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Random Number'**
  String get randomNumberTitle;

  /// No description provided for @minLabel.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minLabel;

  /// No description provided for @maxLabel.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxLabel;

  /// No description provided for @actionGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get actionGenerate;

  /// No description provided for @recent20.
  ///
  /// In en, this message translates to:
  /// **'Recent 20'**
  String get recent20;

  /// No description provided for @minMaxError.
  ///
  /// In en, this message translates to:
  /// **'Min must be less than max.'**
  String get minMaxError;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Spin Wheel – Random Roulette'**
  String get splashTitle;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your own roulette'**
  String get splashSubtitle;

  /// No description provided for @templatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Starter Sets'**
  String get templatesTitle;

  /// No description provided for @templateItemsInfo.
  ///
  /// In en, this message translates to:
  /// **'{category} · {count} items'**
  String templateItemsInfo(String category, int count);

  /// No description provided for @useTemplate.
  ///
  /// In en, this message translates to:
  /// **'Use This Starter Set'**
  String get useTemplate;

  /// No description provided for @freePlanLimit.
  ///
  /// In en, this message translates to:
  /// **'Free plan allows up to {count} roulettes'**
  String freePlanLimit(int count);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String itemCount(int count);

  /// No description provided for @menuEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get menuEdit;

  /// No description provided for @menuDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get menuDuplicate;

  /// No description provided for @menuRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get menuRename;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// No description provided for @statsRecentN.
  ///
  /// In en, this message translates to:
  /// **'({count} spins)'**
  String statsRecentN(int count);

  /// No description provided for @statsRecentResults.
  ///
  /// In en, this message translates to:
  /// **'Recent Results'**
  String get statsRecentResults;

  /// No description provided for @statsFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get statsFrequency;

  /// No description provided for @statsTimes.
  ///
  /// In en, this message translates to:
  /// **'{count}x'**
  String statsTimes(int count);

  /// No description provided for @statsExpected.
  ///
  /// In en, this message translates to:
  /// **'E:{pct}%'**
  String statsExpected(String pct);

  /// No description provided for @starterSetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Starter Sets'**
  String get starterSetsTitle;

  /// No description provided for @starterSetYesNo.
  ///
  /// In en, this message translates to:
  /// **'Yes / No'**
  String get starterSetYesNo;

  /// No description provided for @starterSetTruthDare.
  ///
  /// In en, this message translates to:
  /// **'Truth or Dare'**
  String get starterSetTruthDare;

  /// No description provided for @starterSetTeamSplit.
  ///
  /// In en, this message translates to:
  /// **'Team Split'**
  String get starterSetTeamSplit;

  /// No description provided for @starterSetNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers 1-10'**
  String get starterSetNumbers;

  /// No description provided for @starterSetFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get starterSetFood;

  /// No description provided for @starterSetRandomOrder.
  ///
  /// In en, this message translates to:
  /// **'Random Order'**
  String get starterSetRandomOrder;

  /// No description provided for @starterSetWinnerPick.
  ///
  /// In en, this message translates to:
  /// **'Pick a Winner'**
  String get starterSetWinnerPick;

  /// No description provided for @starterCatDecision.
  ///
  /// In en, this message translates to:
  /// **'Decision'**
  String get starterCatDecision;

  /// No description provided for @starterCatFun.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get starterCatFun;

  /// No description provided for @starterCatTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get starterCatTeam;

  /// No description provided for @starterCatNumbers.
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get starterCatNumbers;

  /// No description provided for @starterCatFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get starterCatFood;

  /// No description provided for @starterCatGame.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get starterCatGame;

  /// No description provided for @itemYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get itemYes;

  /// No description provided for @itemNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get itemNo;

  /// No description provided for @itemTruth.
  ///
  /// In en, this message translates to:
  /// **'Truth'**
  String get itemTruth;

  /// No description provided for @itemDare.
  ///
  /// In en, this message translates to:
  /// **'Dare'**
  String get itemDare;

  /// No description provided for @itemTeamA.
  ///
  /// In en, this message translates to:
  /// **'Team A'**
  String get itemTeamA;

  /// No description provided for @itemTeamB.
  ///
  /// In en, this message translates to:
  /// **'Team B'**
  String get itemTeamB;

  /// No description provided for @itemPlayer1.
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get itemPlayer1;

  /// No description provided for @itemPlayer2.
  ///
  /// In en, this message translates to:
  /// **'Player 2'**
  String get itemPlayer2;

  /// No description provided for @itemPlayer3.
  ///
  /// In en, this message translates to:
  /// **'Player 3'**
  String get itemPlayer3;

  /// No description provided for @itemPlayer4.
  ///
  /// In en, this message translates to:
  /// **'Player 4'**
  String get itemPlayer4;

  /// No description provided for @itemCandidateA.
  ///
  /// In en, this message translates to:
  /// **'Candidate A'**
  String get itemCandidateA;

  /// No description provided for @itemCandidateB.
  ///
  /// In en, this message translates to:
  /// **'Candidate B'**
  String get itemCandidateB;

  /// No description provided for @itemCandidateC.
  ///
  /// In en, this message translates to:
  /// **'Candidate C'**
  String get itemCandidateC;

  /// No description provided for @itemPizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get itemPizza;

  /// No description provided for @itemBurger.
  ///
  /// In en, this message translates to:
  /// **'Burger'**
  String get itemBurger;

  /// No description provided for @itemPasta.
  ///
  /// In en, this message translates to:
  /// **'Pasta'**
  String get itemPasta;

  /// No description provided for @itemSalad.
  ///
  /// In en, this message translates to:
  /// **'Salad'**
  String get itemSalad;

  /// No description provided for @itemSushi.
  ///
  /// In en, this message translates to:
  /// **'Sushi'**
  String get itemSushi;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get paywallTitle;

  /// No description provided for @paywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock all tools and features forever.'**
  String get paywallSubtitle;

  /// No description provided for @paywallFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get paywallFree;

  /// No description provided for @paywallPremium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get paywallPremium;

  /// No description provided for @paywallAds.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get paywallAds;

  /// No description provided for @paywallRouletteSets.
  ///
  /// In en, this message translates to:
  /// **'Roulette Sets'**
  String get paywallRouletteSets;

  /// No description provided for @paywallUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get paywallUnlimited;

  /// No description provided for @paywallRouletteRow.
  ///
  /// In en, this message translates to:
  /// **'Roulette Sets'**
  String get paywallRouletteRow;

  /// No description provided for @paywallLadderRow.
  ///
  /// In en, this message translates to:
  /// **'Ladder Participants'**
  String get paywallLadderRow;

  /// No description provided for @paywallDiceRow.
  ///
  /// In en, this message translates to:
  /// **'Dice Types'**
  String get paywallDiceRow;

  /// No description provided for @paywallNumberRow.
  ///
  /// In en, this message translates to:
  /// **'Number Range'**
  String get paywallNumberRow;

  /// No description provided for @paywallAdsRow.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get paywallAdsRow;

  /// No description provided for @paywallFreeRoulette.
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get paywallFreeRoulette;

  /// No description provided for @paywallFreeLadder.
  ///
  /// In en, this message translates to:
  /// **'Up to 6'**
  String get paywallFreeLadder;

  /// No description provided for @paywallFreeDice.
  ///
  /// In en, this message translates to:
  /// **'D6 only'**
  String get paywallFreeDice;

  /// No description provided for @paywallFreeNumber.
  ///
  /// In en, this message translates to:
  /// **'Up to 9,999'**
  String get paywallFreeNumber;

  /// No description provided for @paywallPremiumRoulette.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get paywallPremiumRoulette;

  /// No description provided for @paywallPremiumLadder.
  ///
  /// In en, this message translates to:
  /// **'Up to 12'**
  String get paywallPremiumLadder;

  /// No description provided for @paywallPremiumDice.
  ///
  /// In en, this message translates to:
  /// **'D4 – D20'**
  String get paywallPremiumDice;

  /// No description provided for @paywallPremiumNumber.
  ///
  /// In en, this message translates to:
  /// **'Up to 999,999,999'**
  String get paywallPremiumNumber;

  /// No description provided for @paywallOneTimePrice.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase'**
  String get paywallOneTimePrice;

  /// No description provided for @paywallForever.
  ///
  /// In en, this message translates to:
  /// **'Forever'**
  String get paywallForever;

  /// No description provided for @paywallPurchaseButton.
  ///
  /// In en, this message translates to:
  /// **'Purchase Premium'**
  String get paywallPurchaseButton;

  /// No description provided for @paywallRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get paywallRestoreButton;

  /// No description provided for @paywallPurchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Premium purchase successful!'**
  String get paywallPurchaseSuccess;

  /// No description provided for @paywallPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'❌ Purchase failed'**
  String get paywallPurchaseFailed;

  /// No description provided for @paywallRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Purchase restored successfully.'**
  String get paywallRestoreSuccess;

  /// No description provided for @paywallNoRestorableItems.
  ///
  /// In en, this message translates to:
  /// **'❌ No purchase history found.'**
  String get paywallNoRestorableItems;

  /// No description provided for @paywallNoPreviousPurchase.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found.'**
  String get paywallNoPreviousPurchase;

  /// No description provided for @paywallError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get paywallError;

  /// No description provided for @paywallTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get paywallTryAgain;

  /// No description provided for @paywallMockNotice.
  ///
  /// In en, this message translates to:
  /// **'(Mock implementation: Not real purchase)'**
  String get paywallMockNotice;

  /// No description provided for @paywallRouletteLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Limit Reached'**
  String get paywallRouletteLimitTitle;

  /// No description provided for @paywallRouletteLimitContent.
  ///
  /// In en, this message translates to:
  /// **'Free users can create up to 3 roulette sets.\nUpgrade to Premium for unlimited sets.'**
  String get paywallRouletteLimitContent;

  /// No description provided for @paywallUnlockButton.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get paywallUnlockButton;

  /// No description provided for @paywallDiceLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Dice Type Locked'**
  String get paywallDiceLockTitle;

  /// No description provided for @paywallDiceLockContent.
  ///
  /// In en, this message translates to:
  /// **'D4, D8, D10, D12, D20 are available in Premium.'**
  String get paywallDiceLockContent;

  /// No description provided for @paywallLadderLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Participant Limit Reached'**
  String get paywallLadderLimitTitle;

  /// No description provided for @paywallLadderLimitContent.
  ///
  /// In en, this message translates to:
  /// **'Free users can add up to 6 participants. Upgrade to add up to 12.'**
  String get paywallLadderLimitContent;

  /// No description provided for @paywallNumberLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Range Limit Reached'**
  String get paywallNumberLimitTitle;

  /// No description provided for @paywallNumberLimitContent.
  ///
  /// In en, this message translates to:
  /// **'Free users can set a max of 9,999. Upgrade for up to 999,999,999.'**
  String get paywallNumberLimitContent;

  /// No description provided for @premiumStatusFree.
  ///
  /// In en, this message translates to:
  /// **'Free Version'**
  String get premiumStatusFree;

  /// No description provided for @premiumStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Premium Active'**
  String get premiumStatusActive;

  /// No description provided for @premiumFeatureAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get premiumFeatureAds;

  /// No description provided for @premiumFeatureSets.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Sets'**
  String get premiumFeatureSets;

  /// No description provided for @premiumFeaturePalettes.
  ///
  /// In en, this message translates to:
  /// **'All Palettes'**
  String get premiumFeaturePalettes;

  /// No description provided for @premiumPurchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchased: {date}'**
  String premiumPurchaseDate(String date);

  /// No description provided for @premiumMockNotice.
  ///
  /// In en, this message translates to:
  /// **'(Mock implementation: Not real purchase)'**
  String get premiumMockNotice;

  /// No description provided for @premiumPurchaseButtonActive.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get premiumPurchaseButtonActive;

  /// No description provided for @premiumPurchaseButtonInactive.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get premiumPurchaseButtonInactive;

  /// No description provided for @premiumRestoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get premiumRestoreButton;

  /// No description provided for @premiumRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'✅ Restore Success!'**
  String get premiumRestoreSuccess;

  /// No description provided for @premiumRestoreEmpty.
  ///
  /// In en, this message translates to:
  /// **'❌ No History'**
  String get premiumRestoreEmpty;

  /// No description provided for @settingsPremiumFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'FREE PLAN'**
  String get settingsPremiumFreeTitle;

  /// No description provided for @settingsPremiumFreeLimitRoulette.
  ///
  /// In en, this message translates to:
  /// **'Roulette: max {count} sets'**
  String settingsPremiumFreeLimitRoulette(int count);

  /// No description provided for @settingsPremiumFreeLimitLadder.
  ///
  /// In en, this message translates to:
  /// **'Ladder: max {count} players'**
  String settingsPremiumFreeLimitLadder(int count);

  /// No description provided for @settingsPremiumFreeLimitDice.
  ///
  /// In en, this message translates to:
  /// **'Dice: D6 only'**
  String get settingsPremiumFreeLimitDice;

  /// No description provided for @settingsPremiumFreeLimitNumber.
  ///
  /// In en, this message translates to:
  /// **'Number: max {limit}'**
  String settingsPremiumFreeLimitNumber(String limit);

  /// No description provided for @settingsPremiumBenefitNoAds.
  ///
  /// In en, this message translates to:
  /// **'No Ads'**
  String get settingsPremiumBenefitNoAds;

  /// No description provided for @settingsPremiumBenefitUnlimitedSets.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Sets'**
  String get settingsPremiumBenefitUnlimitedSets;

  /// No description provided for @settingsPremiumBenefitAllDice.
  ///
  /// In en, this message translates to:
  /// **'All Dice'**
  String get settingsPremiumBenefitAllDice;

  /// No description provided for @settingsPremiumBenefitExtRange.
  ///
  /// In en, this message translates to:
  /// **'Extended Range'**
  String get settingsPremiumBenefitExtRange;

  /// No description provided for @settingsPremiumBenefitAllBg.
  ///
  /// In en, this message translates to:
  /// **'All Backgrounds'**
  String get settingsPremiumBenefitAllBg;

  /// No description provided for @settingsPremiumUnlockAll.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Features'**
  String get settingsPremiumUnlockAll;

  /// No description provided for @settingsPremiumRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchase'**
  String get settingsPremiumRestore;

  /// No description provided for @settingsPremiumProTitle.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get settingsPremiumProTitle;

  /// No description provided for @settingsPremiumProBenefitAds.
  ///
  /// In en, this message translates to:
  /// **'Ad-free experience'**
  String get settingsPremiumProBenefitAds;

  /// No description provided for @settingsPremiumProBenefitSets.
  ///
  /// In en, this message translates to:
  /// **'Unlimited roulette sets'**
  String get settingsPremiumProBenefitSets;

  /// No description provided for @settingsPremiumProBenefitTools.
  ///
  /// In en, this message translates to:
  /// **'All tools fully unlocked'**
  String get settingsPremiumProBenefitTools;

  /// No description provided for @settingsPremiumProBenefitBg.
  ///
  /// In en, this message translates to:
  /// **'All backgrounds available'**
  String get settingsPremiumProBenefitBg;

  /// No description provided for @createManualTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Blank'**
  String get createManualTitle;

  /// No description provided for @createManualSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter items manually'**
  String get createManualSubtitle;

  /// No description provided for @createTemplateSubtitleNew.
  ///
  /// In en, this message translates to:
  /// **'Start with a template'**
  String get createTemplateSubtitleNew;

  /// No description provided for @atmosphereLabel.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get atmosphereLabel;

  /// No description provided for @firstRunWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get firstRunWelcomeTitle;

  /// No description provided for @firstRunWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try spinning a starter set right now'**
  String get firstRunWelcomeSubtitle;

  /// No description provided for @firstRunSubtitle.
  ///
  /// In en, this message translates to:
  /// **'From Roulette to Ladder\nWe help you decide.'**
  String get firstRunSubtitle;

  /// No description provided for @firstRunCreateManual.
  ///
  /// In en, this message translates to:
  /// **'Create Your Own'**
  String get firstRunCreateManual;

  /// No description provided for @firstRunViewMore.
  ///
  /// In en, this message translates to:
  /// **'Browse All Starter Sets'**
  String get firstRunViewMore;

  /// No description provided for @firstRunSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Save this roulette?'**
  String get firstRunSaveTitle;

  /// No description provided for @firstRunSaveMessage.
  ///
  /// In en, this message translates to:
  /// **'Save it to My Sets so you can use it anytime.'**
  String get firstRunSaveMessage;

  /// No description provided for @firstRunSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get firstRunSaveButton;

  /// No description provided for @firstRunSkipButton.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get firstRunSkipButton;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingStart;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Can\'t decide?'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Desc.
  ///
  /// In en, this message translates to:
  /// **'Roulette, Ladder, Dice, Coin — all in one place.'**
  String get onboardingSlide1Desc;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Ladder Game Too'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter participants and start right away.'**
  String get onboardingSlide2Desc;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Start for Free'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Desc.
  ///
  /// In en, this message translates to:
  /// **'Core features are completely free.'**
  String get onboardingSlide3Desc;

  /// No description provided for @sectionQuickLaunch.
  ///
  /// In en, this message translates to:
  /// **'Quick Launch'**
  String get sectionQuickLaunch;

  /// No description provided for @quickLaunchSpin.
  ///
  /// In en, this message translates to:
  /// **'Spin'**
  String get quickLaunchSpin;

  /// No description provided for @lastResultWithDate.
  ///
  /// In en, this message translates to:
  /// **'Last: {result} · {date}'**
  String lastResultWithDate(String result, String date);

  /// No description provided for @recentResult.
  ///
  /// In en, this message translates to:
  /// **'Last: {result}'**
  String recentResult(String result);

  /// No description provided for @sectionRecommend.
  ///
  /// In en, this message translates to:
  /// **'Try These Roulettes'**
  String get sectionRecommend;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @tabLadder.
  ///
  /// In en, this message translates to:
  /// **'Ladder'**
  String get tabLadder;

  /// No description provided for @ladderTitle.
  ///
  /// In en, this message translates to:
  /// **'Ladder'**
  String get ladderTitle;

  /// No description provided for @ladderParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get ladderParticipants;

  /// No description provided for @ladderResults.
  ///
  /// In en, this message translates to:
  /// **'Results (optional)'**
  String get ladderResults;

  /// No description provided for @ladderResultHint.
  ///
  /// In en, this message translates to:
  /// **'Leave blank for auto 1st, 2nd...'**
  String get ladderResultHint;

  /// No description provided for @ladderStart.
  ///
  /// In en, this message translates to:
  /// **'Start Ladder'**
  String get ladderStart;

  /// No description provided for @ladderRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get ladderRetry;

  /// No description provided for @ladderShare.
  ///
  /// In en, this message translates to:
  /// **'Share Results'**
  String get ladderShare;

  /// No description provided for @ladderAddParticipant.
  ///
  /// In en, this message translates to:
  /// **'+ Add Participant'**
  String get ladderAddParticipant;

  /// No description provided for @ladderCountBadge.
  ///
  /// In en, this message translates to:
  /// **'{current} / {max}'**
  String ladderCountBadge(int current, int max);

  /// No description provided for @ladderPerson.
  ///
  /// In en, this message translates to:
  /// **'Person {index}'**
  String ladderPerson(int index);

  /// No description provided for @ladderResult.
  ///
  /// In en, this message translates to:
  /// **'Result {index}'**
  String ladderResult(int index);

  /// No description provided for @ladderResultDefault1st.
  ///
  /// In en, this message translates to:
  /// **'1st'**
  String get ladderResultDefault1st;

  /// No description provided for @ladderResultDefault2nd.
  ///
  /// In en, this message translates to:
  /// **'2nd'**
  String get ladderResultDefault2nd;

  /// No description provided for @ladderResultDefault3rd.
  ///
  /// In en, this message translates to:
  /// **'3rd'**
  String get ladderResultDefault3rd;

  /// No description provided for @ladderResultDefaultNth.
  ///
  /// In en, this message translates to:
  /// **'{n}th'**
  String ladderResultDefaultNth(int n);

  /// No description provided for @ladderMinParticipants.
  ///
  /// In en, this message translates to:
  /// **'At least 2 participants required'**
  String get ladderMinParticipants;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} days ago'**
  String dateDaysAgo(int days);

  /// No description provided for @shareResultText.
  ///
  /// In en, this message translates to:
  /// **'[{name}] Result: {result}\nDecided with Spin Wheel 🎡'**
  String shareResultText(String name, String result);

  /// No description provided for @errorRouletteMaxLimit.
  ///
  /// In en, this message translates to:
  /// **'You can create up to {max} roulettes.'**
  String errorRouletteMaxLimit(int max);

  /// No description provided for @errorRouletteNotFound.
  ///
  /// In en, this message translates to:
  /// **'Roulette not found: {id}'**
  String errorRouletteNotFound(String id);

  /// No description provided for @editorErrorMinItems.
  ///
  /// In en, this message translates to:
  /// **'At least {min} items required.'**
  String editorErrorMinItems(int min);

  /// No description provided for @editorErrorNoName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a roulette name.'**
  String get editorErrorNoName;

  /// No description provided for @editorErrorItemsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter at least {min} items.'**
  String editorErrorItemsRequired(int min);

  /// No description provided for @editorErrorEmptyItems.
  ///
  /// In en, this message translates to:
  /// **'Please fill in empty items.'**
  String get editorErrorEmptyItems;

  /// No description provided for @editorErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'Roulette not found.'**
  String get editorErrorNotFound;

  /// No description provided for @itemNameHint.
  ///
  /// In en, this message translates to:
  /// **'Item name'**
  String get itemNameHint;

  /// No description provided for @itemNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get itemNameRequired;

  /// No description provided for @itemDeleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete item'**
  String get itemDeleteTooltip;

  /// No description provided for @itemColorPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get itemColorPickerTitle;

  /// No description provided for @rouletteCopyPrefix.
  ///
  /// In en, this message translates to:
  /// **'[Copy] {name}'**
  String rouletteCopyPrefix(String name);

  /// No description provided for @homeNewSetButton.
  ///
  /// In en, this message translates to:
  /// **'+ New Set'**
  String get homeNewSetButton;

  /// No description provided for @homeItemCount.
  ///
  /// In en, this message translates to:
  /// **'{category} · {count} items'**
  String homeItemCount(String category, int count);

  /// No description provided for @coinFront.
  ///
  /// In en, this message translates to:
  /// **'H'**
  String get coinFront;

  /// No description provided for @coinBack.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get coinBack;

  /// No description provided for @coinFlipButton.
  ///
  /// In en, this message translates to:
  /// **'🪙 Flip'**
  String get coinFlipButton;

  /// No description provided for @toolsStatTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get toolsStatTotal;

  /// No description provided for @numberProSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Larger ranges available with PRO'**
  String get numberProSnackbar;

  /// No description provided for @numberProSnackbarAction.
  ///
  /// In en, this message translates to:
  /// **'View PRO'**
  String get numberProSnackbarAction;

  /// No description provided for @numberCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Random Number'**
  String get numberCardTitle;

  /// No description provided for @numberRangeHintPro.
  ///
  /// In en, this message translates to:
  /// **'Max 999,999,999'**
  String get numberRangeHintPro;

  /// No description provided for @numberRangeHintFree.
  ///
  /// In en, this message translates to:
  /// **'Max 9,999 · PRO for bigger'**
  String get numberRangeHintFree;

  /// No description provided for @diceGenerateButton.
  ///
  /// In en, this message translates to:
  /// **'🎲 Generate'**
  String get diceGenerateButton;

  /// No description provided for @ladderMaxParticipantsPro.
  ///
  /// In en, this message translates to:
  /// **'🔒 Max 12 (PRO)'**
  String get ladderMaxParticipantsPro;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'ja',
    'ko',
    'pt',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
