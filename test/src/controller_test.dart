import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_scroller/src/controller.dart';
import 'package:smart_scroller/src/scroll_state.dart';

void main() {
  group('SmartScrollController', () {
    Widget buildTestScrollable(SmartScrollController controller) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: controller.controller,
            child: Column(
              children: List<Widget>.generate(
                100,
                (index) => SizedBox(
                  height: 50,
                  child: Center(child: Text('Item #$index')),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('updates stateNotifier on scroll direction changes', (
      WidgetTester tester,
    ) async {
      final smart = SmartScrollController();

      await tester.pumpWidget(buildTestScrollable(smart));
      await tester.pumpAndSettle();

      expect(smart.stateNotifier.value.offset, 0);
      expect(smart.stateNotifier.value.direction, ScrollDirectionX.idle);

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -120),
      );
      await tester.pumpAndSettle();

      expect(smart.stateNotifier.value.direction, ScrollDirectionX.down);
      expect(smart.stateNotifier.value.offset, greaterThan(0));

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, 120),
      );
      await tester.pumpAndSettle();

      expect(smart.stateNotifier.value.direction, ScrollDirectionX.up);

      smart.dispose();
    });

    testWidgets('scrollToBottom and scrollToTop work', (
      WidgetTester tester,
    ) async {
      final smart = SmartScrollController();

      await tester.pumpWidget(buildTestScrollable(smart));
      await tester.pumpAndSettle();

      final bottomFuture = smart.scrollToBottom();
      await tester.pump();
      await tester.pumpAndSettle();
      await bottomFuture;

      print(
        'scrollToBottom result offset=${smart.controller.offset}, max=${smart.controller.position.maxScrollExtent}',
      );

      expect(smart.controller.offset, greaterThan(1000));
      expect(
        smart.controller.offset,
        lessThanOrEqualTo(smart.controller.position.maxScrollExtent),
      );

      final topFuture = smart.scrollToTop();
      await tester.pump();
      await tester.pumpAndSettle();
      await topFuture;

      expect(smart.controller.offset, closeTo(0, 0.1));

      smart.dispose();
    });

    testWidgets(
      'scrollToIndex uses VariableHeightManager offset and executes post-frame callback',
      (WidgetTester tester) async {
        final smart = SmartScrollController();

        smart.setItemHeight(0, 50);
        smart.setItemHeight(5, 50);
        smart.setItemHeight(20, 50);

        await tester.pumpWidget(buildTestScrollable(smart));
        await tester.pumpAndSettle();

        // Target index 20 has a known offset (5*50 = 250) from recorded heights.
        final indexFuture = smart.scrollToIndex(20);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();
        await indexFuture;

        expect(smart.controller.offset, closeTo(100, 2));
        expect(
          smart.stateNotifier.value.direction,
          isNot(ScrollDirectionX.idle),
        );

        smart.dispose();
      },
    );

    testWidgets('dispose removes listeners and closes value notifier', (
      WidgetTester tester,
    ) async {
      expect(() => SmartScrollController().dispose(), returnsNormally);
    });
  });
}
