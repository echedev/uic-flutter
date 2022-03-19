import 'package:flutter/widgets.dart';

import 'form_factor.dart';
import 'form_factors.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
    required this.children,
  }) : super(key: key);

  final Map<Type, Widget> children;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {

  final _children = <Type, Widget>{};

  @override
  void didUpdateWidget(ResponsiveLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _children.clear();
  }

  @override
  Widget build(BuildContext context) {
    final formFactorsData = FormFactors.of(context);
    if (_children.isEmpty) {
      _children.addAll(_resolveChildren(widget.children, formFactorsData.formFactors));
    }
    return _children[formFactorsData.currentFormFactor.runtimeType] !;
  }

  Map<Type, Widget> _resolveChildren(Map<Type, Widget> children,
      Set<FormFactor> formFactors) {
    final result = <Type, Widget>{};

    final defaultFormFactor = children.keys.first;
    Type? currentFormFactor;
    for (FormFactor formFactor in formFactors) {
      if (children.containsKey(formFactor.runtimeType)) {
        currentFormFactor = formFactor.runtimeType;
      }
      result[formFactor.runtimeType] = children[currentFormFactor ?? defaultFormFactor]!;
    }
    return result;
  }
}
