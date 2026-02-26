import 'dart:math';
import 'package:flutter/material.dart';
import 'constants.dart';

class AppUtils {
  AppUtils._();

  // 현재 테마의 룰렛 색 팔레트 (테마 변경 시 SettingsNotifier에서 갱신)
  static List<Color> activePalette = kDefaultPalette;

  // UUID v4 생성 (dart:math 기반 간단 구현 – Phase 2에서 uuid 패키지로 교체 가능)
  static String generateId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  // 항목 인덱스에 따라 팔레트 색상 반환 (순환, 현재 테마 팔레트 사용)
  static Color colorForIndex(int index) {
    return activePalette[index % activePalette.length];
  }

  // Color.value(deprecated) 대신 toARGB32()를 사용한 int 반환 버전
  static int colorValueForIndex(int index) {
    return activePalette[index % activePalette.length].toARGB32();
  }

  // 날짜를 "오늘", "어제", "n일 전" 등 상대적 표현으로 변환
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return '오늘';
    if (diff.inDays == 1) return '어제';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${date.month}/${date.day}';
  }

  // 결과 공유용 텍스트 생성
  static String buildShareText(String rouletteName, String resultLabel) {
    return '[$rouletteName]의 결과: $resultLabel\nSpin Wheel 앱으로 결정했어요 🎡';
  }
}
