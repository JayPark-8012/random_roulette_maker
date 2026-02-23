// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

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
}
