import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants.dart';
import '../../core/design_tokens.dart';
import '../../data/ad_service.dart';
import '../../data/local_storage.dart';
import '../../data/premium_service.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/slot_machine_display.dart';

// ── 사다리 상태 enum ──
enum LadderState { input, playing, result }

// ── 사다리 경로 모델 ──
class LadderPath {
  final int fromIndex;
  final int toIndex;
  final List<Offset> points;
  const LadderPath({
    required this.fromIndex,
    required this.toIndex,
    required this.points,
  });
}

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
        'ladder' => const _LadderCard(fullscreen: true),
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
        const SizedBox(height: 14),
        const _LadderCard(),
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
        AdService.instance.recordToolUse('coin');
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
            child: Builder(builder: (ctx) {
              final l10n = AppLocalizations.of(ctx)!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isH ? '👑' : '✦',
                    style: const TextStyle(fontSize: 32),
                  ),
                  Text(
                    isH ? l10n.coinFront : l10n.coinBack,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: isH ? textColor : silverTextColor,
                    ),
                  ),
                ],
              );
            }),
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
                l10n.coinFlipButton,
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
                              l10n.toolsStatTotal,
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

class _DiceCardState extends State<_DiceCard>
    with TickerProviderStateMixin {
  // 감속 딜레이 목록 (ms) — 총 10틱
  static const _rollDelays = [35, 35, 40, 50, 65, 80, 100, 125, 155, 190];
  static const _accent = AppColors.colorDice;

  int? _displayResult;
  bool _isRolling = false;
  bool _disposed = false;

  // ── 굴림 애니메이션 ──
  late AnimationController _rollCtrl;
  late Animation<double> _rollScale;
  late Animation<double> _rollRotate;

  // ── Idle 떠다니기 애니메이션 ──
  late AnimationController _idleCtrl;
  late Animation<double> _idleTranslateY;
  late Animation<double> _idleRotate;

  @override
  void initState() {
    super.initState();

    // Roll 애니메이션 (600ms)
    _rollCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rollScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.92), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.08), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 0.96), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.96, end: 1.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _rollCtrl, curve: Curves.easeInOut));
    _rollRotate = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: -0.26), weight: 30), // -15deg
      TweenSequenceItem(
          tween: Tween(begin: -0.26, end: 0.35), weight: 30), // +20deg
      TweenSequenceItem(
          tween: Tween(begin: 0.35, end: -0.17), weight: 20), // -10deg
      TweenSequenceItem(
          tween: Tween(begin: -0.17, end: -0.035), weight: 20), // -2deg
    ]).animate(CurvedAnimation(parent: _rollCtrl, curve: Curves.easeInOut));

    // Idle 애니메이션 (3s loop)
    _idleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _idleTranslateY = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _idleCtrl, curve: Curves.easeInOut),
    );
    _idleRotate = Tween<double>(begin: -0.035, end: 0.035).animate(
      CurvedAnimation(parent: _idleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _rollCtrl.dispose();
    _idleCtrl.dispose();
    super.dispose();
  }

  void _startRoll() {
    widget.onRoll();
    _idleCtrl.stop();
    setState(() {
      _isRolling = true;
      _displayResult = Random().nextInt(widget.selectedType) + 1;
    });
    _rollCtrl.forward(from: 0.0);
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
        });
        // 굴림 완료 → idle 시작
        _idleCtrl.repeat(reverse: true);
        AdService.instance.recordToolUse('dice');
      }
    });
  }

  // ── 다면체 이름 매핑 ──
  static const _polyhedraTypes = [4, 6, 8, 10, 12, 20];

  // ── D6 Pip 레이아웃 (3x3 그리드) ──
  static const _d6Pips = <int, List<bool>>{
    1: [false, false, false, false, true, false, false, false, false],
    2: [true, false, false, false, false, false, false, false, true],
    3: [true, false, false, false, true, false, false, false, true],
    4: [true, false, true, false, false, false, true, false, true],
    5: [true, false, true, false, true, false, true, false, true],
    6: [true, false, true, true, false, true, true, false, true],
  };

  Widget _buildD6Dice(int? result) {
    const diceSize = 160.0;
    final pips = _d6Pips[result] ?? _d6Pips[1]!;
    final pipSize = diceSize / 5;

    return Container(
      width: diceSize,
      height: diceSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9D88FF), Color(0xFF7B61FF), Color(0xFF4A35CC)],
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.50),
            blurRadius: 40,
          ),
          const BoxShadow(
            color: Color(0x80000000),
            offset: Offset(4, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 상단 하이라이트
          Positioned(
            top: 4,
            left: 20,
            right: 20,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1),
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
          ),
          // pip 그리드
          Center(
            child: SizedBox(
              width: diceSize * 0.65,
              height: diceSize * 0.65,
              child: GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(9, (i) {
                  if (!pips[i]) return const SizedBox.shrink();
                  return Center(
                    child: Container(
                      width: pipSize,
                      height: pipSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPolyhedraDice(int? result) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(200, 200),
            painter: _DiceShapePainter(sides: widget.selectedType),
          ),
          // 숫자
          Text(
            result != null ? '$result' : '?',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w800,
              color: result != null
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.3),
              height: 1.0,
              shadows: result != null
                  ? const [
                      Shadow(
                        color: Color(0x80000000),
                        offset: Offset(0, 2),
                        blurRadius: 12,
                      ),
                    ]
                  : null,
            ),
          ),
          // D라벨
          Positioned(
            bottom: 30,
            child: Text(
              'D${widget.selectedType}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _accent.withValues(alpha: 0.45),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final shownResult = _isRolling ? _displayResult : widget.result;
    final isD6 = widget.selectedType == 6;

    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1C30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accent.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.15),
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
                context, Icons.casino_outlined, l10n.diceTitle, _accent),
            const SizedBox(height: 12),

            // ── 다면체 선택 버튼 행 ──
            Row(
              children: _polyhedraTypes.asMap().entries.map((entry) {
                final index = entry.key;
                final type = entry.value;
                final selected = type == widget.selectedType;
                final isPremium = PremiumService.instance.isPremium;
                final locked = !PremiumService.canUseDiceType(
                    isPremium, 'D$type');
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: index == 0 ? 0 : 3,
                        right: index == _polyhedraTypes.length - 1 ? 0 : 3),
                    child: GestureDetector(
                      onTap: _isRolling
                          ? null
                          : () {
                              if (locked) {
                                Navigator.pushNamed(
                                    context, AppRoutes.paywall);
                                return;
                              }
                              _idleCtrl.stop();
                              _idleCtrl.reset();
                              widget.onTypeChanged(type);
                            },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 44,
                        decoration: BoxDecoration(
                          color: selected && !locked
                              ? _accent
                              : AppColors.bgCard,
                          borderRadius: BorderRadius.circular(10),
                          border: selected && !locked
                              ? null
                              : Border.all(
                                  color: const Color(0xFFFFFFFF)
                                      .withValues(alpha: 0.1),
                                  width: 1,
                                ),
                        ),
                        child: Opacity(
                          opacity: locked ? 0.4 : 1.0,
                          child: Stack(
                            children: [
                              Center(
                                child: Text(
                                  'D$type',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: selected && !locked
                                        ? FontWeight.w800
                                        : FontWeight.w600,
                                    color: selected && !locked
                                        ? const Color(0xFF070B14)
                                        : const Color(0xFFFFFFFF)
                                            .withValues(alpha: 0.45),
                                  ),
                                ),
                              ),
                              if (locked)
                                const Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Icon(Icons.lock,
                                      size: 10, color: Colors.white54),
                                ),
                            ],
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
                child: AnimatedBuilder(
                  animation: Listenable.merge([_rollCtrl, _idleCtrl]),
                  builder: (_, _) {
                    final scale = _isRolling
                        ? _rollScale.value
                        : 1.0;
                    final rotate = _isRolling
                        ? _rollRotate.value
                        : (_idleCtrl.isAnimating ? _idleRotate.value : 0.0);
                    final translateY =
                        _idleCtrl.isAnimating && !_isRolling
                            ? _idleTranslateY.value
                            : 0.0;

                    return Transform.translate(
                      offset: Offset(0, translateY),
                      child: Transform.rotate(
                        angle: rotate,
                        child: Transform.scale(
                          scale: scale,
                          child: isD6
                              ? _buildD6Dice(shownResult)
                              : _buildPolyhedraDice(shownResult),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── 히스토리 (뷰잉과 버튼 사이) ──
            if (widget.history.isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(color: _accent.withValues(alpha: 0.2)),
              const SizedBox(height: 8),
              _historyRow(
                widget.history
                    .map((h) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: _accent.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: _accent.withValues(alpha: 0.35),
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
                                    color: _accent.withValues(alpha: 0.65),
                                  ),
                                ),
                                TextSpan(
                                  text: ' · ',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: _accent.withValues(alpha: 0.4),
                                  ),
                                ),
                                TextSpan(
                                  text: '${h['result']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _accent,
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
                      colors: [Color(0xFF5B41CC), Color(0xFF7B61FF)],
                    ),
                    boxShadow: _isRolling
                        ? []
                        : [
                            BoxShadow(
                              color: _accent.withValues(alpha: 0.4),
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

// ── 다면체 주사위 CustomPainter (그래디언트 + facet + 글로우) ────────
class _DiceShapePainter extends CustomPainter {
  final int sides;

  _DiceShapePainter({required this.sides});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.44;
    const cornerRadius = 6.0;

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

    // 꼭짓점 계산
    final vertices = <Offset>[];
    for (int i = 0; i < vertexCount; i++) {
      final angle = startAngle + (2 * pi * i / vertexCount);
      vertices.add(Offset(cx + r * cos(angle), cy + r * sin(angle)));
    }

    // 라운드 처리된 Path
    final shapePath = Path();
    for (int i = 0; i < vertexCount; i++) {
      final prev = vertices[(i - 1 + vertexCount) % vertexCount];
      final curr = vertices[i];
      final next = vertices[(i + 1) % vertexCount];

      final toPrev = (prev - curr);
      final toNext = (next - curr);
      final lenPrev = toPrev.distance;
      final lenNext = toNext.distance;
      final cr = cornerRadius.clamp(0.0, min(lenPrev, lenNext) * 0.3);

      final p1 = curr + toPrev * (cr / lenPrev);
      final p2 = curr + toNext * (cr / lenNext);

      if (i == 0) {
        shapePath.moveTo(p1.dx, p1.dy);
      } else {
        shapePath.lineTo(p1.dx, p1.dy);
      }
      shapePath.quadraticBezierTo(curr.dx, curr.dy, p2.dx, p2.dy);
    }
    shapePath.close();

    // 글로우
    canvas.drawPath(
      shapePath,
      Paint()
        ..color = AppColors.colorDice.withValues(alpha: 0.6)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 16)
        ..style = PaintingStyle.fill,
    );

    // 그래디언트 채우기
    final bounds = shapePath.getBounds();
    canvas.drawPath(
      shapePath,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.3),
          colors: [Color(0xFF9D88FF), Color(0xFF4A35CC)],
        ).createShader(bounds)
        ..style = PaintingStyle.fill,
    );

    // 내부 facet 선 (중심 → 꼭짓점)
    final facetPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (final v in vertices) {
      canvas.drawLine(Offset(cx, cy), v, facetPaint);
    }

    // 테두리 하이라이트
    canvas.drawPath(
      shapePath,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.2)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_DiceShapePainter old) => old.sides != sides;
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
  static const _accent = AppColors.colorNumber;

  final _slotKey = GlobalKey<SlotMachineDisplayState>();
  bool _isSpinning = false;

  void _showProSnackBar() {
    final l10n = AppLocalizations.of(context)!;
    final nav = Navigator.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.numberProSnackbar),
        action: SnackBarAction(
          label: l10n.numberProSnackbarAction,
          onPressed: () => nav.pushNamed(AppRoutes.paywall),
        ),
        backgroundColor: AppColors.bgElevated,
        duration: const Duration(seconds: 3),
      ),
    );
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
    final isPremium = PremiumService.instance.isPremium;
    if (!PremiumService.isNumberRangeAllowed(isPremium, max)) {
      _showProSnackBar();
      return;
    }
    widget.onGenerate(); // 부모 상태 갱신 (result + history)
    setState(() => _isSpinning = true);

    // 부모 setState 반영 후 widget.result 로 스핀
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final result = widget.result;
      if (result != null) {
        _slotKey.currentState?.spin(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final maxVal = int.tryParse(widget.maxCtrl.text.trim()) ?? 100;
    final digitCount = maxVal.toString().length;
    final minText =
        widget.minCtrl.text.trim().isEmpty ? '1' : widget.minCtrl.text.trim();
    final maxText =
        widget.maxCtrl.text.trim().isEmpty ? '100' : widget.maxCtrl.text.trim();

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
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _accent.withValues(alpha: 0.4),
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
                          colors: [Color(0xFF00A86B), Color(0xFF00D68F)],
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
                    Text(
                      l10n.numberCardTitle,
                      style: const TextStyle(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          border: Border.all(
                            color: _accent.withValues(alpha: 0.2),
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
                                color: _accent.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: widget.minCtrl,
                              enabled: !_isSpinning,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: _accent,
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
                        color: _accent.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          border: Border.all(
                            color: _accent.withValues(alpha: 0.2),
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
                                color: _accent.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextField(
                              controller: widget.maxCtrl,
                              enabled: !_isSpinning,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorColor: _accent,
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
                // ── 범위 힌트 ──
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    PremiumService.instance.isPremium
                        ? l10n.numberRangeHintPro
                        : l10n.numberRangeHintFree,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // ── 슬롯머신 결과 영역 ──
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SlotMachineDisplay(
                          key: _slotKey,
                          digitCount: digitCount,
                          onSpinComplete: () {
                            if (!mounted) return;
                            setState(() => _isSpinning = false);
                            AdService.instance.recordToolUse('number');
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$minText ~ $maxText',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _accent.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          border: Border.all(
                            color: _accent.withValues(alpha: 0.2),
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
                                  color: _accent.withValues(alpha: 0.5),
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
                  opacity: _isSpinning ? 0.5 : 1.0,
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00A86B), Color(0xFF00D68F)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: !_isSpinning
                            ? [
                                BoxShadow(
                                  color: _accent.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isSpinning ? null : _startGenerate,
                          borderRadius: BorderRadius.circular(14),
                          splashColor: Colors.white.withValues(alpha: 0.15),
                          highlightColor:
                              Colors.white.withValues(alpha: 0.05),
                          child: Center(
                            child: Text(
                              _isSpinning ? '...' : l10n.diceGenerateButton,
                              style: const TextStyle(
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

// ── 사다리 게임 카드 ─────────────────────────────────────────────
class _LadderCard extends StatefulWidget {
  final bool fullscreen;
  const _LadderCard({this.fullscreen = false});

  @override
  State<_LadderCard> createState() => _LadderCardState();
}

class _LadderCardState extends State<_LadderCard>
    with TickerProviderStateMixin {
  static const _accent = AppColors.colorLadder;
  int get _maxParticipants => PremiumService.instance.isPremium
      ? PremiumService.maxPremiumLadderParticipants
      : PremiumService.maxFreeLadderParticipants;

  final List<TextEditingController> _nameControllers = [];
  final List<TextEditingController> _resultControllers = [];
  LadderState _state = LadderState.input;
  List<LadderPath> _paths = [];
  List<List<_HBar>> _horizontalBars = [];
  int _participantCount = 4;

  late AnimationController _animCtrl;
  late Animation<double> _animValue;

  @override
  void initState() {
    super.initState();
    _initControllers(_participantCount);
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _animValue = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut);
    _animCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        setState(() => _state = LadderState.result);
        AdService.instance.recordToolUse('ladder');
      }
    });
  }

  void _initControllers(int count) {
    // 기존 컨트롤러 정리
    for (final c in _nameControllers) {
      c.dispose();
    }
    for (final c in _resultControllers) {
      c.dispose();
    }
    _nameControllers.clear();
    _resultControllers.clear();
    for (int i = 0; i < count; i++) {
      _nameControllers.add(TextEditingController());
      _resultControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    for (final c in _nameControllers) {
      c.dispose();
    }
    for (final c in _resultControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addParticipant() {
    final isPremium = PremiumService.instance.isPremium;
    if (!PremiumService.canAddLadderParticipant(
        isPremium, _nameControllers.length)) {
      Navigator.pushNamed(context, AppRoutes.paywall);
      return;
    }
    setState(() {
      _participantCount++;
      _nameControllers.add(TextEditingController());
      _resultControllers.add(TextEditingController());
    });
  }

  void _removeParticipant(int index) {
    if (_participantCount <= 2) return;
    setState(() {
      _nameControllers[index].dispose();
      _nameControllers.removeAt(index);
      _resultControllers[index].dispose();
      _resultControllers.removeAt(index);
      _participantCount--;
    });
  }

  String _defaultResult(AppLocalizations l10n, int i) {
    return switch (i) {
      0 => l10n.ladderResultDefault1st,
      1 => l10n.ladderResultDefault2nd,
      2 => l10n.ladderResultDefault3rd,
      _ => l10n.ladderResultDefaultNth(i + 1),
    };
  }

  String _getName(AppLocalizations l10n, int i) {
    final t = _nameControllers[i].text.trim();
    return t.isEmpty ? l10n.ladderPerson(i + 1) : t;
  }

  String _getResult(AppLocalizations l10n, int toIndex) {
    final t = _resultControllers[toIndex].text.trim();
    return t.isEmpty ? _defaultResult(l10n, toIndex) : t;
  }

  void _startLadder() {
    if (_participantCount < 2) return;

    final rng = Random();
    final n = _participantCount;
    final barRows = n * 3;

    List<List<_HBar>> bars;
    List<LadderPath> paths;

    // 중복 방지: 결과가 순열(permutation)이 될 때까지 재생성
    int attempts = 0;
    do {
      bars = _generateBars(rng, n, barRows);
      paths = _tracePaths(bars, n, barRows);
      attempts++;
    } while (_hasDuplicateResults(paths, n) && attempts < 20);

    setState(() {
      _horizontalBars = bars;
      _paths = paths;
      _state = LadderState.playing;
    });
    _animCtrl.forward(from: 0.0);
  }

  /// 가로선 생성 — usedCols로 양쪽 끝점 모두 추적
  List<List<_HBar>> _generateBars(Random rng, int n, int barRows) {
    final bars = <List<_HBar>>[];
    for (int row = 0; row < barRows; row++) {
      final rowBars = <_HBar>[];
      final usedCols = <int>{}; // 이미 사용된 컬럼 (끝점 포함)
      final pairs = List.generate(n - 1, (i) => i)..shuffle(rng);
      for (final col in pairs) {
        // col과 col+1 양쪽 모두 미사용인지 확인
        if (usedCols.contains(col) || usedCols.contains(col + 1)) continue;
        if (rng.nextDouble() < 0.45) {
          rowBars.add(_HBar(row: row, col: col));
          usedCols.add(col);
          usedCols.add(col + 1);
        }
      }
      bars.add(rowBars);
    }
    return bars;
  }

  /// 경로 추적 — 각 참가자의 시작점 → 도착점 계산
  List<LadderPath> _tracePaths(
      List<List<_HBar>> bars, int n, int barRows) {
    final paths = <LadderPath>[];
    for (int start = 0; start < n; start++) {
      int currentCol = start;
      final points = <Offset>[Offset(currentCol.toDouble(), 0)];

      for (int row = 0; row < barRows; row++) {
        for (final bar in bars[row]) {
          if (bar.col == currentCol) {
            // 오른쪽으로 이동
            points.add(Offset(currentCol.toDouble(), (row + 0.5)));
            currentCol++;
            points.add(Offset(currentCol.toDouble(), (row + 0.5)));
            break;
          } else if (bar.col == currentCol - 1) {
            // 왼쪽으로 이동
            points.add(Offset(currentCol.toDouble(), (row + 0.5)));
            currentCol--;
            points.add(Offset(currentCol.toDouble(), (row + 0.5)));
            break;
          }
        }
      }
      points.add(Offset(currentCol.toDouble(), barRows.toDouble()));
      paths.add(LadderPath(
        fromIndex: start,
        toIndex: currentCol,
        points: points,
      ));
    }
    return paths;
  }

  /// toIndex 중복 검사 — 순열이 아니면 true
  bool _hasDuplicateResults(List<LadderPath> paths, int n) {
    final seen = <int>{};
    for (final p in paths) {
      if (!seen.add(p.toIndex)) return true;
    }
    return seen.length != n;
  }

  void _retry() {
    setState(() {
      _state = LadderState.input;
      _paths = [];
      _horizontalBars = [];
    });
    _animCtrl.reset();
  }

  void _shareResults() {
    final l10n = AppLocalizations.of(context)!;
    final buf = StringBuffer();
    buf.writeln('🪜 ${l10n.ladderTitle}');
    buf.writeln('─────────────');
    for (final p in _paths) {
      final name = _getName(l10n, p.fromIndex);
      final result = _getResult(l10n, p.toIndex);
      buf.writeln('$name → $result');
    }
    Share.share(buf.toString());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.fullscreen) {
      return SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            Expanded(child: _buildContent(l10n)),
          ],
        ),
      );
    }

    return _buildContent(l10n);
  }

  Widget _buildContent(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E1628),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accent.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: switch (_state) {
        LadderState.input => _buildInputState(l10n),
        LadderState.playing => _buildPlayingState(l10n),
        LadderState.result => _buildResultState(l10n),
      },
    );
  }

  // ── INPUT 상태 ──────────────────────────────────────────────
  Widget _buildInputState(AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          _cardHeader(context, Icons.linear_scale_rounded,
              l10n.ladderTitle, _accent),
          const SizedBox(height: 16),

          // 참가자 섹션
          Row(
            children: [
              Text(
                l10n.ladderParticipants,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _accent.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  l10n.ladderCountBadge(
                      _participantCount, _maxParticipants),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 이름 입력 리스트
          ...List.generate(_participantCount, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // 번호 배지
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // 이름 입력
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141D35),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _accent.withValues(alpha: 0.15),
                        ),
                      ),
                      child: TextField(
                        controller: _nameControllers[i],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        cursorColor: _accent,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: InputBorder.none,
                          hintText: l10n.ladderPerson(i + 1),
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 삭제 버튼
                  if (_participantCount > 2)
                    GestureDetector(
                      onTap: () => _removeParticipant(i),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),

          // + 참가자 추가 버튼
          if (_participantCount < PremiumService.maxPremiumLadderParticipants)
            Builder(builder: (_) {
              final isPremium = PremiumService.instance.isPremium;
              final atFreeLimit = !isPremium &&
                  _participantCount >=
                      PremiumService.maxFreeLadderParticipants;
              final btnColor = atFreeLimit ? AppColors.spark : _accent;
              return GestureDetector(
                onTap: _addParticipant,
                child: Container(
                  width: double.infinity,
                  height: 40,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: btnColor.withValues(alpha: 0.25),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      atFreeLimit
                          ? l10n.ladderMaxParticipantsPro
                          : l10n.ladderAddParticipant,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: btnColor.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ),
              );
            }),

          const SizedBox(height: 20),

          // 결과 섹션
          Text(
            l10n.ladderResults,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _accent.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.ladderResultHint,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 10),

          // 결과 입력 리스트
          ...List.generate(_participantCount, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // 컬러 dot
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _accent.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141D35),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _accent.withValues(alpha: 0.12),
                        ),
                      ),
                      child: TextField(
                        controller: _resultControllers[i],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                        cursorColor: _accent,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10),
                          border: InputBorder.none,
                          hintText: _defaultResult(l10n, i),
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // 시작 버튼
          GestureDetector(
            onTap: _participantCount >= 2 ? _startLadder : null,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE06520), Color(0xFFFF8C42)],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: _accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '🪜 ${l10n.ladderStart}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── PLAYING 상태 ──────────────────────────────────────────────
  Widget _buildPlayingState(AppLocalizations l10n) {
    return Column(
      children: [
        // 헤더
        _cardHeader(
            context, Icons.linear_scale_rounded, l10n.ladderTitle, _accent),
        const SizedBox(height: 12),

        // 상단 참가자 칩
        Row(
          children: List.generate(_participantCount, (i) {
            return Expanded(
              child: Center(
                child: Text(
                  _getName(l10n, i),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _accent,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),

        // 사다리 캔버스
        Expanded(
          child: AnimatedBuilder(
            animation: _animValue,
            builder: (_, _) => CustomPaint(
              size: Size.infinite,
              painter: _LadderPainter(
                paths: _paths,
                horizontalBars: _horizontalBars,
                participantCount: _participantCount,
                animationValue: _animValue.value,
                accent: _accent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // 하단 결과 칩
        Row(
          children: List.generate(_participantCount, (i) {
            return Expanded(
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _animValue.value > 0.9 ? 1.0 : 0.25,
                  child: Text(
                    _getResult(l10n, i),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── RESULT 상태 ──────────────────────────────────────────────
  Widget _buildResultState(AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 헤더
          _cardHeader(context, Icons.linear_scale_rounded,
              l10n.ladderTitle, _accent),
          const SizedBox(height: 12),

          // 사다리 미니 (흐리게)
          SizedBox(
            height: 160,
            width: double.infinity,
            child: Opacity(
              opacity: 0.4,
              child: CustomPaint(
                size: Size.infinite,
                painter: _LadderPainter(
                  paths: _paths,
                  horizontalBars: _horizontalBars,
                  participantCount: _participantCount,
                  animationValue: 1.0,
                  accent: _accent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 결과 리스트
          ...List.generate(_paths.length, (i) {
            final p = _paths[i];
            final name = _getName(l10n, p.fromIndex);
            final result = _getResult(l10n, p.toIndex);
            final isFirst = p.toIndex == 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isFirst
                    ? _accent.withValues(alpha: 0.12)
                    : const Color(0xFF141D35),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isFirst
                      ? _accent.withValues(alpha: 0.4)
                      : Colors.white.withValues(alpha: 0.06),
                ),
              ),
              child: Row(
                children: [
                  if (isFirst)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(Icons.emoji_events_rounded,
                          size: 18, color: _accent),
                    ),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isFirst ? _accent : Colors.white,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.3)),
                  const SizedBox(width: 8),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isFirst
                          ? _accent
                          : Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // 버튼 2개
          Row(
            children: [
              // 다시 뽑기
              Expanded(
                child: GestureDetector(
                  onTap: _retry,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE06520), Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _accent.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '↺ ${l10n.ladderRetry}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // 결과 공유
              Expanded(
                child: GestureDetector(
                  onTap: _shareResults,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '📤 ${l10n.ladderShare}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── 가로선 모델 ──────────────────────────────────────────────
class _HBar {
  final int row;
  final int col; // col과 col+1 사이 연결
  const _HBar({required this.row, required this.col});
}

// ── 사다리 CustomPainter ────────────────────────────────────────
class _LadderPainter extends CustomPainter {
  final List<LadderPath> paths;
  final List<List<_HBar>> horizontalBars;
  final int participantCount;
  final double animationValue;
  final Color accent;

  _LadderPainter({
    required this.paths,
    required this.horizontalBars,
    required this.participantCount,
    required this.animationValue,
    required this.accent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final n = participantCount;
    if (n < 2) return;

    final totalRows = horizontalBars.length;
    if (totalRows == 0) return;

    final colWidth = size.width / (n + 1);
    double xOf(int col) => colWidth * (col + 1);
    double yOf(double row) => (row / totalRows) * size.height;

    // 세로선 (배경)
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (int c = 0; c < n; c++) {
      canvas.drawLine(
        Offset(xOf(c), 0),
        Offset(xOf(c), size.height),
        bgPaint,
      );
    }

    // 가로선 (배경)
    for (final rowBars in horizontalBars) {
      for (final bar in rowBars) {
        final y = yOf(bar.row + 0.5);
        canvas.drawLine(
          Offset(xOf(bar.col), y),
          Offset(xOf(bar.col + 1), y),
          bgPaint,
        );
      }
    }

    // 하이라이트 경로
    final hlPaint = Paint()
      ..color = accent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final path in paths) {
      final pts = path.points;
      if (pts.length < 2) continue;

      // 전체 경로 길이 계산
      double totalLen = 0;
      final segLens = <double>[];
      for (int i = 0; i < pts.length - 1; i++) {
        final from = Offset(xOf(pts[i].dx.toInt()), yOf(pts[i].dy));
        final to = Offset(xOf(pts[i + 1].dx.toInt()), yOf(pts[i + 1].dy));
        final len = (to - from).distance;
        segLens.add(len);
        totalLen += len;
      }

      // 애니메이션 진행 만큼만 그리기
      final drawLen = totalLen * animationValue;
      double drawn = 0;

      for (int i = 0; i < pts.length - 1; i++) {
        if (drawn >= drawLen) break;
        final from = Offset(xOf(pts[i].dx.toInt()), yOf(pts[i].dy));
        final to = Offset(xOf(pts[i + 1].dx.toInt()), yOf(pts[i + 1].dy));
        final segLen = segLens[i];
        final remaining = drawLen - drawn;

        if (remaining >= segLen) {
          canvas.drawLine(from, to, hlPaint);
          drawn += segLen;
        } else {
          final t = remaining / segLen;
          final mid = Offset.lerp(from, to, t)!;
          canvas.drawLine(from, mid, hlPaint);
          drawn = drawLen;

          // 구슬 (이동 중)
          canvas.drawCircle(
            mid,
            5,
            Paint()..color = accent,
          );
        }
      }

      // 애니메이션 완료 시 끝점에 구슬
      if (animationValue >= 1.0) {
        final last = pts.last;
        canvas.drawCircle(
          Offset(xOf(last.dx.toInt()), yOf(last.dy)),
          5,
          Paint()..color = accent,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LadderPainter old) =>
      old.animationValue != animationValue ||
      old.participantCount != participantCount;
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

// ── 프리미엄 잠금 배지 ─────────────────────────────────────────────
class _PremiumLockBadge extends StatelessWidget {
  const _PremiumLockBadge();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.paywall),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.spark.withValues(alpha: 0.2),
          border: Border.all(
            color: AppColors.spark.withValues(alpha: 0.5),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock, size: 12, color: AppColors.spark),
            const SizedBox(width: 3),
            Text(
              'PRO',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.spark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
