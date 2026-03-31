import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_scroller/src/extensions.dart';

void main() {
  group('ScrollToIndexExtension', () {
    Widget buildTestScrollable(ScrollController controller) {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            controller: controller,
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

    testWidgets('scrollToIndex animates to correct position with index 0', (
      WidgetTester tester,
    ) async {
      final controller = ScrollController();

      await tester.pumpWidget(buildTestScrollable(controller));
      await tester.pumpAndSettle();

      await controller.scrollToIndex(index: 0, itemHeight: 50.0);
      await tester.pumpAndSettle();

      expect(controller.offset, 0.0);
    });
  });
}
