# Smart Scroller

A Flutter package that provides smart scrolling functionality with variable height support and enhanced scroll controls.

## Features

- Variable height item support for accurate scrolling
- Scroll direction tracking and state management
- Smooth scrolling to specific indices
- Custom scroll controller with state notifications
- Extension methods for easy scroll-to-index functionality

## Getting started

To use this package, add `smart_scroller` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  smart_scroller: ^0.0.1
```

## Usage

### Basic Usage

```dart
import 'package:smart_scroller/smart_scroller.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final smartController = SmartScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: smartController.controller,
        child: Column(
          children: List.generate(100, (index) => ListTile(title: Text('Item $index'))),
        ),
      ),
    );
  }

  @override
  void dispose() {
    smartController.dispose();
    super.dispose();
  }
}
```

### Using Variable Height Support

```dart
class VariableHeightExample extends StatefulWidget {
  @override
  _VariableHeightExampleState createState() => _VariableHeightExampleState();
}

class _VariableHeightExampleState extends State<VariableHeightExample> {
  final smartController = SmartScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: smartController.controller,
        child: Column(
          children: List.generate(50, (index) {
            return MeasurableWidget(
              index: index,
              onHeightChanged: (height) {
                smartController.setItemHeight(index, height);
              },
              child: Container(
                height: 50 + (index % 3) * 20.0, // Variable heights
                child: ListTile(title: Text('Item $index')),
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => smartController.scrollToIndex(25),
        child: Icon(Icons.arrow_downward),
      ),
    );
  }

  @override
  void dispose() {
    smartController.dispose();
    super.dispose();
  }
}
```

### Using Scroll State Notifications

```dart
class ScrollStateExample extends StatefulWidget {
  @override
  _ScrollStateExampleState createState() => _ScrollStateExampleState();
}

class _ScrollStateExampleState extends State<ScrollStateExample> {
  final smartController = SmartScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ValueListenableBuilder<ScrollState>(
            valueListenable: smartController.stateNotifier,
            builder: (context, state, child) {
              return Text('Offset: ${state.offset}, Direction: ${state.direction}');
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: smartController.controller,
              child: Column(
                children: List.generate(100, (index) => ListTile(title: Text('Item $index'))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    smartController.dispose();
    super.dispose();
  }
}
```

### Using Extension Methods

```dart
// Using the extension on ScrollController
ScrollController controller = ScrollController();

// Scroll to index 10 with item height 50
await controller.scrollToIndex(index: 10, itemHeight: 50.0);
```

## API Reference

- `SmartScrollController`: Main controller class with variable height support
- `ScrollState`: Represents the current scroll state (offset and direction)
- `ScrollDirectionX`: Enum for scroll directions (idle, up, down)
- `VariableHeightManager`: Manages height information for variable height items
- `MeasurableWidget`: Widget that measures and reports its height
- `ScrollToIndexExtension`: Extension methods for ScrollController

## See also

- [GitHub Repository](https://github.com/AjinkyaASK/smart_scroller)
- [Pub.dev Package](https://pub.dev/packages/smart_scroller)
