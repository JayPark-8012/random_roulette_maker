import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../core/design_tokens.dart';
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
      return card;
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
  static const double _coinSize = 200.0;

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
      return SizedBox(
        width: _coinSize,
        height: _coinSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 외부 글로우
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB800).withValues(alpha: 0.10),
                    blurRadius: 50,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            // 외곽 링
            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            // 내부
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            // 물음표
            Center(
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
            ),
            // 테두리 링
            Container(
              width: 190,
              height: 190,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final isH = isHeads;
    final glowColor = isH
        ? const Color(0xFFFFB800)
        : const Color(0xFF8B9DB0);
    final outerGradient = isH
        ? const RadialGradient(
            colors: [Color(0xFFFFD93D), Color(0xFFFF9500)],
            stops: [0.0, 1.0],
          )
        : const RadialGradient(
            colors: [Color(0xFFC8D0DC), Color(0xFF8B9DB0)],
            stops: [0.0, 1.0],
          );
    final innerGradient = isH
        ? const RadialGradient(
            center: Alignment(-0.3, -0.3),
            colors: [Color(0xFFFFE566), Color(0xFFCC7700)],
          )
        : const RadialGradient(
            center: Alignment(-0.3, -0.3),
            colors: [Color(0xFFD4DCE8), Color(0xFF6B7D90)],
          );
    const textColor = Color(0xFF7A4500);
    const silverTextColor = Color(0xFF3A4A5C);

    return SizedBox(
      width: _coinSize,
      height: _coinSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 레이어1 — 외부 글로우
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.2),
                  blurRadius: 50,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          // 레이어2 — 코인 외곽 링
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: outerGradient,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.6),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          // 레이어3 — 코인 내부
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: innerGradient,
            ),
          ),
          // 레이어4 — 앞/뒤 텍스트
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isH ? '👑' : '✦',
                  style: const TextStyle(fontSize: 32),
                ),
                Text(
                  isH ? '앞' : '뒤',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isH ? textColor : silverTextColor,
                  ),
                ),
              ],
            ),
          ),
          // 레이어5 — 코인 테두리 링
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFFFB800).withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipButton(AppLocalizations l10n) {
    const textColor = Color(0xFF3D2000);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isFlipping ? 0.65 : 1.0,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFCC8800), Color(0xFFFFB800)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: !_isFlipping
              ? [
                  BoxShadow(
                    color: const Color(0xFFFFB800).withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isFlipping ? null : _startFlip,
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withValues(alpha: 0.15),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Center(
              child: Text(
                '🪙 뒤집기',
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
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

    return SafeArea(
      top: false,
      bottom: true,
      child: Column(
      children: [
        // ── 메인 박스 ──
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1628),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFFB800).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // ── 헤더 ──
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
                const SizedBox(height: 16),
                // ── Coin with glow pulse (Expanded 중앙) ──
                Expanded(
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
                                      color: const Color(0xFFFFB800)
                                          .withValues(alpha: _glowAnim.value * 0.5),
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
                // ── 결과 통계 ──
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141D35),
                          border: Border.all(
                            color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l10n.coinHeads,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFB800).withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$headsCount',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141D35),
                          border: Border.all(
                            color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l10n.coinTails,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFB800).withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$tailsCount',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141D35),
                          border: Border.all(
                            color: const Color(0xFFFFB800).withValues(alpha: 0.12),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '총',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFB800).withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.history.length}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ── Flip button ──
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: _buildFlipButton(l10n),
                ),
              ],
            ),
          ),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const accentColor = Color(0xFF00D4FF);

    final shownResult = _isRolling ? _displayResult : widget.result;

    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1C30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D4FF).withValues(alpha: 0.15),
            blurRadius: 20,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 헤더 ──
            _cardHeader(
                context, Icons.casino_outlined, l10n.diceTitle, accentColor),
            const SizedBox(height: 12),

            // ── 다면체 선택 버튼 행 ──
            Row(
              children: _polyhedraTypes.asMap().entries.map((entry) {
                final index = entry.key;
                final type = entry.value;
                final selected = type == widget.selectedType;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 3,
                        right: index == _polyhedraTypes.length - 1 ? 0 : 3),
                    child: GestureDetector(
                      onTap: _isRolling
                          ? null
                          : () => widget.onTypeChanged(type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF00D4FF)
                              : const Color(0xFF0E1628),
                          borderRadius: BorderRadius.circular(10),
                          border: selected
                              ? null
                              : Border.all(
                                  color: const Color(0xFFFFFFFF)
                                      .withValues(alpha: 0.1),
                                  width: 1,
                                ),
                        ),
                        child: Center(
                          child: Text(
                            'D$type',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                              color: selected
                                  ? const Color(0xFF070B14)
                                  : const Color(0xFFFFFFFF)
                                      .withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── 주사위 뷰잉 ──
            SizedBox(
              height: 220,
              child: Center(
                child: _ResultBounce(
                  resultKey: _rollDoneCount,
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 외부 글로우
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00D4FF)
                                    .withValues(alpha: _isRolling ? 0.35 : 0.2),
                                blurRadius: 40,
                                spreadRadius: 8,
                              ),
                            ],
                          ),
                        ),
                        // 다각형
                        CustomPaint(
                          size: const Size(200, 200),
                          painter: _DiceShapePainter(
                            sides: widget.selectedType,
                            fillColor: const Color(0xFF0F1C30),
                            borderColor: const Color(0xFF00D4FF)
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        // 숫자 + 라벨
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              shownResult != null ? '$shownResult' : '?',
                              style: TextStyle(
                                fontSize: 52,
                                fontWeight: FontWeight.w900,
                                color: shownResult != null
                                    ? const Color(0xFF00D4FF).withValues(
                                        alpha: _isRolling ? 0.5 : 1.0)
                                    : const Color(0xFFFFFFFF)
                                        .withValues(alpha: 0.3),
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'D${widget.selectedType}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00D4FF)
                                    .withValues(alpha: 0.45),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
            GestureDetector(
              onTap: _isRolling ? null : _startRoll,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isRolling ? 0.45 : 1.0,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
                    ),
                    boxShadow: _isRolling
                        ? []
                        : [
                            BoxShadow(
                              color: const Color(0xFF00D4FF)
                                  .withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.casino_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.rollDice(widget.selectedType),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

// ── 다각형 주사위 모양 CustomPainter ────────────────────────────
class _DiceShapePainter extends CustomPainter {
  final int sides;
  final Color fillColor;
  final Color borderColor;

  _DiceShapePainter({
    required this.sides,
    required this.fillColor,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.46;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final int vertexCount = switch (sides) {
      4 => 3,
      6 => 4,
      8 => 4,
      10 => 5,
      12 => 5,
      20 => 6,
      _ => 6,
    };

    final double startAngle = switch (sides) {
      4 => -pi / 2,
      6 => -pi / 4,
      8 => 0,
      10 => -pi / 2,
      12 => -pi / 2,
      20 => 0,
      _ => 0,
    };

    final path = Path();
    for (int i = 0; i < vertexCount; i++) {
      final angle = startAngle + (2 * pi * i / vertexCount);
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_DiceShapePainter old) =>
      old.sides != sides ||
      old.fillColor != fillColor ||
      old.borderColor != borderColor;
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
    final l10n = AppLocalizations.of(context)!;
    const accent = Color(0xFF00D4FF);

    final shownResult = _isGenerating ? _displayResult : widget.result;
    final minText = widget.minCtrl.text.trim().isEmpty ? '1' : widget.minCtrl.text.trim();
    final maxText = widget.maxCtrl.text.trim().isEmpty ? '100' : widget.maxCtrl.text.trim();

    return SafeArea(
      top: false,
      bottom: true,
      child: Column(
      children: [
        // ── 메인 박스 ──
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1628),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF00D4FF).withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                // ── 헤더 ──
                Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '#',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '랜덤 숫자',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // ── 입력 필드 (최솟값 / → / 최댓값) ──
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1628),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l10n.minLabel,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: accent.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: widget.minCtrl,
                              enabled: !_isGenerating,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accent,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward,
                        color: accent.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1628),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              l10n.maxLabel,
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: accent.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: widget.maxCtrl,
                              enabled: !_isGenerating,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: accent,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // ── 결과 숫자 (Expanded 중앙) ──
                Expanded(
                  child: Center(
                    child: _ResultBounce(
                      resultKey: _genDoneCount,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 150),
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.w900,
                              color: shownResult != null
                                  ? Colors.white.withValues(
                                      alpha: _isGenerating ? 0.45 : 1.0)
                                  : Colors.white.withValues(alpha: 0.25),
                              height: 1.0,
                            ),
                            child: Text(
                              shownResult != null ? '$shownResult' : '?',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$minText ~ $maxText 사이',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: accent.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ── 최근 결과 히스토리 ──
                if (widget.history.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        l10n.recent10,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.history.map((h) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E1628),
                          border: Border.all(
                            color: accent.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${h['min']}~${h['max']} ',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: accent.withValues(alpha: 0.5),
                                ),
                              ),
                              TextSpan(
                                text: '${h['result']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 16),
                // ── 생성 버튼 ──
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isGenerating ? 0.65 : 1.0,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0284C7), Color(0xFF00D4FF)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: !_isGenerating
                            ? [
                                BoxShadow(
                                  color: accent.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isGenerating ? null : _startGenerate,
                          borderRadius: BorderRadius.circular(14),
                          splashColor: Colors.white.withValues(alpha: 0.15),
                          highlightColor: Colors.white.withValues(alpha: 0.05),
                          child: const Center(
                            child: Text(
                              '🎲 생성',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
