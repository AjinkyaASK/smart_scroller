import 'package:flutter/material.dart';
import 'package:smart_scroller/smart_scroller.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Demo());
  }
}

class Demo extends StatefulWidget {
  const Demo({super.key});
  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final controller = SmartScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Scroll Example")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.scrollToTop(),
        child: const Icon(Icons.arrow_upward),
      ),
      body: ListView.builder(
        controller: controller.controller,
        itemCount: 100,
        itemBuilder: (_, i) {
          final h = (i % 5 + 1) * 40.0;
          return MeasurableWidget(
            index: i,
            onSize: controller.setItemHeight,
            child: Container(
              height: h,
              margin: const EdgeInsets.all(8),
              color: Colors.blue[(i % 9 + 1) * 100],
              child: Center(child: Text("Item $i")),
            ),
          );
        },
      ),
    );
  }
}
