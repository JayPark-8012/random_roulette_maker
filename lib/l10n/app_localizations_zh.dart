// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Spin Wheel – Random Roulette';

  @override
  String get homeTitle => 'Spin Wheel – Random Roulette';

  @override
  String get settingsTooltip => '设置';

  @override
  String get tabRoulette => '转盘';

  @override
  String get tabCoin => '硬币';

  @override
  String get tabDice => '骰子';

  @override
  String get tabNumber => '数字';

  @override
  String get sectionMySets => '我的转盘';

  @override
  String get fabCreateNew => '新建转盘';

  @override
  String get emptyTitle => '还没有转盘';

  @override
  String get emptySubtitle => '难以做决定？\n立即创建你的第一个转盘！';

  @override
  String get emptyButton => '创建第一个转盘';

  @override
  String get createBlankTitle => '空白开始';

  @override
  String get createBlankSubtitle => '自己输入选项';

  @override
  String get createTemplateTitle => '入门套装';

  @override
  String get createTemplateSubtitle => '从预设开始';

  @override
  String duplicated(String name) {
    return '「$name」已复制。';
  }

  @override
  String get limitTitle => '转盘数量限制';

  @override
  String limitContent(int count) {
    return '免费版最多保存 $count 个转盘。\n请删除现有转盘或升级到高级版。';
  }

  @override
  String get actionClose => '关闭';

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '删除';

  @override
  String get actionSave => '保存';

  @override
  String get actionConfirm => '确认';

  @override
  String get actionLeave => '退出';

  @override
  String get actionRename => '重命名';

  @override
  String get premiumComingSoon => '高级功能即将推出。';

  @override
  String get premiumButton => '了解高级版';

  @override
  String get editorTitleEdit => '编辑转盘';

  @override
  String get editorTitleNew => '创建转盘';

  @override
  String get deleteRouletteTooltip => '删除转盘';

  @override
  String get addItemTooltip => '添加选项';

  @override
  String get rouletteNameLabel => '转盘名称';

  @override
  String get rouletteNameHint => '例：今天的午餐';

  @override
  String get rouletteNameError => '请输入名称';

  @override
  String itemsHeader(int count) {
    return '选项 ($count)';
  }

  @override
  String get dragHint => '拖动排序';

  @override
  String get previewLabel => '实时预览';

  @override
  String get emptyItemLabel => '(空选项)';

  @override
  String moreItems(int count) {
    return '+ $count 个';
  }

  @override
  String get exitTitle => '不保存退出';

  @override
  String get exitContent => '更改将不会保存。确定退出吗？';

  @override
  String get actionContinueEditing => '继续编辑';

  @override
  String get deleteRouletteTitle => '删除转盘';

  @override
  String get deleteRouletteContent => '删除这个转盘吗？\n历史记录也会一并删除。';

  @override
  String cardDeleteContent(String name) {
    return '删除「$name」吗？\n历史记录也会一并删除。';
  }

  @override
  String get renameTitle => '重命名';

  @override
  String get playFallbackTitle => '转盘';

  @override
  String get notEnoughItems => '选项不足，请在编辑器中添加。';

  @override
  String get modeLottery => '抽签';

  @override
  String get modeRound => '轮次';

  @override
  String get modeCustom => '自定义';

  @override
  String remainingItems(int count) {
    return '剩余 $count 个';
  }

  @override
  String roundStatus(int current, int total) {
    return '轮次 $current / $total';
  }

  @override
  String get noRepeat => '不重复';

  @override
  String get autoReset => '自动重置';

  @override
  String get allPicked => '所有选项已抽完！';

  @override
  String get actionReset => '重置';

  @override
  String get spinLabel => '旋转';

  @override
  String get spinningLabel => '旋转中...';

  @override
  String get historyTitle => '最近结果';

  @override
  String get noHistory => '暂无记录。';

  @override
  String get shareTitle => '分享';

  @override
  String get shareTextTitle => '以文字分享';

  @override
  String get shareTextSubtitle => '分享转盘名称和结果';

  @override
  String get shareImageTitle => '以图片分享';

  @override
  String get shareImageSubtitle => '将转盘屏幕分享为图片';

  @override
  String get shareImageFailed => '图片分享失败。';

  @override
  String get resultLabel => '结果';

  @override
  String get actionReSpin => '再转一次';

  @override
  String get actionCopy => '复制';

  @override
  String get copiedMessage => '结果已复制到剪贴板。';

  @override
  String get statsTooltip => '统计';

  @override
  String get historyTooltip => '历史';

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionTheme => '主题';

  @override
  String get screenModeLabel => '显示模式';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get colorPaletteLabel => '颜色方案';

  @override
  String get wheelThemeLabel => '轉盤主題';

  @override
  String get premiumThemeTitle => '高级主题';

  @override
  String get premiumThemeContent => '这是高级功能。\n升级后即可使用。';

  @override
  String get sectionFeedback => '反馈';

  @override
  String get soundLabel => '声音';

  @override
  String get soundSubtitle => '旋转和结果音效';

  @override
  String get soundPackLabel => '音效包';

  @override
  String get packBasic => '基础';

  @override
  String get packClicky => '点击音';

  @override
  String get packParty => '派对';

  @override
  String get vibrationLabel => '震动';

  @override
  String get vibrationSubtitle => '显示结果时震动';

  @override
  String get hapticOff => '关闭';

  @override
  String get hapticLight => '轻微';

  @override
  String get hapticStrong => '强烈';

  @override
  String get sectionSpinTime => '旋转时长';

  @override
  String get spinShort => '短 (2秒)';

  @override
  String get spinNormal => '正常 (4.5秒)';

  @override
  String get spinLong => '长 (7秒)';

  @override
  String get sectionLanguage => '语言';

  @override
  String get langSystem => '跟随系统（推荐）';

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
  String get sectionAppInfo => '应用信息';

  @override
  String get versionLabel => '版本';

  @override
  String get openSourceLabel => '开源许可证';

  @override
  String get contactLabel => '联系我们';

  @override
  String get comingSoon => '即将推出。';

  @override
  String get coinFlipTitle => '抛硬币';

  @override
  String get coinHeads => '正';

  @override
  String get coinTails => '反';

  @override
  String get actionFlip => '抛出';

  @override
  String get recent10 => '最近10次';

  @override
  String get diceTitle => '骰子';

  @override
  String rollDice(int type) {
    return '投 D$type';
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
  String get randomNumberTitle => '随机数字';

  @override
  String get minLabel => '最小值';

  @override
  String get maxLabel => '最大值';

  @override
  String get actionGenerate => '生成';

  @override
  String get recent20 => '最近20次';

  @override
  String get minMaxError => '最小值必须小于最大值。';

  @override
  String get splashTitle => 'Spin Wheel – Random Roulette';

  @override
  String get splashSubtitle => '创建你自己的转盘';

  @override
  String get templatesTitle => '入门套装';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count 个选项';
  }

  @override
  String get useTemplate => '使用此套装';

  @override
  String freePlanLimit(int count) {
    return '免费版最多支持 $count 个转盘';
  }

  @override
  String itemCount(int count) {
    return '$count 个选项';
  }

  @override
  String get menuEdit => '编辑';

  @override
  String get menuDuplicate => '复制';

  @override
  String get menuRename => '重命名';

  @override
  String get statsTitle => '统计';

  @override
  String statsRecentN(int count) {
    return '(最近$count次)';
  }

  @override
  String get statsRecentResults => '最近结果';

  @override
  String get statsFrequency => '频率';

  @override
  String statsTimes(int count) {
    return '$count次';
  }

  @override
  String statsExpected(String pct) {
    return '期望$pct%';
  }

  @override
  String get starterSetsTitle => '入门套装';

  @override
  String get starterSetYesNo => '是 / 否';

  @override
  String get starterSetTruthDare => '真心话大冒险';

  @override
  String get starterSetTeamSplit => '分队';

  @override
  String get starterSetNumbers => '数字 1-10';

  @override
  String get starterSetFood => '美食';

  @override
  String get starterSetRandomOrder => '随机顺序';

  @override
  String get starterSetWinnerPick => '选出赢家';

  @override
  String get starterCatDecision => '决策';

  @override
  String get starterCatFun => '趣味';

  @override
  String get starterCatTeam => '团队';

  @override
  String get starterCatNumbers => '数字';

  @override
  String get starterCatFood => '美食';

  @override
  String get starterCatGame => '游戏';

  @override
  String get itemYes => '是';

  @override
  String get itemNo => '否';

  @override
  String get itemTruth => '真心话';

  @override
  String get itemDare => '大冒险';

  @override
  String get itemTeamA => '队伍A';

  @override
  String get itemTeamB => '队伍B';

  @override
  String get itemPlayer1 => '玩家1';

  @override
  String get itemPlayer2 => '玩家2';

  @override
  String get itemPlayer3 => '玩家3';

  @override
  String get itemPlayer4 => '玩家4';

  @override
  String get itemCandidateA => '候选人A';

  @override
  String get itemCandidateB => '候选人B';

  @override
  String get itemCandidateC => '候选人C';

  @override
  String get itemPizza => '披萨';

  @override
  String get itemBurger => '汉堡';

  @override
  String get itemPasta => '意面';

  @override
  String get itemSalad => '沙拉';

  @override
  String get itemSushi => '寿司';

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
  String get paywallUnlockButton => '解锁高级版';

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
  String get premiumStatusFree => '免费版';

  @override
  String get premiumStatusActive => '高级版激活';

  @override
  String get premiumFeatureAds => '移除广告';

  @override
  String get premiumFeatureSets => '无限转盘';

  @override
  String get premiumFeaturePalettes => '全色板解锁';

  @override
  String premiumPurchaseDate(String date) {
    return '购买于: $date';
  }

  @override
  String get premiumMockNotice => '(模拟实现：非真实购买)';

  @override
  String get premiumPurchaseButtonActive => '已购买';

  @override
  String get premiumPurchaseButtonInactive => '升级高级版';

  @override
  String get premiumRestoreButton => '恢复';

  @override
  String get premiumRestoreSuccess => '✅ 恢复成功！';

  @override
  String get premiumRestoreEmpty => '❌ 无购买记录';

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
  String get createManualTitle => '空白开始';

  @override
  String get createManualSubtitle => '手动输入选项';

  @override
  String get createTemplateSubtitleNew => '从模板开始';

  @override
  String get atmosphereLabel => '背景';

  @override
  String get firstRunWelcomeTitle => '歡迎！';

  @override
  String get firstRunWelcomeSubtitle => '現在就試試轉動入門套裝';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => '自訂建立';

  @override
  String get firstRunViewMore => '查看所有入門套裝';

  @override
  String get firstRunSaveTitle => '儲存這個輪盤？';

  @override
  String get firstRunSaveMessage => '儲存到我的套裝後，可以隨時使用。';

  @override
  String get firstRunSaveButton => '儲存';

  @override
  String get firstRunSkipButton => '略過';

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
  String get sectionQuickLaunch => '快速啟動';

  @override
  String get quickLaunchSpin => '轉動';

  @override
  String lastResultWithDate(String result, String date) {
    return '上次: $result · $date';
  }

  @override
  String recentResult(String result) {
    return '上次: $result';
  }

  @override
  String get sectionRecommend => '試試這些輪盤';

  @override
  String get showMore => '展開更多';

  @override
  String get showLess => '收起';

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

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get appTitle => '随机转盘';

  @override
  String get homeTitle => '随机工具';

  @override
  String get settingsTooltip => '设置';

  @override
  String get tabRoulette => '转盘';

  @override
  String get tabCoin => '硬币';

  @override
  String get tabDice => '骰子';

  @override
  String get tabNumber => '数字';

  @override
  String get sectionMySets => '我的转盘';

  @override
  String get fabCreateNew => '新建转盘';

  @override
  String get emptyTitle => '还没有转盘';

  @override
  String get emptySubtitle => '难以做决定？\n立即创建你的第一个转盘！';

  @override
  String get emptyButton => '创建第一个转盘';

  @override
  String get createBlankTitle => '空白开始';

  @override
  String get createBlankSubtitle => '自己输入选项';

  @override
  String get createTemplateTitle => '入门套装';

  @override
  String get createTemplateSubtitle => '从预设开始';

  @override
  String duplicated(String name) {
    return '「$name」已复制。';
  }

  @override
  String get limitTitle => '转盘数量限制';

  @override
  String limitContent(int count) {
    return '免费版最多保存 $count 个转盘。\n请删除现有转盘或升级到高级版。';
  }

  @override
  String get actionClose => '关闭';

  @override
  String get actionCancel => '取消';

  @override
  String get actionDelete => '删除';

  @override
  String get actionSave => '保存';

  @override
  String get actionConfirm => '确认';

  @override
  String get actionLeave => '退出';

  @override
  String get actionRename => '重命名';

  @override
  String get premiumComingSoon => '高级功能即将推出。';

  @override
  String get premiumButton => '了解高级版';

  @override
  String get editorTitleEdit => '编辑转盘';

  @override
  String get editorTitleNew => '创建转盘';

  @override
  String get deleteRouletteTooltip => '删除转盘';

  @override
  String get addItemTooltip => '添加选项';

  @override
  String get rouletteNameLabel => '转盘名称';

  @override
  String get rouletteNameHint => '例：今天的午餐';

  @override
  String get rouletteNameError => '请输入名称';

  @override
  String itemsHeader(int count) {
    return '选项 ($count)';
  }

  @override
  String get dragHint => '拖动排序';

  @override
  String get previewLabel => '实时预览';

  @override
  String get emptyItemLabel => '(空选项)';

  @override
  String moreItems(int count) {
    return '+ $count 个';
  }

  @override
  String get exitTitle => '不保存退出';

  @override
  String get exitContent => '更改将不会保存。确定退出吗？';

  @override
  String get actionContinueEditing => '继续编辑';

  @override
  String get deleteRouletteTitle => '删除转盘';

  @override
  String get deleteRouletteContent => '删除这个转盘吗？\n历史记录也会一并删除。';

  @override
  String cardDeleteContent(String name) {
    return '删除「$name」吗？\n历史记录也会一并删除。';
  }

  @override
  String get renameTitle => '重命名';

  @override
  String get playFallbackTitle => '转盘';

  @override
  String get notEnoughItems => '选项不足，请在编辑器中添加。';

  @override
  String get modeLottery => '抽签';

  @override
  String get modeRound => '轮次';

  @override
  String get modeCustom => '自定义';

  @override
  String remainingItems(int count) {
    return '剩余 $count 个';
  }

  @override
  String roundStatus(int current, int total) {
    return '轮次 $current / $total';
  }

  @override
  String get noRepeat => '不重复';

  @override
  String get autoReset => '自动重置';

  @override
  String get allPicked => '所有选项已抽完！';

  @override
  String get actionReset => '重置';

  @override
  String get spinLabel => '旋转';

  @override
  String get spinningLabel => '旋转中...';

  @override
  String get historyTitle => '最近结果';

  @override
  String get noHistory => '暂无记录。';

  @override
  String get shareTitle => '分享';

  @override
  String get shareTextTitle => '以文字分享';

  @override
  String get shareTextSubtitle => '分享转盘名称和结果';

  @override
  String get shareImageTitle => '以图片分享';

  @override
  String get shareImageSubtitle => '将转盘屏幕分享为图片';

  @override
  String get shareImageFailed => '图片分享失败。';

  @override
  String get resultLabel => '结果';

  @override
  String get actionReSpin => '再转一次';

  @override
  String get actionCopy => '复制';

  @override
  String get copiedMessage => '结果已复制到剪贴板。';

  @override
  String get statsTooltip => '统计';

  @override
  String get historyTooltip => '历史';

  @override
  String get settingsTitle => '设置';

  @override
  String get sectionTheme => '主题';

  @override
  String get screenModeLabel => '显示模式';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get colorPaletteLabel => '颜色方案';

  @override
  String get wheelThemeLabel => '转盘主题';

  @override
  String get premiumThemeTitle => '高级主题';

  @override
  String get premiumThemeContent => '这是高级功能。\n升级后即可使用。';

  @override
  String get sectionFeedback => '反馈';

  @override
  String get soundLabel => '声音';

  @override
  String get soundSubtitle => '旋转和结果音效';

  @override
  String get soundPackLabel => '音效包';

  @override
  String get packBasic => '基础';

  @override
  String get packClicky => '点击音';

  @override
  String get packParty => '派对';

  @override
  String get vibrationLabel => '震动';

  @override
  String get vibrationSubtitle => '显示结果时震动';

  @override
  String get hapticOff => '关闭';

  @override
  String get hapticLight => '轻微';

  @override
  String get hapticStrong => '强烈';

  @override
  String get sectionSpinTime => '旋转时长';

  @override
  String get spinShort => '短 (2秒)';

  @override
  String get spinNormal => '正常 (4.5秒)';

  @override
  String get spinLong => '长 (7秒)';

  @override
  String get sectionLanguage => '语言';

  @override
  String get langSystem => '跟随系统（推荐）';

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
  String get sectionAppInfo => '应用信息';

  @override
  String get versionLabel => '版本';

  @override
  String get openSourceLabel => '开源许可证';

  @override
  String get contactLabel => '联系我们';

  @override
  String get comingSoon => '即将推出。';

  @override
  String get coinFlipTitle => '抛硬币';

  @override
  String get coinHeads => '正';

  @override
  String get coinTails => '反';

  @override
  String get actionFlip => '抛出';

  @override
  String get recent10 => '最近10次';

  @override
  String get diceTitle => '骰子';

  @override
  String rollDice(int type) {
    return '投 D$type';
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
  String get randomNumberTitle => '随机数字';

  @override
  String get minLabel => '最小值';

  @override
  String get maxLabel => '最大值';

  @override
  String get actionGenerate => '生成';

  @override
  String get recent20 => '最近20次';

  @override
  String get minMaxError => '最小值必须小于最大值。';

  @override
  String get splashTitle => '随机转盘';

  @override
  String get splashSubtitle => '创建你自己的转盘';

  @override
  String get templatesTitle => '入门套装';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count 个选项';
  }

  @override
  String get useTemplate => '使用此套装';

  @override
  String freePlanLimit(int count) {
    return '免费版最多支持 $count 个转盘';
  }

  @override
  String itemCount(int count) {
    return '$count 个选项';
  }

  @override
  String get menuEdit => '编辑';

  @override
  String get menuDuplicate => '复制';

  @override
  String get menuRename => '重命名';

  @override
  String get statsTitle => '统计';

  @override
  String statsRecentN(int count) {
    return '(最近$count次)';
  }

  @override
  String get statsRecentResults => '最近结果';

  @override
  String get statsFrequency => '频率';

  @override
  String statsTimes(int count) {
    return '$count次';
  }

  @override
  String statsExpected(String pct) {
    return '期望$pct%';
  }

  @override
  String get starterSetsTitle => '入门套装';

  @override
  String get starterSetYesNo => '是 / 否';

  @override
  String get starterSetTruthDare => '真心话大冒险';

  @override
  String get starterSetTeamSplit => '分队';

  @override
  String get starterSetNumbers => '数字 1-10';

  @override
  String get starterSetFood => '美食';

  @override
  String get starterSetRandomOrder => '随机顺序';

  @override
  String get starterSetWinnerPick => '选出赢家';

  @override
  String get starterCatDecision => '决策';

  @override
  String get starterCatFun => '趣味';

  @override
  String get starterCatTeam => '团队';

  @override
  String get starterCatNumbers => '数字';

  @override
  String get starterCatFood => '美食';

  @override
  String get starterCatGame => '游戏';

  @override
  String get itemYes => '是';

  @override
  String get itemNo => '否';

  @override
  String get itemTruth => '真心话';

  @override
  String get itemDare => '大冒险';

  @override
  String get itemTeamA => '队伍A';

  @override
  String get itemTeamB => '队伍B';

  @override
  String get itemPlayer1 => '玩家1';

  @override
  String get itemPlayer2 => '玩家2';

  @override
  String get itemPlayer3 => '玩家3';

  @override
  String get itemPlayer4 => '玩家4';

  @override
  String get itemCandidateA => '候选人A';

  @override
  String get itemCandidateB => '候选人B';

  @override
  String get itemCandidateC => '候选人C';

  @override
  String get itemPizza => '披萨';

  @override
  String get itemBurger => '汉堡';

  @override
  String get itemPasta => '意面';

  @override
  String get itemSalad => '沙拉';

  @override
  String get itemSushi => '寿司';

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
  String get atmosphereLabel => '背景';

  @override
  String get firstRunWelcomeTitle => '欢迎！';

  @override
  String get firstRunWelcomeSubtitle => '立即试试转动初始套装';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => '自定义创建';

  @override
  String get firstRunViewMore => '查看所有初始套装';

  @override
  String get firstRunSaveTitle => '保存这个轮盘？';

  @override
  String get firstRunSaveMessage => '保存到我的套装后，可以随时使用。';

  @override
  String get firstRunSaveButton => '保存';

  @override
  String get firstRunSkipButton => '跳过';

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
  String get sectionQuickLaunch => '快速启动';

  @override
  String get quickLaunchSpin => '转动';

  @override
  String lastResultWithDate(String result, String date) {
    return '上次: $result · $date';
  }

  @override
  String recentResult(String result) {
    return '上次: $result';
  }

  @override
  String get sectionRecommend => '试试这些轮盘';

  @override
  String get showMore => '展开更多';

  @override
  String get showLess => '收起';

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
