// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
}
