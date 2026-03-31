import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_scroller/src/measurable_widget.dart';

void main() {
  group('MeasurableWidget', () {
    testWidgets('calls onSize callback with correct index and height', (
      WidgetTester tester,
    ) async {
      int? reportedIndex;
      double? reportedHeight;
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: MeasurableWidget(
              index: 5,
              onSize: (index, height) {
                reportedIndex = index;
                reportedHeight = height;
              },
              child: const SizedBox(width: 100, height: 50),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(reportedIndex, 5);
      expect(reportedHeight, 50);
    });

    testWidgets('updates height when child size changes', (
      WidgetTester tester,
    ) async {
      int? reportedIndex;
      double? reportedHeight;
      final key = GlobalKey();
      Widget buildWidget(double width, double height) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: MeasurableWidget(
              key: key,
              index: 2,
              onSize: (index, height) {
                reportedIndex = index;
                reportedHeight = height;
              },
              child: SizedBox(width: width, height: height),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildWidget(80, 40));
      await tester.pumpAndSettle();
      expect(reportedIndex, 2);
      expect(reportedHeight, 40);
      await tester.pumpWidget(buildWidget(120, 60));
      await tester.pumpAndSettle();
      expect(reportedIndex, 2);
      expect(reportedHeight, 60);
    });
  });
}
