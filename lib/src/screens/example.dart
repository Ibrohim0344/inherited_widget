import 'package:flutter/material.dart';

class Example extends StatelessWidget {
  const Example({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: DataOwnerStateFull(),
      ),
    );
  }
}

class DataOwnerStateFull extends StatefulWidget {
  const DataOwnerStateFull({Key? key}) : super(key: key);

  @override
  State<DataOwnerStateFull> createState() => _DataOwnerStateFullState();
}

class _DataOwnerStateFullState extends State<DataOwnerStateFull> {
  var _value1 = 0;
  var _value2 = 0;

  void increment1() {
    _value1 += 1;
    setState(() {});
  }

  void increment2() {
    _value2 += 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: increment1,
          child: const Text("Tap 1"),
        ),
        ElevatedButton(
          onPressed: increment2,
          child: const Text("Tap 2"),
        ),
        DataProviderInherited(
          value1: _value1,
          value2: _value2,
          child: const DataConsumerStateless(),
        ),
      ],
    );
  }
}

class DataConsumerStateless extends StatelessWidget {
  const DataConsumerStateless({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = context
            .dependOnInheritedWidgetOfExactType<DataProviderInherited>(
                aspect: "one")
            ?.value1 ??
        0;

    // .findAncestorStateOfType<_DataOwnerStateFullState>()?._value ??
    // 0;
    return Container(
      child: Column(
        children: [
          Text("$value"),
          const DataConsumerStateFull(),
        ],
      ),
    );
  }
}

class DataConsumerStateFull extends StatefulWidget {
  const DataConsumerStateFull({Key? key}) : super(key: key);

  @override
  State<DataConsumerStateFull> createState() => _DataConsumerStateFullState();
}

class _DataConsumerStateFullState extends State<DataConsumerStateFull> {
  @override
  Widget build(BuildContext context) {
    // final element = context
    //     .getElementForInheritedWidgetOfExactType<DataProviderInherited>();
    // if (element != null) context.dependOnInheritedElement(element);
    // final dataProvider = element?.widget as DataProviderInherited;
    // final value = dataProvider.value;

    // .findAncestorStateOfType<_DataOwnerStateFullState>()?._value ??
    // 0;

    // final value = getInherit<DataProviderInherited>(context)?.value ?? 0;

    final value = context
            .dependOnInheritedWidgetOfExactType<DataProviderInherited>(
                aspect: "two")
            ?.value2 ??
        0;

    return Text("$value");
  }

// T? getInherit<T>(BuildContext context) {
//   final element = context
//       .getElementForInheritedWidgetOfExactType<DataProviderInherited>();
//   final widget = element?.widget;
//   if (widget is T) {
//     return widget as T;
//   } else {
//     return null;
//   }
// }
}

class DataProviderInherited extends InheritedModel<String> {
  final int value1;
  final int value2;

  const DataProviderInherited({
    Key? key,
    required this.value1,
    required this.value2,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(DataProviderInherited oldWidget) {
    return value1 != oldWidget.value1 || value2 != oldWidget.value2;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant DataProviderInherited oldWidget,
    Set<String> aspects,
  ) {
    final isValue1Updated =
        value1 != oldWidget.value1 && aspects.contains("one");
    final isValue2Updated =
        value2 != oldWidget.value2 && aspects.contains("two");

    return isValue1Updated || isValue2Updated;
  }
}
