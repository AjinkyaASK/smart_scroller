import 'package:flutter/material.dart';

class MeasurableWidget extends StatefulWidget {
  final int index;
  final Widget child;
  final Function(int, double) onSize;

  const MeasurableWidget({
    super.key,
    required this.index,
    required this.child,
    required this.onSize,
  });

  @override
  State<MeasurableWidget> createState() => _MeasurableWidgetState();
}

class _MeasurableWidgetState extends State<MeasurableWidget> {
  final keyRef = GlobalKey();
  double? lastHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => measure());
  }

  @override
  void didUpdateWidget(covariant MeasurableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => measure());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => measure());
  }

  void measure() {
    final context = keyRef.currentContext;
    if (context == null) return;

    final size = context.size;
    if (size != null && size.height != lastHeight) {
      lastHeight = size.height;
      widget.onSize(widget.index, size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => measure());
    return Container(key: keyRef, child: widget.child);
  }
}
