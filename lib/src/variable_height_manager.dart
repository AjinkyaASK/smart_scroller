import 'dart:math';

class VariableHeightManager {
  final Map<int, double> _heights = {};
  List<int> _sortedKeys = [];
  final Map<int, double> _prefixOffsets = {};
  bool _dirty = true;

  void setHeight(int index, double height) {
    if (_heights[index] == height) return;
    _heights[index] = height;
    _dirty = true;
  }

  bool hasIndex(int index) => _heights.containsKey(index);

  void _rebuild() {
    if (!_dirty) return;

    _sortedKeys = _heights.keys.toList()..sort();

    double offset = 0;
    for (final key in _sortedKeys) {
      _prefixOffsets[key] = offset;
      offset += _heights[key]!;
    }

    _dirty = false;
  }

  double? getOffset(int index) {
    _rebuild();
    return _prefixOffsets[index];
  }

  double estimateOffset(int index) {
    _rebuild();
    if (_sortedKeys.isEmpty) return 0;

    int nearest = _sortedKeys[max(0, _sortedKeys.length - 1)];
    double avg = _heights.values.reduce((a, b) => a + b) / _heights.length;

    return (_prefixOffsets[nearest] ?? 0) +
        (index - nearest) * avg;
  }
}
