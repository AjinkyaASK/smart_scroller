import 'package:flutter_test/flutter_test.dart';
import 'package:smart_scroller/src/variable_height_manager.dart';

void main() {
  group('VariableHeightManager', () {
    test('setHeight and getOffset returns computed prefix offsets', () {
      final manager = VariableHeightManager();

      manager.setHeight(5, 18);
      manager.setHeight(2, 12);
      manager.setHeight(8, 6);

      expect(manager.hasIndex(2), isTrue);
      expect(manager.hasIndex(5), isTrue);
      expect(manager.hasIndex(8), isTrue);

      // Keys are sorted as [2,5,8]
      expect(manager.getOffset(2), 0);
      expect(manager.getOffset(5), 12);
      expect(manager.getOffset(8), 30);

      expect(manager.getOffset(4), isNull);
    });

    test('hasIndex returns false for unknown index', () {
      final manager = VariableHeightManager();

      expect(manager.hasIndex(100), isFalse);
      manager.setHeight(100, 33);
      expect(manager.hasIndex(100), isTrue);
      expect(manager.getOffset(100), 0);
    });

    test('estimateOffset returns 0 when empty', () {
      final manager = VariableHeightManager();
      expect(manager.estimateOffset(0), 0);
      expect(manager.estimateOffset(42), 0);
    });

    test(
      'estimateOffset uses last known key + average height for interpolation',
      () {
        final manager = VariableHeightManager();

        manager.setHeight(0, 10);
        manager.setHeight(2, 20);
        manager.setHeight(5, 10);

        // Prefix offsets: 0 -> 0, 2 -> 10, 5 -> 30
        // Average height = (10 + 20 + 10) / 3 = 13.333...
        expect(manager.estimateOffset(5), closeTo(30, 1e-9));
        expect(manager.estimateOffset(6), closeTo(30 + 13.3333333333, 1e-9));
        expect(
          manager.estimateOffset(3),
          closeTo(30 + (3 - 5) * 13.3333333333, 1e-9),
        );
      },
    );

    test('setHeight updates existing value and updates offset results', () {
      final manager = VariableHeightManager();

      manager.setHeight(1, 5);
      manager.setHeight(3, 5);

      expect(manager.getOffset(3), 5);

      manager.setHeight(1, 10);
      expect(manager.getOffset(3), 10);
      expect(manager.estimateOffset(4), closeTo(17.5, 1e-9));
    });
  });
}
