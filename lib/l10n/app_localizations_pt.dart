// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Spin Wheel – Random Roulette';

  @override
  String get homeTitle => 'Spin Wheel – Random Roulette';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get tabRoulette => 'Roleta';

  @override
  String get tabCoin => 'Moeda';

  @override
  String get tabDice => 'Dado';

  @override
  String get tabNumber => 'Número';

  @override
  String get sectionMySets => 'Minhas Roletas';

  @override
  String get fabCreateNew => 'Nova Roleta';

  @override
  String get emptyTitle => 'Sem roletas ainda';

  @override
  String get emptySubtitle =>
      'Com dificuldade de decidir?\nCrie sua primeira roleta agora!';

  @override
  String get emptyButton => 'Criar Primeira Roleta';

  @override
  String get createBlankTitle => 'Começar em branco';

  @override
  String get createBlankSubtitle => 'Digite os itens você mesmo';

  @override
  String get createTemplateTitle => 'Kits de Início';

  @override
  String get createTemplateSubtitle => 'Comece com um preset';

  @override
  String duplicated(String name) {
    return '\"$name\" duplicada.';
  }

  @override
  String get limitTitle => 'Limite de Roletas';

  @override
  String limitContent(int count) {
    return 'O plano gratuito permite até $count roletas.\nExclua uma existente ou atualize para premium.';
  }

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionLeave => 'Sair';

  @override
  String get actionRename => 'Renomear';

  @override
  String get premiumComingSoon => 'Funções premium em breve.';

  @override
  String get premiumButton => 'Ver Premium';

  @override
  String get editorTitleEdit => 'Editar Roleta';

  @override
  String get editorTitleNew => 'Criar Roleta';

  @override
  String get deleteRouletteTooltip => 'Excluir Roleta';

  @override
  String get addItemTooltip => 'Adicionar Item';

  @override
  String get rouletteNameLabel => 'Nome da Roleta';

  @override
  String get rouletteNameHint => 'ex. Almoço de hoje';

  @override
  String get rouletteNameError => 'Por favor insira um nome';

  @override
  String itemsHeader(int count) {
    return 'Itens ($count)';
  }

  @override
  String get dragHint => 'Arraste para reordenar';

  @override
  String get previewLabel => 'Pré-visualização';

  @override
  String get emptyItemLabel => '(vazio)';

  @override
  String moreItems(int count) {
    return '+ $count mais';
  }

  @override
  String get exitTitle => 'Sair sem Salvar';

  @override
  String get exitContent => 'As alterações não serão salvas. Sair?';

  @override
  String get actionContinueEditing => 'Continuar Editando';

  @override
  String get deleteRouletteTitle => 'Excluir Roleta';

  @override
  String get deleteRouletteContent =>
      'Excluir esta roleta?\nO histórico também será excluído.';

  @override
  String cardDeleteContent(String name) {
    return 'Excluir \"$name\"?\nO histórico também será excluído.';
  }

  @override
  String get renameTitle => 'Renomear';

  @override
  String get playFallbackTitle => 'Roleta';

  @override
  String get notEnoughItems => 'Itens insuficientes. Adicione pelo editor.';

  @override
  String get modeLottery => 'Sorteio';

  @override
  String get modeRound => 'Rodada';

  @override
  String get modeCustom => 'Personalizado';

  @override
  String remainingItems(int count) {
    return 'Restantes: $count';
  }

  @override
  String roundStatus(int current, int total) {
    return 'Rodada $current / $total';
  }

  @override
  String get noRepeat => 'Sem repetição';

  @override
  String get autoReset => 'Reinício auto';

  @override
  String get allPicked => 'Todos os itens sorteados!';

  @override
  String get actionReset => 'Reiniciar';

  @override
  String get spinLabel => 'GIRAR';

  @override
  String get spinningLabel => 'Girando...';

  @override
  String get historyTitle => 'Resultados Recentes';

  @override
  String get noHistory => 'Sem registros ainda.';

  @override
  String get shareTitle => 'Compartilhar';

  @override
  String get shareTextTitle => 'Compartilhar texto';

  @override
  String get shareTextSubtitle => 'Compartilhe o nome e resultado';

  @override
  String get shareImageTitle => 'Compartilhar imagem';

  @override
  String get shareImageSubtitle => 'Compartilhe a tela como imagem';

  @override
  String get shareImageFailed => 'Falha ao compartilhar imagem.';

  @override
  String get resultLabel => 'Resultado';

  @override
  String get actionReSpin => 'Girar de novo';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get copiedMessage => 'Resultado copiado.';

  @override
  String get statsTooltip => 'Estatísticas';

  @override
  String get historyTooltip => 'Histórico';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get sectionTheme => 'Tema';

  @override
  String get screenModeLabel => 'Modo de tela';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Escuro';

  @override
  String get colorPaletteLabel => 'Paleta de cores';

  @override
  String get wheelThemeLabel => 'Tema da roleta';

  @override
  String get premiumThemeTitle => 'Tema Premium';

  @override
  String get premiumThemeContent =>
      'Este tema é uma função premium.\nAtualize para usá-lo.';

  @override
  String get sectionFeedback => 'Feedback';

  @override
  String get soundLabel => 'Som';

  @override
  String get soundSubtitle => 'Efeitos de som ao girar';

  @override
  String get soundPackLabel => 'Pacote de sons';

  @override
  String get packBasic => 'Básico';

  @override
  String get packClicky => 'Clicky';

  @override
  String get packParty => 'Festa';

  @override
  String get vibrationLabel => 'Vibração';

  @override
  String get vibrationSubtitle => 'Vibrar ao mostrar resultado';

  @override
  String get hapticOff => 'Não';

  @override
  String get hapticLight => 'Suave';

  @override
  String get hapticStrong => 'Forte';

  @override
  String get sectionSpinTime => 'Duração do Giro';

  @override
  String get spinShort => 'Curto (2s)';

  @override
  String get spinNormal => 'Normal (4.5s)';

  @override
  String get spinLong => 'Longo (7s)';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Sistema (Recomendado)';

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
  String get sectionAppInfo => 'Info do App';

  @override
  String get versionLabel => 'Versão';

  @override
  String get openSourceLabel => 'Licenças de código aberto';

  @override
  String get contactLabel => 'Contato';

  @override
  String get comingSoon => 'Em breve.';

  @override
  String get coinFlipTitle => 'Cara ou Coroa';

  @override
  String get coinHeads => 'C';

  @override
  String get coinTails => 'K';

  @override
  String get actionFlip => 'Lançar';

  @override
  String get recent10 => 'Últimas 10';

  @override
  String get diceTitle => 'Dado';

  @override
  String rollDice(int type) {
    return 'Rolar D$type';
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
  String get randomNumberTitle => 'Número Aleatório';

  @override
  String get minLabel => 'Mín';

  @override
  String get maxLabel => 'Máx';

  @override
  String get actionGenerate => 'Gerar';

  @override
  String get recent20 => 'Últimas 20';

  @override
  String get minMaxError => 'O mínimo deve ser menor que o máximo.';

  @override
  String get splashTitle => 'Spin Wheel – Random Roulette';

  @override
  String get splashSubtitle => 'Crie sua própria roleta';

  @override
  String get templatesTitle => 'Kits de Início';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count itens';
  }

  @override
  String get useTemplate => 'Usar este kit';

  @override
  String freePlanLimit(int count) {
    return 'O plano gratuito permite até $count roletas';
  }

  @override
  String itemCount(int count) {
    return '$count itens';
  }

  @override
  String get menuEdit => 'Editar';

  @override
  String get menuDuplicate => 'Duplicar';

  @override
  String get menuRename => 'Renomear';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String statsRecentN(int count) {
    return '($count giros)';
  }

  @override
  String get statsRecentResults => 'Resultados Recentes';

  @override
  String get statsFrequency => 'Frequência';

  @override
  String statsTimes(int count) {
    return '${count}x';
  }

  @override
  String statsExpected(String pct) {
    return 'E:$pct%';
  }

  @override
  String get starterSetsTitle => 'Kits de Início';

  @override
  String get starterSetYesNo => 'Sim / Não';

  @override
  String get starterSetTruthDare => 'Verdade ou Desafio';

  @override
  String get starterSetTeamSplit => 'Dividir Times';

  @override
  String get starterSetNumbers => 'Números 1-10';

  @override
  String get starterSetFood => 'Comida';

  @override
  String get starterSetRandomOrder => 'Ordem Aleatória';

  @override
  String get starterSetWinnerPick => 'Escolher Vencedor';

  @override
  String get starterCatDecision => 'Decisão';

  @override
  String get starterCatFun => 'Diversão';

  @override
  String get starterCatTeam => 'Time';

  @override
  String get starterCatNumbers => 'Números';

  @override
  String get starterCatFood => 'Comida';

  @override
  String get starterCatGame => 'Jogo';

  @override
  String get itemYes => 'Sim';

  @override
  String get itemNo => 'Não';

  @override
  String get itemTruth => 'Verdade';

  @override
  String get itemDare => 'Desafio';

  @override
  String get itemTeamA => 'Time A';

  @override
  String get itemTeamB => 'Time B';

  @override
  String get itemPlayer1 => 'Jogador 1';

  @override
  String get itemPlayer2 => 'Jogador 2';

  @override
  String get itemPlayer3 => 'Jogador 3';

  @override
  String get itemPlayer4 => 'Jogador 4';

  @override
  String get itemCandidateA => 'Candidato A';

  @override
  String get itemCandidateB => 'Candidato B';

  @override
  String get itemCandidateC => 'Candidato C';

  @override
  String get itemPizza => 'Pizza';

  @override
  String get itemBurger => 'Hambúrguer';

  @override
  String get itemPasta => 'Massa';

  @override
  String get itemSalad => 'Salada';

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
  String get paywallUnlockButton => 'Desbloquear Premium';

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
  String get premiumStatusFree => 'Versão Gratuita';

  @override
  String get premiumStatusActive => 'Premium Ativo';

  @override
  String get premiumFeatureAds => 'Sem Anúncios';

  @override
  String get premiumFeatureSets => 'Roletas Ilimitadas';

  @override
  String get premiumFeaturePalettes => 'Todas as Paletas';

  @override
  String premiumPurchaseDate(String date) {
    return 'Comprado em: $date';
  }

  @override
  String get premiumMockNotice => '(Implementación Mock: No é uma compra real)';

  @override
  String get premiumPurchaseButtonActive => 'Comprado';

  @override
  String get premiumPurchaseButtonInactive => 'Obter Premium';

  @override
  String get premiumRestoreButton => 'Restaurar';

  @override
  String get premiumRestoreSuccess => '✅ Restauração com Sucesso!';

  @override
  String get premiumRestoreEmpty => '❌ Sem Histórico';

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
  String get createManualTitle => 'Em Branco';

  @override
  String get createManualSubtitle => 'Insira os itens você mesmo';

  @override
  String get createTemplateSubtitleNew => 'Começar com um modelo';

  @override
  String get atmosphereLabel => 'Fundo';

  @override
  String get firstRunWelcomeTitle => 'Bem-vindo!';

  @override
  String get firstRunWelcomeSubtitle =>
      'Experimente girar um set inicial agora';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => 'Criar o seu';

  @override
  String get firstRunViewMore => 'Ver todos os sets';

  @override
  String get firstRunSaveTitle => 'Guardar esta roleta?';

  @override
  String get firstRunSaveMessage =>
      'Guarde em Os Meus Sets para usar quando quiser.';

  @override
  String get firstRunSaveButton => 'Guardar';

  @override
  String get firstRunSkipButton => 'Saltar';

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
  String get sectionQuickLaunch => 'Acesso Rápido';

  @override
  String get quickLaunchSpin => 'Girar';

  @override
  String lastResultWithDate(String result, String date) {
    return 'Último: $result · $date';
  }

  @override
  String recentResult(String result) {
    return 'Último: $result';
  }

  @override
  String get sectionRecommend => 'Experimente estas roletas';

  @override
  String get showMore => 'Ver mais';

  @override
  String get showLess => 'Ver menos';

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

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appTitle => 'Roleta Aleatória';

  @override
  String get homeTitle => 'Ferramentas';

  @override
  String get settingsTooltip => 'Configurações';

  @override
  String get tabRoulette => 'Roleta';

  @override
  String get tabCoin => 'Moeda';

  @override
  String get tabDice => 'Dado';

  @override
  String get tabNumber => 'Número';

  @override
  String get sectionMySets => 'Minhas Roletas';

  @override
  String get fabCreateNew => 'Nova Roleta';

  @override
  String get emptyTitle => 'Sem roletas ainda';

  @override
  String get emptySubtitle =>
      'Com dificuldade de decidir?\nCrie sua primeira roleta agora!';

  @override
  String get emptyButton => 'Criar Primeira Roleta';

  @override
  String get createBlankTitle => 'Começar em branco';

  @override
  String get createBlankSubtitle => 'Digite os itens você mesmo';

  @override
  String get createTemplateTitle => 'Kits de Início';

  @override
  String get createTemplateSubtitle => 'Comece com um preset';

  @override
  String duplicated(String name) {
    return '\"$name\" duplicada.';
  }

  @override
  String get limitTitle => 'Limite de Roletas';

  @override
  String limitContent(int count) {
    return 'O plano gratuito permite até $count roletas.\nExclua uma existente ou atualize para premium.';
  }

  @override
  String get actionClose => 'Fechar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionLeave => 'Sair';

  @override
  String get actionRename => 'Renomear';

  @override
  String get premiumComingSoon => 'Funções premium em breve.';

  @override
  String get premiumButton => 'Ver Premium';

  @override
  String get editorTitleEdit => 'Editar Roleta';

  @override
  String get editorTitleNew => 'Criar Roleta';

  @override
  String get deleteRouletteTooltip => 'Excluir Roleta';

  @override
  String get addItemTooltip => 'Adicionar Item';

  @override
  String get rouletteNameLabel => 'Nome da Roleta';

  @override
  String get rouletteNameHint => 'ex. Almoço de hoje';

  @override
  String get rouletteNameError => 'Por favor insira um nome';

  @override
  String itemsHeader(int count) {
    return 'Itens ($count)';
  }

  @override
  String get dragHint => 'Arraste para reordenar';

  @override
  String get previewLabel => 'Pré-visualização';

  @override
  String get emptyItemLabel => '(vazio)';

  @override
  String moreItems(int count) {
    return '+ $count mais';
  }

  @override
  String get exitTitle => 'Sair sem Salvar';

  @override
  String get exitContent => 'As alterações não serão salvas. Sair?';

  @override
  String get actionContinueEditing => 'Continuar Editando';

  @override
  String get deleteRouletteTitle => 'Excluir Roleta';

  @override
  String get deleteRouletteContent =>
      'Excluir esta roleta?\nO histórico também será excluído.';

  @override
  String cardDeleteContent(String name) {
    return 'Excluir \"$name\"?\nO histórico também será excluído.';
  }

  @override
  String get renameTitle => 'Renomear';

  @override
  String get playFallbackTitle => 'Roleta';

  @override
  String get notEnoughItems => 'Itens insuficientes. Adicione pelo editor.';

  @override
  String get modeLottery => 'Sorteio';

  @override
  String get modeRound => 'Rodada';

  @override
  String get modeCustom => 'Personalizado';

  @override
  String remainingItems(int count) {
    return 'Restantes: $count';
  }

  @override
  String roundStatus(int current, int total) {
    return 'Rodada $current / $total';
  }

  @override
  String get noRepeat => 'Sem repetição';

  @override
  String get autoReset => 'Reinício auto';

  @override
  String get allPicked => 'Todos os itens sorteados!';

  @override
  String get actionReset => 'Reiniciar';

  @override
  String get spinLabel => 'GIRAR';

  @override
  String get spinningLabel => 'Girando...';

  @override
  String get historyTitle => 'Resultados Recentes';

  @override
  String get noHistory => 'Sem registros ainda.';

  @override
  String get shareTitle => 'Compartilhar';

  @override
  String get shareTextTitle => 'Compartilhar texto';

  @override
  String get shareTextSubtitle => 'Compartilhe o nome e resultado';

  @override
  String get shareImageTitle => 'Compartilhar imagem';

  @override
  String get shareImageSubtitle => 'Compartilhe a tela como imagem';

  @override
  String get shareImageFailed => 'Falha ao compartilhar imagem.';

  @override
  String get resultLabel => 'Resultado';

  @override
  String get actionReSpin => 'Girar de novo';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get copiedMessage => 'Resultado copiado.';

  @override
  String get statsTooltip => 'Estatísticas';

  @override
  String get historyTooltip => 'Histórico';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get sectionTheme => 'Tema';

  @override
  String get screenModeLabel => 'Modo de tela';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Escuro';

  @override
  String get colorPaletteLabel => 'Paleta de cores';

  @override
  String get wheelThemeLabel => 'Tema da roleta';

  @override
  String get premiumThemeTitle => 'Tema Premium';

  @override
  String get premiumThemeContent =>
      'Este tema é uma função premium.\nAtualize para usá-lo.';

  @override
  String get sectionFeedback => 'Feedback';

  @override
  String get soundLabel => 'Som';

  @override
  String get soundSubtitle => 'Efeitos de som ao girar';

  @override
  String get soundPackLabel => 'Pacote de sons';

  @override
  String get packBasic => 'Básico';

  @override
  String get packClicky => 'Clicky';

  @override
  String get packParty => 'Festa';

  @override
  String get vibrationLabel => 'Vibração';

  @override
  String get vibrationSubtitle => 'Vibrar ao mostrar resultado';

  @override
  String get hapticOff => 'Não';

  @override
  String get hapticLight => 'Suave';

  @override
  String get hapticStrong => 'Forte';

  @override
  String get sectionSpinTime => 'Duração do Giro';

  @override
  String get spinShort => 'Curto (2s)';

  @override
  String get spinNormal => 'Normal (4.5s)';

  @override
  String get spinLong => 'Longo (7s)';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get langSystem => 'Sistema (Recomendado)';

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
  String get sectionAppInfo => 'Info do App';

  @override
  String get versionLabel => 'Versão';

  @override
  String get openSourceLabel => 'Licenças de código aberto';

  @override
  String get contactLabel => 'Contato';

  @override
  String get comingSoon => 'Em breve.';

  @override
  String get coinFlipTitle => 'Cara ou Coroa';

  @override
  String get coinHeads => 'C';

  @override
  String get coinTails => 'K';

  @override
  String get actionFlip => 'Lançar';

  @override
  String get recent10 => 'Últimas 10';

  @override
  String get diceTitle => 'Dado';

  @override
  String rollDice(int type) {
    return 'Rolar D$type';
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
  String get randomNumberTitle => 'Número Aleatório';

  @override
  String get minLabel => 'Mín';

  @override
  String get maxLabel => 'Máx';

  @override
  String get actionGenerate => 'Gerar';

  @override
  String get recent20 => 'Últimas 20';

  @override
  String get minMaxError => 'O mínimo deve ser menor que o máximo.';

  @override
  String get splashTitle => 'Roleta Aleatória';

  @override
  String get splashSubtitle => 'Crie sua própria roleta';

  @override
  String get templatesTitle => 'Kits de Início';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count itens';
  }

  @override
  String get useTemplate => 'Usar este kit';

  @override
  String freePlanLimit(int count) {
    return 'O plano gratuito permite até $count roletas';
  }

  @override
  String itemCount(int count) {
    return '$count itens';
  }

  @override
  String get menuEdit => 'Editar';

  @override
  String get menuDuplicate => 'Duplicar';

  @override
  String get menuRename => 'Renomear';

  @override
  String get statsTitle => 'Estatísticas';

  @override
  String statsRecentN(int count) {
    return '($count giros)';
  }

  @override
  String get statsRecentResults => 'Resultados Recentes';

  @override
  String get statsFrequency => 'Frequência';

  @override
  String statsTimes(int count) {
    return '${count}x';
  }

  @override
  String statsExpected(String pct) {
    return 'E:$pct%';
  }

  @override
  String get starterSetsTitle => 'Kits de Início';

  @override
  String get starterSetYesNo => 'Sim / Não';

  @override
  String get starterSetTruthDare => 'Verdade ou Desafio';

  @override
  String get starterSetTeamSplit => 'Dividir Times';

  @override
  String get starterSetNumbers => 'Números 1-10';

  @override
  String get starterSetFood => 'Comida';

  @override
  String get starterSetRandomOrder => 'Ordem Aleatória';

  @override
  String get starterSetWinnerPick => 'Escolher Vencedor';

  @override
  String get starterCatDecision => 'Decisão';

  @override
  String get starterCatFun => 'Diversão';

  @override
  String get starterCatTeam => 'Time';

  @override
  String get starterCatNumbers => 'Números';

  @override
  String get starterCatFood => 'Comida';

  @override
  String get starterCatGame => 'Jogo';

  @override
  String get itemYes => 'Sim';

  @override
  String get itemNo => 'Não';

  @override
  String get itemTruth => 'Verdade';

  @override
  String get itemDare => 'Desafio';

  @override
  String get itemTeamA => 'Time A';

  @override
  String get itemTeamB => 'Time B';

  @override
  String get itemPlayer1 => 'Jogador 1';

  @override
  String get itemPlayer2 => 'Jogador 2';

  @override
  String get itemPlayer3 => 'Jogador 3';

  @override
  String get itemPlayer4 => 'Jogador 4';

  @override
  String get itemCandidateA => 'Candidato A';

  @override
  String get itemCandidateB => 'Candidato B';

  @override
  String get itemCandidateC => 'Candidato C';

  @override
  String get itemPizza => 'Pizza';

  @override
  String get itemBurger => 'Hambúrguer';

  @override
  String get itemPasta => 'Massa';

  @override
  String get itemSalad => 'Salada';

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
  String get atmosphereLabel => 'Fundo';

  @override
  String get firstRunWelcomeTitle => 'Bem-vindo!';

  @override
  String get firstRunWelcomeSubtitle =>
      'Experimente girar um set inicial agora';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => 'Criar o seu';

  @override
  String get firstRunViewMore => 'Ver todos os sets';

  @override
  String get firstRunSaveTitle => 'Salvar esta roleta?';

  @override
  String get firstRunSaveMessage =>
      'Salve em Meus Sets para usar quando quiser.';

  @override
  String get firstRunSaveButton => 'Salvar';

  @override
  String get firstRunSkipButton => 'Pular';

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
  String get sectionQuickLaunch => 'Acesso Rápido';

  @override
  String get quickLaunchSpin => 'Girar';

  @override
  String lastResultWithDate(String result, String date) {
    return 'Último: $result · $date';
  }

  @override
  String recentResult(String result) {
    return 'Último: $result';
  }

  @override
  String get sectionRecommend => 'Experimente estas roletas';

  @override
  String get showMore => 'Ver mais';

  @override
  String get showLess => 'Ver menos';

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
