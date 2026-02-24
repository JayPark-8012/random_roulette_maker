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
  String get paywallSubtitle =>
      'One-time purchase for unlimited access forever.';

  @override
  String get paywallFree => 'Free';

  @override
  String get paywallPremium => 'Premium';

  @override
  String get paywallAds => 'Ads';

  @override
  String get paywallRouletteSets => 'Roulette Sets';

  @override
  String get paywallColorPalettes => 'Color Palettes';

  @override
  String get paywallUnlimited => 'Unlimited';

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
  String get paywallPaletteLockTitle => 'Palette Locked';

  @override
  String paywallPaletteLockContent(String paletteName) {
    return 'The $paletteName palette is only available in Premium.\nUnlock all color palettes today!';
  }

  @override
  String get paywallUnlockButton => 'Desbloquear Premium';

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
  String get createManualTitle => 'Empezar en Blanco';

  @override
  String get createManualSubtitle => 'Introduce los elementos tú mismo';

  @override
  String get createTemplateSubtitleNew => 'Empezar con una plantilla';
}
