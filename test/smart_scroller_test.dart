import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_scroller/smart_scroller.dart';

void main() {
  group('SmartScroller Library', () {
    test('can import SmartScrollController from library', () {
      expect(SmartScrollController, isNotNull);
    });

    test('can import ScrollState from library', () {
      expect(ScrollState, isNotNull);
    });

    test('can import ScrollDirectionX from library', () {
      expect(ScrollDirectionX.idle, equals(ScrollDirectionX.idle));
    });

    test('can import VariableHeightManager from library', () {
      expect(VariableHeightManager, isNotNull);
    });

    test('can import MeasurableWidget from library', () {
      expect(MeasurableWidget, isNotNull);
    });

    testWidgets('can create SmartScrollController instance', (
      WidgetTester tester,
    ) async {
      final smartController = SmartScrollController();
      expect(smartController, isNotNull);
      expect(smartController.controller, isNotNull);
      expect(smartController.stateNotifier, isNotNull);

      smartController.dispose();
    });

    testWidgets('SmartScrollController with custom ScrollController', (
      WidgetTester tester,
    ) async {
      final customController = ScrollController();
      final smartController = SmartScrollController(
        controller: customController,
      );

      expect(smartController.controller, equals(customController));

      smartController.dispose();
    });
  });
}
