// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Spin Wheel – Random Roulette';

  @override
  String get homeTitle => 'Spin Wheel – Random Roulette';

  @override
  String get settingsTooltip => '設定';

  @override
  String get tabRoulette => 'ルーレット';

  @override
  String get tabCoin => 'コイン';

  @override
  String get tabDice => 'サイコロ';

  @override
  String get tabNumber => '数字';

  @override
  String get sectionMySets => 'マイルーレット';

  @override
  String get fabCreateNew => '新規作成';

  @override
  String get emptyTitle => 'ルーレットがありません';

  @override
  String get emptySubtitle => '決めかねることがあれば\n最初のルーレットを作りましょう！';

  @override
  String get emptyButton => '最初のルーレットを作る';

  @override
  String get createBlankTitle => '空白から開始';

  @override
  String get createBlankSubtitle => '項目を自分で入力する';

  @override
  String get createTemplateTitle => 'スターターセット';

  @override
  String get createTemplateSubtitle => 'プリセットから始める';

  @override
  String duplicated(String name) {
    return '「$name」を複製しました。';
  }

  @override
  String get limitTitle => 'ルーレット上限';

  @override
  String limitContent(int count) {
    return '無料プランは最大$count個まで保存できます。\n既存のルーレットを削除するかアップグレードしてください。';
  }

  @override
  String get actionClose => '閉じる';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionDelete => '削除';

  @override
  String get actionSave => '保存';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionLeave => '終了';

  @override
  String get actionRename => '変更';

  @override
  String get premiumComingSoon => 'プレミアム機能は準備中です。';

  @override
  String get premiumButton => 'プレミアムを見る';

  @override
  String get editorTitleEdit => 'ルーレット編集';

  @override
  String get editorTitleNew => 'ルーレット作成';

  @override
  String get deleteRouletteTooltip => 'ルーレット削除';

  @override
  String get addItemTooltip => '項目追加';

  @override
  String get rouletteNameLabel => 'ルーレット名';

  @override
  String get rouletteNameHint => '例：今日のランチ';

  @override
  String get rouletteNameError => '名前を入力してください';

  @override
  String itemsHeader(int count) {
    return '項目 ($count)';
  }

  @override
  String get dragHint => 'ドラッグして並び替え';

  @override
  String get previewLabel => 'リアルタイムプレビュー';

  @override
  String get emptyItemLabel => '(空の項目)';

  @override
  String moreItems(int count) {
    return '+ $count個以上';
  }

  @override
  String get exitTitle => '保存せずに終了';

  @override
  String get exitContent => '変更内容は保存されません。終了しますか？';

  @override
  String get actionContinueEditing => '編集を続ける';

  @override
  String get deleteRouletteTitle => 'ルーレット削除';

  @override
  String get deleteRouletteContent => 'このルーレットを削除しますか？\n履歴も一緒に削除されます。';

  @override
  String cardDeleteContent(String name) {
    return '「$name」を削除しますか？\n履歴も一緒に削除されます。';
  }

  @override
  String get renameTitle => '名前を変更';

  @override
  String get playFallbackTitle => 'ルーレット';

  @override
  String get notEnoughItems => '項目が不足しています。エディターから追加してください。';

  @override
  String get modeLottery => '抽選';

  @override
  String get modeRound => 'ラウンド';

  @override
  String get modeCustom => 'カスタム';

  @override
  String remainingItems(int count) {
    return '残り $count 個';
  }

  @override
  String roundStatus(int current, int total) {
    return 'ラウンド $current / $total';
  }

  @override
  String get noRepeat => '重複なし';

  @override
  String get autoReset => '自動リセット';

  @override
  String get allPicked => '全項目を引きました！';

  @override
  String get actionReset => 'リセット';

  @override
  String get spinLabel => 'スピン';

  @override
  String get spinningLabel => '回転中...';

  @override
  String get historyTitle => '最近の結果';

  @override
  String get noHistory => 'まだ記録がありません。';

  @override
  String get shareTitle => '共有';

  @override
  String get shareTextTitle => 'テキストで共有';

  @override
  String get shareTextSubtitle => '名前と結果をテキストで共有';

  @override
  String get shareImageTitle => '画像で共有';

  @override
  String get shareImageSubtitle => 'ルーレット画面を画像で共有';

  @override
  String get shareImageFailed => '画像の共有に失敗しました。';

  @override
  String get resultLabel => '当選項目';

  @override
  String get actionReSpin => 'もう一度回す';

  @override
  String get actionCopy => 'コピー';

  @override
  String get copiedMessage => '結果をクリップボードにコピーしました。';

  @override
  String get statsTooltip => '統計';

  @override
  String get historyTooltip => '履歴';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionTheme => 'テーマ';

  @override
  String get screenModeLabel => '表示モード';

  @override
  String get themeModeSystem => 'システム';

  @override
  String get themeModeLight => 'ライト';

  @override
  String get themeModeDark => 'ダーク';

  @override
  String get colorPaletteLabel => 'カラーパレット';

  @override
  String get wheelThemeLabel => 'ルーレットテーマ';

  @override
  String get premiumThemeTitle => 'プレミアムテーマ';

  @override
  String get premiumThemeContent => 'このテーマはプレミアム機能です。\nアップグレードしてご利用ください。';

  @override
  String get sectionFeedback => 'フィードバック';

  @override
  String get soundLabel => 'サウンド';

  @override
  String get soundSubtitle => 'スピン・結果効果音';

  @override
  String get soundPackLabel => 'サウンドパック';

  @override
  String get packBasic => '基本';

  @override
  String get packClicky => 'クリッキー';

  @override
  String get packParty => 'パーティー';

  @override
  String get vibrationLabel => 'バイブレーション';

  @override
  String get vibrationSubtitle => '結果発表時に振動';

  @override
  String get hapticOff => 'オフ';

  @override
  String get hapticLight => '弱い';

  @override
  String get hapticStrong => '強い';

  @override
  String get sectionSpinTime => 'スピン時間';

  @override
  String get spinShort => '短い (2秒)';

  @override
  String get spinNormal => '普通 (4.5秒)';

  @override
  String get spinLong => '長い (7秒)';

  @override
  String get sectionLanguage => '言語';

  @override
  String get langSystem => 'システム(推奨)';

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
  String get sectionAppInfo => 'アプリ情報';

  @override
  String get versionLabel => 'バージョン';

  @override
  String get openSourceLabel => 'オープンソースライセンス';

  @override
  String get contactLabel => 'お問い合わせ';

  @override
  String get comingSoon => '準備中です。';

  @override
  String get coinFlipTitle => 'コインフリップ';

  @override
  String get coinHeads => '表';

  @override
  String get coinTails => '裏';

  @override
  String get actionFlip => 'フリップ';

  @override
  String get recent10 => '直近10回';

  @override
  String get diceTitle => 'サイコロ';

  @override
  String rollDice(int type) {
    return 'D$type を振る';
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
  String get randomNumberTitle => 'ランダム数字';

  @override
  String get minLabel => '最小値';

  @override
  String get maxLabel => '最大値';

  @override
  String get actionGenerate => '生成';

  @override
  String get recent20 => '直近20回';

  @override
  String get minMaxError => '最小値は最大値より小さくしてください。';

  @override
  String get splashTitle => 'Spin Wheel – Random Roulette';

  @override
  String get splashSubtitle => 'あなただけのルーレットを作ろう';

  @override
  String get templatesTitle => 'スターターセット';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count個の項目';
  }

  @override
  String get useTemplate => 'このセットを使う';

  @override
  String freePlanLimit(int count) {
    return '無料プランは最大$count個まで可能です';
  }

  @override
  String itemCount(int count) {
    return '項目 $count個';
  }

  @override
  String get menuEdit => '編集';

  @override
  String get menuDuplicate => '複製';

  @override
  String get menuRename => '名前を変更';

  @override
  String get statsTitle => '統計';

  @override
  String statsRecentN(int count) {
    return '(直近$count回)';
  }

  @override
  String get statsRecentResults => '最近の結果';

  @override
  String get statsFrequency => '頻度';

  @override
  String statsTimes(int count) {
    return '$count回';
  }

  @override
  String statsExpected(String pct) {
    return '期待$pct%';
  }

  @override
  String get starterSetsTitle => 'スターターセット';

  @override
  String get starterSetYesNo => 'はい / いいえ';

  @override
  String get starterSetTruthDare => '本当のことかチャレンジ';

  @override
  String get starterSetTeamSplit => 'チーム分け';

  @override
  String get starterSetNumbers => '数字 1-10';

  @override
  String get starterSetFood => '食べ物';

  @override
  String get starterSetRandomOrder => 'ランダム順';

  @override
  String get starterSetWinnerPick => '勝者を選ぶ';

  @override
  String get starterCatDecision => '決断';

  @override
  String get starterCatFun => '楽しみ';

  @override
  String get starterCatTeam => 'チーム';

  @override
  String get starterCatNumbers => '数字';

  @override
  String get starterCatFood => '食べ物';

  @override
  String get starterCatGame => 'ゲーム';

  @override
  String get itemYes => 'はい';

  @override
  String get itemNo => 'いいえ';

  @override
  String get itemTruth => '本当のこと';

  @override
  String get itemDare => 'チャレンジ';

  @override
  String get itemTeamA => 'チームA';

  @override
  String get itemTeamB => 'チームB';

  @override
  String get itemPlayer1 => 'プレイヤー1';

  @override
  String get itemPlayer2 => 'プレイヤー2';

  @override
  String get itemPlayer3 => 'プレイヤー3';

  @override
  String get itemPlayer4 => 'プレイヤー4';

  @override
  String get itemCandidateA => '候補A';

  @override
  String get itemCandidateB => '候補B';

  @override
  String get itemCandidateC => '候補C';

  @override
  String get itemPizza => 'ピザ';

  @override
  String get itemBurger => 'バーガー';

  @override
  String get itemPasta => 'パスタ';

  @override
  String get itemSalad => 'サラダ';

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
  String get paywallUnlockButton => 'プレミアムを解除';

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
  String get premiumStatusFree => '無料版';

  @override
  String get premiumStatusActive => 'プレミアム利用中';

  @override
  String get premiumFeatureAds => '広告非表示';

  @override
  String get premiumFeatureSets => 'ルーレット無制限';

  @override
  String get premiumFeaturePalettes => '全パレット解放';

  @override
  String premiumPurchaseDate(String date) {
    return '購入日: $date';
  }

  @override
  String get premiumMockNotice => '(注意: モック決済です)';

  @override
  String get premiumPurchaseButtonActive => '購入済み';

  @override
  String get premiumPurchaseButtonInactive => 'プレミアムを購入';

  @override
  String get premiumRestoreButton => '復元';

  @override
  String get premiumRestoreSuccess => '✅ 復元成功！';

  @override
  String get premiumRestoreEmpty => '❌ 履歴なし';

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
  String get createManualTitle => '新しく作る';

  @override
  String get createManualSubtitle => '項目を直接入力します';

  @override
  String get createTemplateSubtitleNew => 'テンプレートから開始します';

  @override
  String get atmosphereLabel => '背景';

  @override
  String get firstRunWelcomeTitle => 'ようこそ！';

  @override
  String get firstRunWelcomeSubtitle => 'スターターセットを今すぐ回してみましょう';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => '自分で作る';

  @override
  String get firstRunViewMore => 'スターターセット一覧';

  @override
  String get firstRunSaveTitle => 'このルーレットを保存しますか？';

  @override
  String get firstRunSaveMessage => 'マイセットに保存すると、いつでも使えます。';

  @override
  String get firstRunSaveButton => '保存';

  @override
  String get firstRunSkipButton => 'スキップ';

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
  String get sectionQuickLaunch => 'クイック起動';

  @override
  String get quickLaunchSpin => 'スピン';

  @override
  String lastResultWithDate(String result, String date) {
    return '前回: $result · $date';
  }

  @override
  String recentResult(String result) {
    return '前回: $result';
  }

  @override
  String get sectionRecommend => 'こんなルーレットはいかが？';

  @override
  String get showMore => 'もっと見る';

  @override
  String get showLess => '閉じる';

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
