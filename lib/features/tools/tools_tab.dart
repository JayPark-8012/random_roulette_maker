import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/design_tokens.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/widgets/section_label.dart';
import '../../data/local_storage.dart';
import '../../l10n/app_localizations.dart';

class ToolsTab extends StatefulWidget {
  /// null = 전체 표시 / 'coin' | 'dice' | 'number' = 해당 도구만 표시
  final String? showOnly;
  const ToolsTab({super.key, this.showOnly});

  @override
  State<ToolsTab> createState() => _ToolsTabState();
}

class _ToolsTabState extends State<ToolsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // ── 코인 상태 ─────────────────────────────────────────
  bool? _coin; // null=미실행
  final List<bool> _coinHistory = [];

  // ── 주사위 상태 ──────────────────────────────────────
  int _selectedDiceType = 6;
  int? _diceResult;
  final List<Map<String, int>> _diceHistory = [];

  // ── 랜덤 숫자 상태 ────────────────────────────────────
  final _minCtrl = TextEditingController(text: '1');
  final _maxCtrl = TextEditingController(text: '100');
  int? _numResult;
  final List<Map<String, int>> _numHistory = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data =
          await LocalStorage.instance.getJsonMap(StorageKeys.toolsHistory);
      if (data == null || !mounted) return;
      setState(() {
        final coin = data['coin'] as List<dynamic>? ?? [];
        _coinHistory.addAll(coin.cast<bool>());
        if (_coinHistory.isNotEmpty) _coin = _coinHistory.first;

        final dice = data['dice'] as List<dynamic>? ?? [];
        for (final e in dice.cast<Map<String, dynamic>>()) {
          _diceHistory
              .add({'type': e['type'] as int, 'result': e['result'] as int});
        }
        if (_diceHistory.isNotEmpty) _diceResult = _diceHistory.first['result'];

        final nums = data['number'] as List<dynamic>? ?? [];
        for (final e in nums.cast<Map<String, dynamic>>()) {
          _numHistory.add({
            'min': e['min'] as int,
            'max': e['max'] as int,
            'result': e['result'] as int,
          });
        }
        if (_numHistory.isNotEmpty) _numResult = _numHistory.first['result'];
      });
    } catch (e) {
      debugPrint('ToolsTab._load() error: $e');
    }
  }

  Future<void> _save() async {
    try {
      await LocalStorage.instance.setJsonMap(StorageKeys.toolsHistory, {
        'coin': _coinHistory,
        'dice': _diceHistory,
        'number': _numHistory,
      });
    } catch (e) {
      debugPrint('ToolsTab._save() error: $e');
    }
  }

  void _flipCoin() {
    final r = Random().nextBool();
    setState(() {
      _coin = r;
      _coinHistory.insert(0, r);
      if (_coinHistory.length > 10) _coinHistory.removeLast();
    });
    _save();
  }

  void _rollDice() {
    final r = Random().nextInt(_selectedDiceType) + 1;
    setState(() {
      _diceResult = r;
      _diceHistory.insert(0, {'type': _selectedDiceType, 'result': r});
      if (_diceHistory.length > 10) _diceHistory.removeLast();
    });
    _save();
  }

  void _generateNumber() {
    final min = int.tryParse(_minCtrl.text.trim()) ?? 1;
    final max = int.tryParse(_maxCtrl.text.trim()) ?? 100;
    if (min >= max) return; // 검증은 _NumberCardState에서 처리
    final r = min + Random().nextInt(max - min + 1);
    setState(() {
      _numResult = r;
      _numHistory.insert(0, {'min': min, 'max': max, 'result': r});
      if (_numHistory.length > 10) _numHistory.removeLast();
    });
    _save();
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final so = widget.showOnly;

    // ── 단독 풀스크린 모드 (showOnly != null) ──
    if (so != null) {
      final Widget card = switch (so) {
        'coin' => _CoinCard(
            coin: _coin,
            history: _coinHistory,
            onFlip: _flipCoin,
            fullscreen: true),
        'dice' => _DiceCard(
            result: _diceResult,
            history: _diceHistory,
            onRoll: _rollDice,
            selectedType: _selectedDiceType,
            onTypeChanged: (t) => setState(() {
              _selectedDiceType = t;
              _diceResult = null;
            }),
            fullscreen: true),
        _ => _NumberCard(
            minCtrl: _minCtrl,
            maxCtrl: _maxCtrl,
            result: _numResult,
            history: _numHistory,
            onGenerate: _generateNumber,
            fullscreen: true),
      };
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        child: card,
      );
    }

    // ── 전체 목록 뷰 ──
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        _CoinCard(coin: _coin, history: _coinHistory, onFlip: _flipCoin),
        const SizedBox(height: 14),
        _DiceCard(
          result: _diceResult,
          history: _diceHistory,
          onRoll: _rollDice,
          selectedType: _selectedDiceType,
          onTypeChanged: (t) => setState(() {
            _selectedDiceType = t;
            _diceResult = null;
          }),
        ),
        const SizedBox(height: 14),
        _NumberCard(
          minCtrl: _minCtrl,
          maxCtrl: _maxCtrl,
          result: _numResult,
          history: _numHistory,
          onGenerate: _generateNumber,
        ),
      ],
    );
  }
}

// ── 공통 카드 데코레이션 헬퍼 ───────────────────────────────────
BoxDecoration _cardDecoration(Color accentColor, Color surface) {
  return BoxDecoration(
    color: Colors.white.withValues(alpha: 0.07),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: accentColor.withValues(alpha: 0.50),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: accentColor.withValues(alpha: 0.10),
        blurRadius: 8,
      ),
    ],
  );
}

// 아이콘 배지 헤더 위젯
Widget _cardHeader(
    BuildContext context, IconData icon, String title, Color color) {
  return Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
      ),
    ],
  );
}

// 가로 스크롤 히스토리 배지 리스트
Widget _historyRow(
    List<Widget> badges, String label, BuildContext context) {
  final cs = Theme.of(context).colorScheme;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: cs.onSurfaceVariant),
      ),
      const SizedBox(height: 8),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: badges),
      ),
    ],
  );
}

// ── 코인 플립 카드 (StatefulWidget + 3D flip) ──────────────────
class _CoinCard extends StatefulWidget {
  final bool? coin;
  final List<bool> history;
  final VoidCallback onFlip;
  final bool fullscreen;

  const _CoinCard({
    required this.coin,
    required this.history,
    required this.onFlip,
    this.fullscreen = false,
  });

  @override
  State<_CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<_CoinCard>
    with TickerProviderStateMixin {
  // 5바퀴 = 10 반회전 / easeOutCubic으로 자연 감속
  static const int _totalHalfTurns = 10;
  static const Duration _spinDuration = Duration(milliseconds: 2200);
  static const double _coinSize = 169.0; // 30% larger than 130

  late AnimationController _spinCtrl;
  late Animation<double> _spinAnim;

  // ── Idle glow pulse (2.5s cycle) ──
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  bool _isFlipping = false;
  int _flipDoneCount = 0;
  List<bool?> _halfTurnFaces = [];

  @override
  void initState() {
    super.initState();
    _spinCtrl = AnimationController(vsync: this, duration: _spinDuration);
    _spinAnim =
        CurvedAnimation(parent: _spinCtrl, curve: Curves.easeOutCubic);
    _spinCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() {
          _isFlipping = false;
          _flipDoneCount++;
        });
      }
    });

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.15, end: 0.45).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  List<bool?> _computeHalfTurnFaces(bool? initialFace) {
    final faces = <bool?>[];
    bool? current = initialFace;
    for (int i = 0; i < _totalHalfTurns; i++) {
      if (i.isEven) {
        faces.add(current);
      } else {
        if (i == _totalHalfTurns - 1) {
          faces.add(null);
        } else {
          current = Random().nextBool();
          faces.add(current);
        }
      }
    }
    return faces;
  }

  void _startFlip() {
    if (_isFlipping) return;
    final initialFace = widget.coin;
    widget.onFlip();
    _halfTurnFaces = _computeHalfTurnFaces(initialFace);
    setState(() => _isFlipping = true);
    _spinCtrl.forward(from: 0.0);
  }

  Widget _buildCoinFace(bool? isHeads) {
    // 미실행 상태: ? 물음표
    if (isHeads == null) {
      return Container(
        width: _coinSize,
        height: _coinSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.07),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 2.5,
          ),
        ),
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: Colors.white.withValues(alpha: 0.25),
            ),
          ),
        ),
      );
    }

    final isH = isHeads;
    // 앞면: gold gradient / 뒷면: silver gradient
    final gradient = isH
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFB800), Color(0xFFFF8C00)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC8D0DC), Color(0xFF8B9DB0)],
          );
    final borderColor =
        isH ? const Color(0xFFCC9400) : const Color(0xFF6B7D90);

    return Container(
      width: _coinSize,
      height: _coinSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
        border: Border.all(color: borderColor, width: 3.5),
      ),
      child: Center(
        child: Icon(
          isH ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          size: 56,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }

  Widget _buildFlipButton(AppLocalizations l10n) {
    const darkGold = Color(0xFF7A4F00);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isFlipping ? 0.65 : 1.0,
      child: Container(
        height: AppDimens.buttonHeight,
        decoration: BoxDecoration(
          gradient: AppColors.goldGradient,
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
          boxShadow: !_isFlipping
              ? [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.45),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isFlipping ? null : _startFlip,
            borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isFlipping)
                    AnimatedBuilder(
                      animation: _spinAnim,
                      builder: (_, child) => Transform.rotate(
                        angle: _spinAnim.value * 2 * pi * 5,
                        child: child,
                      ),
                      child: const Icon(Icons.refresh_rounded,
                          color: darkGold, size: 20),
                    )
                  else
                    const Icon(Icons.refresh_rounded,
                        color: darkGold, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.actionFlip,
                    style: const TextStyle(
                      color: darkGold,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final headsCount = widget.history.where((h) => h).length;
    final tailsCount = widget.history.where((h) => !h).length;

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── GlassCard label header ──
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.monetization_on_outlined,
                      size: 18, color: AppColors.gold),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.coinFlipTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ── Coin with glow pulse ──
            SizedBox(
              height: 190,
              child: Center(
                child: SizedBox(
                  width: _coinSize,
                  height: _coinSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Idle glow pulse
                      if (!_isFlipping)
                        AnimatedBuilder(
                          animation: _glowAnim,
                          builder: (_, _) => Container(
                            width: _coinSize,
                            height: _coinSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold
                                      .withValues(alpha: _glowAnim.value),
                                  blurRadius: 28,
                                  spreadRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Static coin (not flipping)
                      Opacity(
                        opacity: _isFlipping ? 0.0 : 1.0,
                        child: _ResultBounce(
                          resultKey:
                              _flipDoneCount > 0 ? _flipDoneCount : null,
                          child: _buildCoinFace(widget.coin),
                        ),
                      ),
                      // Flipping coin animation
                      if (_isFlipping)
                        AnimatedBuilder(
                          animation: _spinAnim,
                          builder: (_, _) {
                            final t = _spinAnim.value * _totalHalfTurns;
                            final halfTurn =
                                t.floor().clamp(0, _totalHalfTurns - 1);
                            final phase = t - t.floor();
                            final scaleX =
                                halfTurn.isEven ? (1.0 - phase) : phase;
                            final face = (halfTurn == _totalHalfTurns - 1)
                                ? widget.coin
                                : _halfTurnFaces[halfTurn];
                            return Transform.scale(
                              scaleX: scaleX.clamp(0.0, 1.0),
                              child: _buildCoinFace(face),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // ── Recent results ──
            if (widget.history.isNotEmpty) ...[
              const SizedBox(height: 16),
              SectionLabel(text: l10n.statsRecentResults),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.history.map((h) {
                    final chipColor =
                        h ? AppColors.gold : const Color(0xFF8B9DB0);
                    return Container(
                      width: 30,
                      height: 30,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: chipColor.withValues(alpha: 0.25),
                        border: Border.all(
                          color: chipColor.withValues(alpha: 0.55),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          h ? l10n.coinHeads : l10n.coinTails,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: chipColor,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              // Stats summary
              Text(
                '${l10n.coinHeads} $headsCount · ${l10n.coinTails} $tailsCount · ${widget.history.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (widget.fullscreen)
              const Spacer()
            else
              const SizedBox(height: 20),
            // ── Flip button (gold gradient + spinning icon) ──
            SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeight,
              child: _buildFlipButton(l10n),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 주사위 카드 (D6 고정 + 감속 카운터 애니메이션) ───────────────────────
class _DiceCard extends StatefulWidget {
  final int? result;
  final List<Map<String, int>> history;
  final VoidCallback onRoll;
  final int selectedType;
  final ValueChanged<int> onTypeChanged;
  final bool fullscreen;

  const _DiceCard({
    required this.result,
    required this.history,
    required this.onRoll,
    required this.selectedType,
    required this.onTypeChanged,
    this.fullscreen = false,
  });

  @override
  State<_DiceCard> createState() => _DiceCardState();
}

class _DiceCardState extends State<_DiceCard> {
  // 감속 딜레이 목록 (ms) — 총 10틱
  static const _rollDelays = [35, 35, 40, 50, 65, 80, 100, 125, 155, 190];

  int? _displayResult;
  bool _isRolling = false;
  int _rollDoneCount = 0;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _startRoll() {
    widget.onRoll();
    setState(() {
      _isRolling = true;
      _displayResult = Random().nextInt(widget.selectedType) + 1;
    });
    _scheduleRollTick(0);
  }

  void _scheduleRollTick(int tick) {
    if (_disposed) return;
    Timer(Duration(milliseconds: _rollDelays[tick]), () {
      if (_disposed) return;
      final nextVal = Random().nextInt(widget.selectedType) + 1;
      if (tick + 1 < _rollDelays.length) {
        setState(() => _displayResult = nextVal);
        _scheduleRollTick(tick + 1);
      } else {
        setState(() {
          _isRolling = false;
          _displayResult = null;
          _rollDoneCount++;
        });
      }
    });
  }

  // ── 다면체 이름 매핑 ──
  static const _polyhedraTypes = [4, 6, 8, 10, 12, 20];

  String _polyhedraName(AppLocalizations l10n, int type) {
    return switch (type) {
      4 => l10n.diceD4Name,
      6 => l10n.diceD6Name,
      8 => l10n.diceD8Name,
      10 => l10n.diceD10Name,
      12 => l10n.diceD12Name,
      20 => l10n.diceD20Name,
      _ => 'D$type',
    };
  }

  Widget _buildDiceFace(int? result, Color accentColor, ColorScheme cs,
      {bool rolling = false}) {
    final isD6 = widget.selectedType == 6;

    if (result == null) {
      // ── 빈 상태 ──
      if (isD6) {
        return Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: cs.outlineVariant.withValues(alpha: 0.70),
              width: 2.0,
            ),
          ),
          child: Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: cs.onSurfaceVariant.withValues(alpha: 0.45),
              ),
            ),
          ),
        );
      }
      // 비-D6 빈 상태: 원형 GlassCard
      return _buildNonD6Visual(null, accentColor, cs, rolling: false);
    }

    // ── D6: CustomPainter (기존) ──
    if (isD6) {
      return Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: rolling ? 0.10 : 0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: CustomPaint(
          size: const Size(130, 130),
          painter: _DiceFacePainter(
              value: result, color: accentColor, rolling: rolling),
        ),
      );
    }

    // ── 비-D6: 원형 GlassCard 숫자 표시 ──
    return _buildNonD6Visual(result, accentColor, cs, rolling: rolling);
  }

  Widget _buildNonD6Visual(int? result, Color accentColor, ColorScheme cs,
      {bool rolling = false}) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentColor.withValues(alpha: rolling ? 0.14 : 0.22),
        border: Border.all(
          color: accentColor.withValues(alpha: rolling ? 0.45 : 0.80),
          width: 2.5,
        ),
        boxShadow: result != null && !rolling
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            result != null ? '$result' : '?',
            style: TextStyle(
              fontSize: result != null ? 48 : 44,
              fontWeight: FontWeight.w900,
              color: result != null
                  ? accentColor.withValues(alpha: rolling ? 0.50 : 1.0)
                  : cs.onSurfaceVariant.withValues(alpha: 0.45),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'D${widget.selectedType}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accentColor.withValues(alpha: 0.6),
              letterSpacing: 0.5,
            ),
          ),
          Text(
            _polyhedraName(l10n, widget.selectedType),
            style: TextStyle(
              fontSize: 9,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    const accentColor = Color(0xFFAB47BC);

    final shownResult = _isRolling ? _displayResult : widget.result;

    return Container(
      decoration: _cardDecoration(accentColor, cs.surface),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ──
            _cardHeader(
                context, Icons.casino_outlined, l10n.diceTitle, accentColor),
            const SizedBox(height: 12),

            // ── 다면체 선택 칩 행 ──
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _polyhedraTypes.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final type = _polyhedraTypes[index];
                  final selected = type == widget.selectedType;
                  return GestureDetector(
                    onTap: _isRolling
                        ? null
                        : () => widget.onTypeChanged(type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xFFAB47BC), Color(0xFF8E24AA)],
                              )
                            : null,
                        color: selected
                            ? null
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : Colors.white.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'D$type',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w500,
                            color: selected
                                ? Colors.white
                                : cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // ── 주사위 뷰잉 ──
            SizedBox(
              height: 160,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ResultBounce(
                      resultKey: _rollDoneCount,
                      child: _buildDiceFace(
                        shownResult, accentColor, cs,
                        rolling: _isRolling,
                      ),
                    ),
                    if (!_isRolling && widget.result != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.diceRange(widget.selectedType),
                        style: TextStyle(
                          fontSize: 12,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── 히스토리 (뷰잉과 버튼 사이) ──
            if (widget.history.isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(color: accentColor.withValues(alpha: 0.2)),
              const SizedBox(height: 8),
              _historyRow(
                widget.history
                    .map((h) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: accentColor.withValues(alpha: 0.35),
                                width: 1),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'D${h['type']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: accentColor.withValues(alpha: 0.65),
                                  ),
                                ),
                                TextSpan(
                                  text: ' · ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: accentColor.withValues(alpha: 0.4),
                                  ),
                                ),
                                TextSpan(
                                  text: '${h['result']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                l10n.recent10,
                context,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.fullscreen)
              const Spacer()
            else
              const SizedBox(height: 20),

            // ── 버튼 (항상 최하단) ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _PremiumButton(
                onPressed: _isRolling ? null : _startRoll,
                icon: Icons.casino_rounded,
                label: l10n.rollDice(widget.selectedType),
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── D6 눈 CustomPainter ─────────────────────────────────────
class _DiceFacePainter extends CustomPainter {
  final int value;
  final Color color;
  final bool rolling;

  const _DiceFacePainter({
    required this.value,
    required this.color,
    this.rolling = false,
  });

  // 눈 위치 (0.0~1.0 비율)
  static const _dots = <int, List<Offset>>{
    1: [Offset(0.50, 0.50)],
    2: [Offset(0.72, 0.28), Offset(0.28, 0.72)],
    3: [Offset(0.72, 0.28), Offset(0.50, 0.50), Offset(0.28, 0.72)],
    4: [
      Offset(0.28, 0.28),
      Offset(0.72, 0.28),
      Offset(0.28, 0.72),
      Offset(0.72, 0.72)
    ],
    5: [
      Offset(0.28, 0.28),
      Offset(0.72, 0.28),
      Offset(0.50, 0.50),
      Offset(0.28, 0.72),
      Offset(0.72, 0.72)
    ],
    6: [
      Offset(0.28, 0.25),
      Offset(0.72, 0.25),
      Offset(0.28, 0.50),
      Offset(0.72, 0.50),
      Offset(0.28, 0.75),
      Offset(0.72, 0.75)
    ],
  };

  @override
  void paint(Canvas canvas, Size size) {
    final bgAlpha = rolling ? 0.14 : 0.26;
    final bgColor = color.withValues(alpha: bgAlpha);
    final borderColor = color.withValues(alpha: rolling ? 0.45 : 0.85);
    final dotColor = color.withValues(alpha: rolling ? 0.50 : 1.0);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24),
    );

    // 배경
    canvas.drawRRect(rrect, Paint()..color = bgColor);
    // 테두리 (강화: alpha 0.45→0.85, strokeWidth 1.5→2.5)
    canvas.drawRRect(
        rrect,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5);

    // 눈
    final positions = _dots[value.clamp(1, 6)] ?? [];
    final dotRadius = size.width * 0.09;
    for (final pos in positions) {
      canvas.drawCircle(
        Offset(pos.dx * size.width, pos.dy * size.height),
        dotRadius,
        Paint()..color = dotColor,
      );
    }
  }

  @override
  bool shouldRepaint(_DiceFacePainter old) =>
      old.value != value ||
      old.color != color ||
      old.rolling != rolling;
}

// ── 랜덤 숫자 카드 (StatefulWidget + 감속 카운터 애니메이션) ──────────
class _NumberCard extends StatefulWidget {
  final TextEditingController minCtrl;
  final TextEditingController maxCtrl;
  final int? result;
  final List<Map<String, int>> history;
  final VoidCallback onGenerate;
  final bool fullscreen;

  const _NumberCard({
    required this.minCtrl,
    required this.maxCtrl,
    required this.result,
    required this.history,
    required this.onGenerate,
    this.fullscreen = false,
  });

  @override
  State<_NumberCard> createState() => _NumberCardState();
}

class _NumberCardState extends State<_NumberCard> {
  // 감속 딜레이 목록 (ms) — 총 12틱
  static const _genDelays = [30, 30, 35, 45, 58, 72, 90, 110, 135, 165, 200, 240];

  int? _displayResult;
  bool _isGenerating = false;
  int _genDoneCount = 0;
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _startGenerate() {
    final min = int.tryParse(widget.minCtrl.text.trim()) ?? 1;
    final max = int.tryParse(widget.maxCtrl.text.trim()) ?? 100;
    if (min >= max) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.minMaxError)),
      );
      return;
    }
    widget.onGenerate(); // 즉시 부모 상태 갱신
    setState(() {
      _isGenerating = true;
      _displayResult = min + Random().nextInt(max - min + 1);
    });
    _scheduleGenTick(min, max, 0);
  }

  void _scheduleGenTick(int min, int max, int tick) {
    if (_disposed) return;
    Timer(Duration(milliseconds: _genDelays[tick]), () {
      if (_disposed) return;
      final nextVal = min + Random().nextInt(max - min + 1);
      if (tick + 1 < _genDelays.length) {
        setState(() => _displayResult = nextVal);
        _scheduleGenTick(min, max, tick + 1);
      } else {
        setState(() {
          _isGenerating = false;
          _displayResult = null;
          _genDoneCount++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    const accentColor = Color(0xFF42A5F5);

    final shownResult = _isGenerating ? _displayResult : widget.result;

    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
          BorderSide(color: accentColor.withValues(alpha: 0.35), width: 1),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: accentColor, width: 2),
    );

    return Container(
      decoration: _cardDecoration(accentColor, cs.surface),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ──
            _cardHeader(context, Icons.tag_rounded,
                l10n.randomNumberTitle, accentColor),
            const SizedBox(height: 16),
            // ── min / max 입력 — 생성 중 비활성 ──
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.minCtrl,
                    enabled: !_isGenerating,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      labelText: l10n.minLabel,
                      isDense: true,
                      filled: true,
                      fillColor:
                          accentColor.withValues(alpha: 0.10),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: focusedBorder,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: accentColor.withValues(alpha: 0.55),
                    size: 20,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: widget.maxCtrl,
                    enabled: !_isGenerating,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      labelText: l10n.maxLabel,
                      isDense: true,
                      filled: true,
                      fillColor:
                          accentColor.withValues(alpha: 0.10),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: focusedBorder,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ── 숫자 뷰잉 (항상 고정 144px) ──
            SizedBox(
              height: 144,
              child: Center(
                child: _ResultBounce(
                  resultKey: _genDoneCount,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 18),
                    decoration: BoxDecoration(
                      color: shownResult != null
                          ? accentColor.withValues(
                              alpha: _isGenerating ? 0.12 : 0.22)
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: shownResult != null
                            ? accentColor.withValues(
                                alpha: _isGenerating ? 0.35 : 0.80)
                            : cs.outlineVariant.withValues(alpha: 0.70),
                        width: 2.0,
                      ),
                      boxShadow: shownResult != null && !_isGenerating
                          ? [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.20),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                          : [],
                    ),
                    child: Text(
                      shownResult != null ? '$shownResult' : '?',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: shownResult != null
                            ? accentColor.withValues(
                                alpha: _isGenerating ? 0.45 : 1.0)
                            : cs.onSurfaceVariant.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── 히스토리 (뷰잉과 버튼 사이) ──
            if (widget.history.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(color: accentColor.withValues(alpha: 0.2)),
              const SizedBox(height: 8),
              _historyRow(
                widget.history
                    .map((h) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 5),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(
                                alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: accentColor.withValues(alpha: 0.35),
                                width: 1),
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${h['min']}~${h['max']} ',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: cs.onSurfaceVariant
                                        .withValues(alpha: 0.65),
                                  ),
                                ),
                                TextSpan(
                                  text: '${h['result']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: accentColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
                l10n.recent10,
                context,
              ),
              const SizedBox(height: 8),
            ],
            if (widget.fullscreen) const Spacer() else const SizedBox(height: 20),
            // ── 버튼 (항상 최하단) ──
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _PremiumButton(
                onPressed: _isGenerating ? null : _startGenerate,
                icon: Icons.shuffle_rounded,
                label: l10n.actionGenerate,
                color: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 공통 액션 버튼 (pulse glow) ──────────────────────────────────────────

class _PremiumButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color color;

  const _PremiumButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  State<_PremiumButton> createState() => _PremiumButtonState();
}

/// 3D 아케이드 버튼 (tools 카드용) — _PremiumSpinButton 과 동일한 스타일
class _PremiumButtonState extends State<_PremiumButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;
    final color = isDisabled
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25)
        : widget.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isPressed ? 4.0 : 0.0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Color.lerp(color, Colors.white, isDisabled ? 0.0 : 0.22)!,
              color,
              Color.lerp(color, Colors.black, isDisabled ? 0.0 : 0.30)!,
            ],
            stops: const [0.0, 0.42, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: isDisabled
              ? []
              : [
                  BoxShadow(
                    color: Color.lerp(color, Colors.black, 0.55)!
                        .withValues(alpha: 0.75),
                    blurRadius: 0,
                    offset: Offset(0, _isPressed ? 1.0 : 5.0),
                  ),
                  BoxShadow(
                    color: color.withValues(alpha: 0.20),
                    blurRadius: 10,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon,
                  color: isDisabled
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4)
                      : Colors.white,
                  size: 20),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: isDisabled
                      ? Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.4)
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 결과 바운스 애니메이션 ────────────────────────────────────
class _ResultBounce extends StatefulWidget {
  final Widget child;
  final dynamic resultKey;

  const _ResultBounce({required this.child, required this.resultKey});

  @override
  State<_ResultBounce> createState() => _ResultBounceState();
}

class _ResultBounceState extends State<_ResultBounce>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.06), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.06, end: 1.0), weight: 40),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    // 초기 스케일 1.0 → 애니메이션 전후 크기 통일
    _ctrl.value = 1.0;
  }

  @override
  void didUpdateWidget(_ResultBounce oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.resultKey != oldWidget.resultKey && widget.resultKey != null) {
      _ctrl.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scale, child: widget.child);
  }
}
