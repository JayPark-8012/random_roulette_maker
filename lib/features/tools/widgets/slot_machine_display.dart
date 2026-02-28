import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/design_tokens.dart';

/// 슬롯머신 스타일 숫자 디스플레이.
///
/// [digitCount] 자릿수만큼 [_SlotColumn]을 Row 로 배치.
/// 외부에서 [SlotMachineDisplayState.spin]을 호출해 애니메이션을 트리거한다.
class SlotMachineDisplay extends StatefulWidget {
  final int digitCount;
  final VoidCallback? onSpinComplete;

  const SlotMachineDisplay({
    super.key,
    required this.digitCount,
    this.onSpinComplete,
  });

  @override
  State<SlotMachineDisplay> createState() => SlotMachineDisplayState();
}

class SlotMachineDisplayState extends State<SlotMachineDisplay> {
  final List<GlobalKey<_SlotColumnState>> _columnKeys = [];
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _rebuildKeys();
  }

  @override
  void didUpdateWidget(SlotMachineDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digitCount != widget.digitCount) {
      _rebuildKeys();
    }
  }

  void _rebuildKeys() {
    _columnKeys.clear();
    for (int i = 0; i < widget.digitCount; i++) {
      _columnKeys.add(GlobalKey<_SlotColumnState>());
    }
  }

  /// 슬롯 스핀 시작. [targetValue]를 digitCount 자리로 0-패딩하여 각 컬럼에 분배.
  void spin(int targetValue) {
    if (_spinning) return;
    _spinning = true;

    final padded = targetValue.toString().padLeft(widget.digitCount, '0');
    int completedCount = 0;

    for (int i = 0; i < widget.digitCount; i++) {
      final targetDigit = int.parse(padded[i]);
      _columnKeys[i].currentState?.spin(
        targetDigit: targetDigit,
        delay: Duration(milliseconds: i * 120),
        duration: Duration(milliseconds: 900 + i * 200),
        onDone: () {
          completedCount++;
          if (completedCount >= widget.digitCount) {
            _spinning = false;
            widget.onSpinComplete?.call();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.digitCount, (i) {
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
          child: _SlotColumn(key: _columnKeys[i]),
        );
      }),
    );
  }
}

// ─── 개별 슬롯 컬럼 ───────────────────────────────────────────────

class _SlotColumn extends StatefulWidget {
  const _SlotColumn({super.key});

  @override
  State<_SlotColumn> createState() => _SlotColumnState();
}

class _SlotColumnState extends State<_SlotColumn> {
  static const double _cellHeight = 96;
  static const double _columnWidth = 72;
  static const int _randomCount = 20;

  final ScrollController _scrollCtrl = ScrollController();

  List<int> _items = [0]; // 초기 0 표시
  bool _done = false;

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void spin({
    required int targetDigit,
    required Duration delay,
    required Duration duration,
    VoidCallback? onDone,
  }) {
    final rng = Random();
    // 랜덤 숫자 20개 + 타겟
    final items = List.generate(_randomCount, (_) => rng.nextInt(10));
    items.add(targetDigit);

    setState(() {
      _items = items;
      _done = false;
    });

    // 스크롤 위치 초기화
    _scrollCtrl.jumpTo(0);

    Timer(delay, () {
      if (!mounted) return;
      final targetOffset = _randomCount * _cellHeight;
      _scrollCtrl
          .animateTo(
        targetOffset,
        duration: duration,
        curve: Curves.easeOutCubic,
      )
          .then((_) {
        if (!mounted) return;
        setState(() => _done = true);
        onDone?.call();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const accent = AppColors.colorNumber;

    return Container(
      width: _columnWidth,
      height: _cellHeight,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _done
              ? accent.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.08),
          width: 1.5,
        ),
        boxShadow: _done
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.25),
                  blurRadius: 20,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.5),
        child: Stack(
          children: [
            // ── 스크롤 리스트 ──
            ListView.builder(
              controller: _scrollCtrl,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              itemExtent: _cellHeight,
              itemBuilder: (_, index) {
                return SizedBox(
                  height: _cellHeight,
                  child: Center(
                    child: Text(
                      '${_items[index]}',
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                  ),
                );
              },
            ),
            // ── 상하 페이드 마스크 ──
            Positioned.fill(
              child: IgnorePointer(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.33, 0.67, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: const SizedBox.expand(),
                ),
              ),
            ),
            // ── 중앙 하이라이트 바 ──
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Container(
                    height: _cellHeight,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.08),
                      border: Border(
                        top: BorderSide(
                          color: accent.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: accent.withValues(alpha: 0.3),
                          width: 1,
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
    );
  }
}
