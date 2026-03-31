import 'package:flutter/material.dart';

extension ScrollToIndexExtension on ScrollController {
  Future<void> scrollToIndex({
    required int index,
    required double itemHeight,
  }) async {
    await animateTo(index * itemHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }
}
