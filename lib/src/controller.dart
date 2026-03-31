import 'package:flutter/material.dart';
import 'scroll_state.dart';
import 'variable_height_manager.dart';

class SmartScrollController {
  final ScrollController controller;

  double _lastOffset = 0;
  ScrollDirectionX _direction = ScrollDirectionX.idle;

  final ValueNotifier<ScrollState> stateNotifier =
      ValueNotifier(ScrollState(offset: 0, direction: ScrollDirectionX.idle));

  final VariableHeightManager _heightManager = VariableHeightManager();

  SmartScrollController({ScrollController? controller})
      : controller = controller ?? ScrollController() {
    this.controller.addListener(_listener);
  }

  void _listener() {
    final currentOffset = controller.offset;

    if (currentOffset > _lastOffset) {
      _direction = ScrollDirectionX.down;
    } else if (currentOffset < _lastOffset) {
      _direction = ScrollDirectionX.up;
    } else {
      _direction = ScrollDirectionX.idle;
    }

    _lastOffset = currentOffset;

    stateNotifier.value =
        ScrollState(offset: currentOffset, direction: _direction);
  }

  void setItemHeight(int index, double height) {
    _heightManager.setHeight(index, height);
  }

  Future<void> scrollToIndex(int index) async {
    double offset = _heightManager.hasIndex(index)
        ? _heightManager.getOffset(index)!
        : _heightManager.estimateOffset(index);

    await controller.animateTo(offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final exact = _heightManager.getOffset(index);
      if (exact != null && (controller.offset - exact).abs() > 2) {
        controller.jumpTo(exact);
      }
    });
  }

  Future<void> scrollToTop() async {
    await controller.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  Future<void> scrollToBottom() async {
    await controller.animateTo(controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  void dispose() {
    controller.removeListener(_listener);
    controller.dispose();
    stateNotifier.dispose();
  }
}
