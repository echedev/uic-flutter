import 'package:flutter/widgets.dart';

import 'form_factor.dart';
import 'form_factors.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<ResponsiveLayoutItem> items;

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  final _children = <FormFactor, Widget>{};

  @override
  void didUpdateWidget(ResponsiveLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _children.clear();
  }

  @override
  Widget build(BuildContext context) {
    final formFactorsData = FormFactors.of(context);
    if (_children.isEmpty) {
      _children.addAll(_resolveChildren(widget.items, formFactorsData));
    }
    return _children[formFactorsData.currentFormFactor]!;
  }

  Map<FormFactor, Widget> _resolveChildren(
      List<ResponsiveLayoutItem> items, FormFactorsData formFactorsData) {
    final result = <FormFactor, Widget>{};

    final explicitChildren = {
      for (var item in items) item.formFactor: item.child
    };
    final portraitFormFactors = explicitChildren.keys
        .where((item) => item.orientation == Orientation.portrait);
    final landscapeFormFactors = explicitChildren.keys
        .where((element) => element.orientation == Orientation.landscape);
    final defaultPortrait =
        portraitFormFactors.isEmpty ? null : portraitFormFactors.first;
    final defaultLandscape =
        landscapeFormFactors.isEmpty ? null : landscapeFormFactors.first;

    FormFactor? currentFormFactor;
    for (FormFactor formFactor in formFactorsData.formFactors
        .where((item) => item.orientation == Orientation.portrait)) {
      if (explicitChildren.keys.contains(formFactor)) {
        currentFormFactor = formFactor;
      }
      result[formFactor] = explicitChildren[
          currentFormFactor ?? defaultPortrait ?? defaultLandscape]!;
    }
    currentFormFactor = null;
    for (FormFactor formFactor in formFactorsData.formFactors
        .where((item) => item.orientation == Orientation.landscape)) {
      if (explicitChildren.keys.contains(formFactor)) {
        currentFormFactor = formFactor;
      }
      result[formFactor] = explicitChildren[
          currentFormFactor ?? defaultLandscape ?? defaultPortrait]!;
    }
    return result;
  }
}

class ResponsiveLayoutItem {
  const ResponsiveLayoutItem({
    required this.formFactor,
    required this.child,
  });

  final FormFactor formFactor;

  final Widget child;
}
