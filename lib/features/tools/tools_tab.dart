import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
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

  // ── 주사위 상태 (D6 고정) ─────────────────────────────
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
    final r = Random().nextInt(6) + 1;
    setState(() {
      _diceResult = r;
      _diceHistory.insert(0, {'type': 6, 'result': r});
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
      if (_numHistory.length > 20) _numHistory.removeLast();
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        if (so == null || so == 'coin')
          _CoinCard(coin: _coin, history: _coinHistory, onFlip: _flipCoin),
        if (so == null) const SizedBox(height: 14),
        if (so == null || so == 'dice')
          _DiceCard(
            result: _diceResult,
            history: _diceHistory,
            onRoll: _rollDice,
          ),
        if (so == null) const SizedBox(height: 14),
        if (so == null || so == 'number')
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
BoxDecoration _cardDecoration(
    Color accentColor, Color surface, bool isDark) {
  return BoxDecoration(
    color: Color.lerp(surface, accentColor, isDark ? 0.11 : 0.06),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: accentColor.withValues(alpha: isDark ? 0.50 : 0.35),
      width: 1.5,
    ),
  );
}

// 아이콘 배지 헤더 위젯
Widget _cardHeader(
    BuildContext context, IconData icon, String title, Color color, bool isDark) {
  return Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: isDark ? 0.22 : 0.15),
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

  const _CoinCard(
      {required this.coin, required this.history, required this.onFlip});

  @override
  State<_CoinCard> createState() => _CoinCardState();
}

class _CoinCardState extends State<_CoinCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;
  bool? _prevCoin;

  @override
  void initState() {
    super.initState();
    _prevCoin = widget.coin;
    _flipCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_CoinCard old) {
    super.didUpdateWidget(old);
    if (old.coin != widget.coin && widget.coin != null) {
      _prevCoin = old.coin;
      _flipCtrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  Widget _buildCoinFace(bool? isHeads, ColorScheme cs, AppLocalizations l10n) {
    if (isHeads == null) {
      return Container(
        width: 114,
        height: 114,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cs.surfaceContainerHighest,
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.5),
            width: 2.5,
          ),
        ),
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: cs.onSurfaceVariant.withValues(alpha: 0.45),
            ),
          ),
        ),
      );
    }

    // 앞면: 골드 메탈릭 / 뒷면: 실버 메탈릭
    final isH = isHeads;
    final topColor =
        isH ? const Color(0xFFFFD700) : const Color(0xFFDDDDEE);
    final botColor =
        isH ? const Color(0xFFCC8800) : const Color(0xFF9898B0);
    final glowColor = isH ? Colors.amber : Colors.blueGrey;
    final embossColor =
        isH ? const Color(0xFF7A4800) : const Color(0xFF3A3A5A);

    return Container(
      width: 114,
      height: 114,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [topColor, botColor],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 상단 광택 반원
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              width: 32,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.30),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          // 중앙 엠보싱 아이콘
          Icon(
            isH ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            size: 38,
            color: embossColor.withValues(alpha: 0.70),
          ),
          // 외곽 테두리 링
          Container(
            width: 114,
            height: 114,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.22),
                width: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    const accentColor = Color(0xFFF5C04A);

    return Container(
      decoration: _cardDecoration(accentColor, cs.surface, isDark),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── 헤더 ──
            _cardHeader(context, Icons.monetization_on_outlined,
                l10n.coinFlipTitle, accentColor, isDark),
            const SizedBox(height: 24),
            // ── 코인 (3D 플립 애니메이션) ──
            AnimatedBuilder(
              animation: _flipAnim,
              builder: (_, _) {
                final t = _flipAnim.value;
                final double scaleX;
                final bool? displayCoin;
                if (t < 0.5) {
                  scaleX = 1.0 - t * 2;
                  displayCoin = _prevCoin;
                } else {
                  scaleX = (t - 0.5) * 2;
                  displayCoin = widget.coin;
                }
                return Transform.scale(
                  scaleX: scaleX.clamp(0.0, 1.0),
                  child: _buildCoinFace(displayCoin, cs, l10n),
                );
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _PremiumButton(
                onPressed: widget.onFlip,
                icon: Icons.flip,
                label: l10n.actionFlip,
                color: accentColor,
              ),
            ),
            // ── 히스토리 ──
            if (widget.history.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(color: accentColor.withValues(alpha: 0.2)),
              const SizedBox(height: 8),
              _historyRow(
                widget.history.map((h) {
                  final hColor = h
                      ? const Color(0xFFFFD700)
                      : const Color(0xFFB0B0C0);
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(
                      color: hColor.withValues(alpha: isDark ? 0.22 : 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: hColor.withValues(alpha: 0.45), width: 1),
                    ),
                    child: Text(
                      h ? l10n.coinHeads : l10n.coinTails,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? hColor.withValues(alpha: 0.9)
                            : hColor.withValues(alpha: 0.80),
                      ),
                    ),
                  );
                }).toList(),
                l10n.recent10,
                context,
              ),
            ],
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

  const _DiceCard({
    required this.result,
    required this.history,
    required this.onRoll,
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
      _displayResult = Random().nextInt(6) + 1;
    });
    _scheduleRollTick(0);
  }

  void _scheduleRollTick(int tick) {
    if (_disposed) return;
    Timer(Duration(milliseconds: _rollDelays[tick]), () {
      if (_disposed) return;
      final nextVal = Random().nextInt(6) + 1;
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

  Widget _buildDiceFace(int? result, Color accentColor, ColorScheme cs,
      bool isDark, {bool rolling = false}) {
    if (result == null) {
      return Container(
        width: 128,
        height: 128,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: cs.outlineVariant.withValues(alpha: 0.35),
            width: 1.5,
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

    return Container(
      width: 128,
      height: 128,
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
        size: const Size(128, 128),
        painter: _DiceFacePainter(
            value: result, color: accentColor, isDark: isDark, rolling: rolling),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    const accentColor = Color(0xFFAB47BC);

    final shownResult = _isRolling ? _displayResult : widget.result;

    return Container(
      decoration: _cardDecoration(accentColor, cs.surface, isDark),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ──
            _cardHeader(context, Icons.casino_outlined,
                l10n.diceTitle, accentColor, isDark),
            const SizedBox(height: 20),
            Center(
              child: _ResultBounce(
                resultKey: _rollDoneCount,
                child: _buildDiceFace(
                  shownResult, accentColor, cs, isDark,
                  rolling: _isRolling,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: _PremiumButton(
                onPressed: _isRolling ? null : _startRoll,
                icon: Icons.casino_rounded,
                label: l10n.rollDice(6),
                color: accentColor,
              ),
            ),
            // ── 히스토리 ──
            if (widget.history.isNotEmpty) ...[
              const SizedBox(height: 16),
              Divider(color: accentColor.withValues(alpha: 0.2)),
              const SizedBox(height: 8),
              _historyRow(
                widget.history
                    .map((h) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(
                                alpha: isDark ? 0.18 : 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: accentColor.withValues(alpha: 0.35),
                                width: 1),
                          ),
                          child: Text(
                            '${h['result']}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                        ))
                    .toList(),
                l10n.recent10,
                context,
              ),
            ],
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
  final bool isDark;
  final bool rolling;

  const _DiceFacePainter({
    required this.value,
    required this.color,
    required this.isDark,
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
    final bgAlpha = rolling
        ? (isDark ? 0.12 : 0.08)
        : (isDark ? 0.22 : 0.15);
    final bgColor = color.withValues(alpha: bgAlpha);
    final borderColor = color.withValues(alpha: rolling ? 0.25 : 0.45);
    final dotColor = color.withValues(alpha: rolling ? 0.40 : 1.0);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(24),
    );

    // 배경
    canvas.drawRRect(rrect, Paint()..color = bgColor);
    // 테두리
    canvas.drawRRect(
        rrect,
        Paint()
          ..color = borderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

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
      old.isDark != isDark ||
      old.rolling != rolling;
}

// ── 랜덤 숫자 카드 (StatefulWidget + 감속 카운터 애니메이션) ──────────
class _NumberCard extends StatefulWidget {
  final TextEditingController minCtrl;
  final TextEditingController maxCtrl;
  final int? result;
  final List<Map<String, int>> history;
  final VoidCallback onGenerate;

  const _NumberCard({
    required this.minCtrl,
    required this.maxCtrl,
    required this.result,
    required this.history,
    required this.onGenerate,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
      decoration: _cardDecoration(accentColor, cs.surface, isDark),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ──
            _cardHeader(context, Icons.tag_rounded,
                l10n.randomNumberTitle, accentColor, isDark),
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
                          accentColor.withValues(alpha: isDark ? 0.10 : 0.06),
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
                          accentColor.withValues(alpha: isDark ? 0.10 : 0.06),
                      border: inputBorder,
                      enabledBorder: inputBorder,
                      focusedBorder: focusedBorder,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Center(
              child: _ResultBounce(
                resultKey: _genDoneCount,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  decoration: BoxDecoration(
                    color: shownResult != null
                        ? accentColor.withValues(
                            alpha: _isGenerating
                                ? (isDark ? 0.12 : 0.08)
                                : (isDark ? 0.22 : 0.15))
                        : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: shownResult != null
                          ? accentColor.withValues(
                              alpha: _isGenerating ? 0.25 : 0.45)
                          : cs.outlineVariant.withValues(alpha: 0.35),
                      width: 1.5,
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
            const SizedBox(height: 18),
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
            // ── 히스토리 ──
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
                                alpha: isDark ? 0.18 : 0.11),
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
                l10n.recent20,
                context,
              ),
            ],
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
