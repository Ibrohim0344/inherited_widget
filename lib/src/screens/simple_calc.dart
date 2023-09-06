import 'package:flutter/material.dart';

class SimpleCalc extends StatelessWidget {
  const SimpleCalc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SimpleCalcWidget(),
      ),
    );
  }
}

class SimpleCalcWidget extends StatefulWidget {
  const SimpleCalcWidget({Key? key}) : super(key: key);

  @override
  State<SimpleCalcWidget> createState() => _SimpleCalcWidgetState();
}

class _SimpleCalcWidgetState extends State<SimpleCalcWidget> {
  final _model = SimpleCalcWidgetModel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ChangeNotifierProvider(
          model: _model,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FirstNumberWidget(),
              SizedBox(height: 10),
              SecondNumberWidget(),
              SizedBox(height: 10),
              SumButtonWidget(),
              SizedBox(height: 10),
              ResultWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class FirstNumberWidget extends StatelessWidget {
  const FirstNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (value) =>
          ChangeNotifierProvider.of<SimpleCalcWidgetModel>(context)
              ?.firstNumber = value,
    );
  }
}

class SecondNumberWidget extends StatelessWidget {
  const SecondNumberWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      onChanged: (value) =>
          ChangeNotifierProvider.of<SimpleCalcWidgetModel>(context)
              ?.secondNumber = value,
    );
  }
}

class SumButtonWidget extends StatelessWidget {
  const SumButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () =>
            ChangeNotifierProvider.of<SimpleCalcWidgetModel>(context)?.sum(),
        child: const Text("count numbers"));
  }
}

class ResultWidget extends StatelessWidget {
  const ResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value =
        ChangeNotifierProvider.of<SimpleCalcWidgetModel>(context)?.sumResult ??
            "-1";
    return Text("Result: $value");
  }
}

class SimpleCalcWidgetModel extends ChangeNotifier {
  int? _firstNumber;
  int? _secondNumber;
  int? sumResult;

  set firstNumber(String value) => _firstNumber = int.tryParse(value);

  set secondNumber(String value) => _secondNumber = int.tryParse(value);

  void sum() {
    int? sumResult;

    if (_firstNumber != null && _secondNumber != null) {
      sumResult = _firstNumber! + _secondNumber!;
    } else {
      sumResult = null;
    }
    if (this.sumResult != sumResult) {
      this.sumResult = sumResult;
      notifyListeners();
    }
  }
}

class ChangeNotifierProvider<T extends ChangeNotifier>
    extends InheritedNotifier<T> {
  final T model;

  const ChangeNotifierProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static T? of<T>(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ChangeNotifierProvider>();
    if (provider != null) {
      return provider.model as T;
    } else {
      return null;
    }
  }
}
