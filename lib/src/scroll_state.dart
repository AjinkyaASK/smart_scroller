enum ScrollDirectionX { idle, up, down }

class ScrollState {
  final double offset;
  final ScrollDirectionX direction;

  ScrollState({required this.offset, required this.direction});
}
