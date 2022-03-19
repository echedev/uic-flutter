import 'package:flutter/widgets.dart';

import 'form_factor.dart';

class FormFactors extends StatelessWidget {
  const FormFactors({
    Key? key,
    required this.formFactors,
    required this.child,
  }) : super(key: key);

  final Set<FormFactor> formFactors;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return _FormFactorsInherited(
      data: FormFactorsData(
        formFactors: formFactors,
        currentFormFactor: _getCurrentFormFactor(mediaQueryData),
      ),
      child: child,
    );
  }

  static FormFactorsData of(BuildContext context) {
    final _FormFactorsInherited? formFactorsInherited = context.dependOnInheritedWidgetOfExactType<_FormFactorsInherited>();
    assert(formFactorsInherited != null, 'No "_FormFactorsInherited" found in context');
    return formFactorsInherited!.data;
  }

  FormFactor _getCurrentFormFactor(MediaQueryData mediaQueryData) {
    FormFactor result = formFactors.first;
    for (var formFactor in formFactors) {
      if (formFactor.maxWidth >= mediaQueryData.size.width) {
        break;
      }
      result = formFactor;
    }
    return result;
  }
}

class _FormFactorsInherited extends InheritedWidget {
  const _FormFactorsInherited({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final FormFactorsData data;

  @override
  bool updateShouldNotify(_FormFactorsInherited oldWidget) => data != oldWidget.data;
}

class FormFactorsData {
  const FormFactorsData({
    required this.formFactors,
    required this.currentFormFactor,
  });

  final Set<FormFactor> formFactors;

  final FormFactor currentFormFactor;

}