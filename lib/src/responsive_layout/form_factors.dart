import 'package:flutter/widgets.dart';
import 'package:uic/src/utils/platform/platform.dart';

import 'form_factor.dart';

/// Defines supported form factors (screens sizes) and provides information
/// on current form factor.
///
/// It listens to [MediaQuery] and based on its data provides updated form factor data when needed.
///
/// Typically it is placed somewhere at the top of widgets hierarchy, so
/// descendant widgets that uses form factors data, like [ResponsiveLayout],
/// could obtain those data.
///
/// For some platforms the [orientationLocks] parameter allows to override
/// the screen orientation, provided by [MediaQuery].
/// For example, on web it could be convenient to consider the browser window
/// to be always in portrait orientation.
///
/// See also:
/// - [FormFactor]
/// - [FormFactorsData]
/// - [ResponsiveLayout]
///
class FormFactors extends StatelessWidget {
  /// Creates an instance of FormFactors widget.
  ///
  const FormFactors({
    Key? key,
    required this.formFactors,
    required this.child,
    this.orientationLocks = const FormFactorOrientationLocks(),
  }) : super(key: key);

  /// List of supported form factors.
  ///
  final List<FormFactor> formFactors;

  /// The widget below this widget in the tree.
  ///
  final Widget child;

  /// Controls screen orientation on some platforms.
  ///
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

  /// The data from the closest [FormFactors] instance.
  ///
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
    if (orientationLocks.webPortrait && Platform.isWeb) {
      return Orientation.portrait;
    } else if (orientationLocks.webLandscape && Platform.isWeb) {
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

/// Form factor data that could be obtained by [FormFactor.of()].
///
/// See also:
/// - [FormFactor]
/// - [FormFactorOrientationLocks]
///
class FormFactorsData {
  /// Create an instance of FormFactorFata.
  ///
  const FormFactorsData({
    required this.formFactors,
    required this.currentFormFactor,
    required this.orientation,
  });

  /// A list of supported form factors.
  ///
  final List<FormFactor> formFactors;

  /// A value from [formFactors] list that reflects the current screen size and
  /// orientation.
  ///
  final FormFactor currentFormFactor;

  /// Screen orientation.
  ///
  final Orientation orientation;
}

/// Control supported screen orientation.
///
/// Allows to lock screen orientation for some platforms, like web for example.
/// So the orientation returned by [MediaQuery] would be ignored.
///
class FormFactorOrientationLocks {
  /// Creates an instance of FormFactorOrientationLocks.
  ///
  const FormFactorOrientationLocks({
    this.webPortrait = true,
    this.webLandscape = false,
  });
  // TODO: Add assert to check mutually exclusive parameters.

  /// Lock portrait orientation on web.
  ///
  final bool webPortrait;

  /// Lock landscape orientation on web.
  ///
  final bool webLandscape;
}