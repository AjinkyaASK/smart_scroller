import 'package:flutter_test/flutter_test.dart';
import 'package:smart_scroller/src/scroll_state.dart';

void main() {
  group('ScrollState', () {
    test('constructs with provided offset and direction', () {
      const offset = 123.4;
      const direction = ScrollDirectionX.up;
      final s = ScrollState(offset: offset, direction: direction);

      expect(s.offset, offset);
      expect(s.direction, direction);
    });

    test('supports all enum directions', () {
      expect(ScrollDirectionX.values, contains(ScrollDirectionX.idle));
      expect(ScrollDirectionX.values, contains(ScrollDirectionX.up));
      expect(ScrollDirectionX.values, contains(ScrollDirectionX.down));

      // Ensure an instance can be assigned from each value
      for (final direction in ScrollDirectionX.values) {
        final state = ScrollState(offset: 0.0, direction: direction);
        expect(state.direction, direction);
      }
    });

    test(
      'two states with same values are not identical but equivalent in fields',
      () {
        final a = ScrollState(offset: 1.0, direction: ScrollDirectionX.down);
        final b = ScrollState(offset: 1.0, direction: ScrollDirectionX.down);

        expect(a, isNot(same(b)));
        expect(a.offset, b.offset);
        expect(a.direction, b.direction);
      },
    );
  });
}
