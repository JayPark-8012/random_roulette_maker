// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Spin Wheel – Random Roulette';

  @override
  String get homeTitle => 'Spin Wheel – Random Roulette';

  @override
  String get settingsTooltip => 'Ajustes';

  @override
  String get tabRoulette => 'Ruleta';

  @override
  String get tabCoin => 'Moneda';

  @override
  String get tabDice => 'Dado';

  @override
  String get tabNumber => 'Número';

  @override
  String get sectionMySets => 'Mis Ruletas';

  @override
  String get fabCreateNew => 'Nueva Ruleta';

  @override
  String get emptyTitle => 'Sin ruletas aún';

  @override
  String get emptySubtitle =>
      '¿Dudas en decidir?\n¡Crea tu primera ruleta ahora!';

  @override
  String get emptyButton => 'Crear Primera Ruleta';

  @override
  String get createBlankTitle => 'Empezar en blanco';

  @override
  String get createBlankSubtitle => 'Introduce los elementos tú mismo';

  @override
  String get createTemplateTitle => 'Sets de Inicio';

  @override
  String get createTemplateSubtitle => 'Comienza con un preset';

  @override
  String duplicated(String name) {
    return '\"$name\" duplicada.';
  }

  @override
  String get limitTitle => 'Límite de Ruletas';

  @override
  String limitContent(int count) {
    return 'El plan gratuito permite hasta $count ruletas.\nElimina una existente o actualiza a premium.';
  }

  @override
  String get actionClose => 'Cerrar';

  @override
  String get actionCancel => 'Cancelar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionSave => 'Guardar';

  @override
  String get actionConfirm => 'OK';

  @override
  String get actionLeave => 'Salir';

  @override
  String get actionRename => 'Renombrar';

  @override
  String get premiumComingSoon => 'Las funciones premium están en camino.';

  @override
  String get premiumButton => 'Ver Premium';

  @override
  String get editorTitleEdit => 'Editar Ruleta';

  @override
  String get editorTitleNew => 'Crear Ruleta';

  @override
  String get deleteRouletteTooltip => 'Eliminar Ruleta';

  @override
  String get addItemTooltip => 'Agregar Elemento';

  @override
  String get rouletteNameLabel => 'Nombre de la Ruleta';

  @override
  String get rouletteNameHint => 'ej. Almuerzo de hoy';

  @override
  String get rouletteNameError => 'Por favor ingresa un nombre';

  @override
  String itemsHeader(int count) {
    return 'Elementos ($count)';
  }

  @override
  String get dragHint => 'Arrastra para reordenar';

  @override
  String get previewLabel => 'Vista Previa';

  @override
  String get emptyItemLabel => '(vacío)';

  @override
  String moreItems(int count) {
    return '+ $count más';
  }

  @override
  String get exitTitle => 'Salir sin Guardar';

  @override
  String get exitContent => 'Los cambios no se guardarán. ¿Salir?';

  @override
  String get actionContinueEditing => 'Seguir Editando';

  @override
  String get deleteRouletteTitle => 'Eliminar Ruleta';

  @override
  String get deleteRouletteContent =>
      '¿Eliminar esta ruleta?\nEl historial también se borrará.';

  @override
  String cardDeleteContent(String name) {
    return '¿Eliminar \"$name\"?\nEl historial también se borrará.';
  }

  @override
  String get renameTitle => 'Renombrar';

  @override
  String get playFallbackTitle => 'Ruleta';

  @override
  String get notEnoughItems => 'Pocos elementos. Añade más desde el editor.';

  @override
  String get modeLottery => 'Sorteo';

  @override
  String get modeRound => 'Ronda';

  @override
  String get modeCustom => 'Personalizado';

  @override
  String remainingItems(int count) {
    return 'Restantes: $count';
  }

  @override
  String roundStatus(int current, int total) {
    return 'Ronda $current / $total';
  }

  @override
  String get noRepeat => 'Sin repetir';

  @override
  String get autoReset => 'Auto reinicio';

  @override
  String get allPicked => '¡Todos los elementos sorteados!';

  @override
  String get actionReset => 'Reiniciar';

  @override
  String get spinLabel => 'GIRAR';

  @override
  String get spinningLabel => 'Girando...';

  @override
  String get historyTitle => 'Resultados Recientes';

  @override
  String get noHistory => 'Sin registros aún.';

  @override
  String get shareTitle => 'Compartir';

  @override
  String get shareTextTitle => 'Compartir texto';

  @override
  String get shareTextSubtitle => 'Comparte el nombre y resultado';

  @override
  String get shareImageTitle => 'Compartir imagen';

  @override
  String get shareImageSubtitle => 'Comparte la pantalla como imagen';

  @override
  String get shareImageFailed => 'Error al compartir imagen.';

  @override
  String get resultLabel => 'Resultado';

  @override
  String get actionReSpin => 'Girar de nuevo';

  @override
  String get actionCopy => 'Copiar';

  @override
  String get copiedMessage => 'Resultado copiado al portapapeles.';

  @override
  String get statsTooltip => 'Estadísticas';

  @override
  String get historyTooltip => 'Historial';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get sectionTheme => 'Tema';

  @override
  String get screenModeLabel => 'Modo de pantalla';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Claro';

  @override
  String get themeModeDark => 'Oscuro';

  @override
  String get colorPaletteLabel => 'Paleta de colores';

  @override
  String get wheelThemeLabel => 'Tema de ruleta';

  @override
  String get premiumThemeTitle => 'Tema Premium';

  @override
  String get premiumThemeContent =>
      'Este tema es una función premium.\nActualiza para usarlo.';

  @override
  String get sectionFeedback => 'Retroalimentación';

  @override
  String get soundLabel => 'Sonido';

  @override
  String get soundSubtitle => 'Efectos de sonido al girar';

  @override
  String get soundPackLabel => 'Pack de sonidos';

  @override
  String get packBasic => 'Básico';

  @override
  String get packClicky => 'Clicky';

  @override
  String get packParty => 'Fiesta';

  @override
  String get vibrationLabel => 'Vibración';

  @override
  String get vibrationSubtitle => 'Vibrar al mostrar resultado';

  @override
  String get hapticOff => 'No';

  @override
  String get hapticLight => 'Suave';

  @override
  String get hapticStrong => 'Fuerte';

  @override
  String get sectionSpinTime => 'Duración del Giro';

  @override
  String get spinShort => 'Corto (2s)';

  @override
  String get spinNormal => 'Normal (4.5s)';

  @override
  String get spinLong => 'Largo (7s)';

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
  String get sectionAppInfo => 'Info de la App';

  @override
  String get versionLabel => 'Versión';

  @override
  String get openSourceLabel => 'Licencias de código abierto';

  @override
  String get contactLabel => 'Contacto';

  @override
  String get comingSoon => 'Próximamente.';

  @override
  String get coinFlipTitle => 'Lanzar Moneda';

  @override
  String get coinHeads => 'C';

  @override
  String get coinTails => 'X';

  @override
  String get actionFlip => 'Lanzar';

  @override
  String get recent10 => 'Últimos 10';

  @override
  String get diceTitle => 'Dado';

  @override
  String rollDice(int type) {
    return 'Tirar D$type';
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
  String get randomNumberTitle => 'Número Aleatorio';

  @override
  String get minLabel => 'Mín';

  @override
  String get maxLabel => 'Máx';

  @override
  String get actionGenerate => 'Generar';

  @override
  String get recent20 => 'Últimos 20';

  @override
  String get minMaxError => 'El mínimo debe ser menor que el máximo.';

  @override
  String get splashTitle => 'Spin Wheel – Random Roulette';

  @override
  String get splashSubtitle => 'Crea tu propia ruleta';

  @override
  String get templatesTitle => 'Sets de Inicio';

  @override
  String templateItemsInfo(String category, int count) {
    return '$category · $count elementos';
  }

  @override
  String get useTemplate => 'Usar este set';

  @override
  String freePlanLimit(int count) {
    return 'El plan gratuito permite hasta $count ruletas';
  }

  @override
  String itemCount(int count) {
    return '$count elementos';
  }

  @override
  String get menuEdit => 'Editar';

  @override
  String get menuDuplicate => 'Duplicar';

  @override
  String get menuRename => 'Renombrar';

  @override
  String get statsTitle => 'Estadísticas';

  @override
  String statsRecentN(int count) {
    return '($count giros)';
  }

  @override
  String get statsRecentResults => 'Resultados Recientes';

  @override
  String get statsFrequency => 'Frecuencia';

  @override
  String statsTimes(int count) {
    return '${count}x';
  }

  @override
  String statsExpected(String pct) {
    return 'E:$pct%';
  }

  @override
  String get starterSetsTitle => 'Sets de Inicio';

  @override
  String get starterSetYesNo => 'Sí / No';

  @override
  String get starterSetTruthDare => 'Verdad o Reto';

  @override
  String get starterSetTeamSplit => 'Dividir Equipos';

  @override
  String get starterSetNumbers => 'Números 1-10';

  @override
  String get starterSetFood => 'Comida';

  @override
  String get starterSetRandomOrder => 'Orden Aleatorio';

  @override
  String get starterSetWinnerPick => 'Elegir Ganador';

  @override
  String get starterCatDecision => 'Decisión';

  @override
  String get starterCatFun => 'Diversión';

  @override
  String get starterCatTeam => 'Equipo';

  @override
  String get starterCatNumbers => 'Números';

  @override
  String get starterCatFood => 'Comida';

  @override
  String get starterCatGame => 'Juego';

  @override
  String get itemYes => 'Sí';

  @override
  String get itemNo => 'No';

  @override
  String get itemTruth => 'Verdad';

  @override
  String get itemDare => 'Reto';

  @override
  String get itemTeamA => 'Equipo A';

  @override
  String get itemTeamB => 'Equipo B';

  @override
  String get itemPlayer1 => 'Jugador 1';

  @override
  String get itemPlayer2 => 'Jugador 2';

  @override
  String get itemPlayer3 => 'Jugador 3';

  @override
  String get itemPlayer4 => 'Jugador 4';

  @override
  String get itemCandidateA => 'Candidato A';

  @override
  String get itemCandidateB => 'Candidato B';

  @override
  String get itemCandidateC => 'Candidato C';

  @override
  String get itemPizza => 'Pizza';

  @override
  String get itemBurger => 'Hamburguesa';

  @override
  String get itemPasta => 'Pasta';

  @override
  String get itemSalad => 'Ensalada';

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
  String get premiumStatusFree => 'Versión Gratuita';

  @override
  String get premiumStatusActive => 'Premium Activo';

  @override
  String get premiumFeatureAds => 'Sin Anuncios';

  @override
  String get premiumFeatureSets => 'Ruletas Ilimitadas';

  @override
  String get premiumFeaturePalettes => 'Todas las Paletas';

  @override
  String premiumPurchaseDate(String date) {
    return 'Comprado: $date';
  }

  @override
  String get premiumMockNotice =>
      '(Implementación Mock: No es una compra real)';

  @override
  String get premiumPurchaseButtonActive => 'Comprado';

  @override
  String get premiumPurchaseButtonInactive => 'Obtener Premium';

  @override
  String get premiumRestoreButton => 'Restaurar';

  @override
  String get premiumRestoreSuccess => '✅ Restauración Exitosa!';

  @override
  String get premiumRestoreEmpty => '❌ Sin Historial';

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
  String get createManualTitle => 'Empezar en Blanco';

  @override
  String get createManualSubtitle => 'Introduce los elementos tú mismo';

  @override
  String get createTemplateSubtitleNew => 'Empezar con una plantilla';

  @override
  String get atmosphereLabel => 'Fondo';

  @override
  String get firstRunWelcomeTitle => '¡Bienvenido!';

  @override
  String get firstRunWelcomeSubtitle => 'Prueba a girar un set de inicio ahora';

  @override
  String get firstRunSubtitle => 'From Roulette to Ladder\nWe help you decide.';

  @override
  String get firstRunCreateManual => 'Crear el tuyo';

  @override
  String get firstRunViewMore => 'Ver todos los sets';

  @override
  String get firstRunSaveTitle => '¿Guardar esta ruleta?';

  @override
  String get firstRunSaveMessage =>
      'Guárdala en Mis Sets para usarla cuando quieras.';

  @override
  String get firstRunSaveButton => 'Guardar';

  @override
  String get firstRunSkipButton => 'Omitir';

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
  String get sectionQuickLaunch => 'Acceso Rápido';

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
  String get sectionRecommend => 'Prueba estas ruletas';

  @override
  String get showMore => 'Ver más';

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
}
