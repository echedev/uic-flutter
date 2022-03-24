import 'package:flutter/widgets.dart';
import 'package:uic/src/utils/platform/platform.dart';

import 'form_factor.dart';

class FormFactors extends StatelessWidget {
  const FormFactors({
    Key? key,
    required this.formFactors,
    required this.child,
    this.orientationLocks = const FormFactorOrientationLocks(portraitWeb: true),
  }) : super(key: key);

  final List<FormFactor> formFactors;

  final Widget child;

  final FormFactorOrientationLocks orientationLocks;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return _FormFactorsInherited(
      data: FormFactorsData(
        formFactors: formFactors,
        currentFormFactor: _resolveFormFactor(mediaQueryData),
        orientation: _resolveOrientation(mediaQueryData),
      ),
      child: child,
    );
  }

  static FormFactorsData of(BuildContext context) {
    final _FormFactorsInherited? formFactorsInherited = context.dependOnInheritedWidgetOfExactType<_FormFactorsInherited>();
    assert(formFactorsInherited != null, 'No "_FormFactorsInherited" found in context');
    return formFactorsInherited!.data;
  }

  FormFactor _resolveFormFactor(MediaQueryData mediaQueryData) {
    FormFactor? result;
    final orientation = _resolveOrientation(mediaQueryData);
    final mediaCrossAxisSize = orientation == Orientation.portrait ? mediaQueryData.size.width : mediaQueryData.size.height;
    for (var formFactor in formFactors.where((item) => item.orientation == orientation)) {
      if (mediaCrossAxisSize > formFactor.crossAxisMinWidth) {
        result = formFactor;
      }
    }
    return result ?? _defaultFormFactor(orientation);
  }

  Orientation _resolveOrientation(MediaQueryData mediaQueryData) {
    if (orientationLocks.portraitWeb && Platform.isWeb) {
      return Orientation.portrait;
    } else if (orientationLocks.landscapeWeb && Platform.isWeb) {
      return Orientation.landscape;
    } else {
      return mediaQueryData.orientation;
    }
  }

  FormFactor _defaultFormFactor(Orientation orientation) {
    final formFactorsPortrait = formFactors.where((item) => item.orientation == Orientation.portrait);
    final formFactorsLandscape = formFactors.where((item) => item.orientation == Orientation.landscape);
    final defaultPortrait = formFactorsPortrait.isEmpty ? null : formFactorsPortrait.first;
    final defaultLandscape = formFactorsLandscape.isEmpty ? null : formFactorsLandscape.first;
    return orientation == Orientation.portrait ? (defaultPortrait ?? defaultLandscape)! : (defaultLandscape ?? defaultPortrait)!;
  }
}

class _FormFactorsInherited extends InheritedWidget {
  const _FormFactorsInherited({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final FormFactorsData data;

  @override
  bool updateShouldNotify(_FormFactorsInherited oldWidget) =>
      data.currentFormFactor != oldWidget.data.currentFormFactor ||
      data.orientation != oldWidget.data.orientation;
}

class FormFactorsData {
  const FormFactorsData({
    required this.formFactors,
    required this.currentFormFactor,
    required this.orientation,
  });

  final List<FormFactor> formFactors;

  final FormFactor currentFormFactor;

  final Orientation orientation;
}

class FormFactorOrientationLocks {
  const FormFactorOrientationLocks({
    this.portraitWeb = false,
    this.landscapeWeb = false,
  });

  final bool portraitWeb;

  final bool landscapeWeb;
}