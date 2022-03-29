import 'package:flutter/widgets.dart';

import 'form_factor.dart';
import 'form_factors.dart';

/// Displays a child that match current form factor.
///
/// Form factors used as keys for [children] must be a subset of the form factors list
/// defined in [FormFactors] widget.
///
/// For example:
/// ```dart
/// FormFactors(
///   formFactors: const <FormFactor>[
///     Screens.formFactorA,
///     Screens.formFactorALandscape,
///     Screens.formFactorB,
///     Screens.formFactorC,
///     Screens.formFactorD,
///     Screens.formFactorE,
//    ],
///   child: ResponsiveLayout(
///     children: {
///       Screens.formFactorB: WidgetB(),
///       Screens.formFactorD: WidgetD(),
///     }
///   )
/// )
///
/// class Screens {
///   static const formFactorA = FormFactor(crossAxisMinWidth: 300);
///   static const formFactorALandscape = FormFactor(crossAxisMinWidth: 300, orientation: Orientation.landscape);
///   static const formFactorB = FormFactor(crossAxisMinWidth: 400);
///   static const formFactorC = FormFactor(crossAxisMinWidth: 500);
///   static const formFactorD = FormFactor(crossAxisMinWidth: 600);
///   static const formFactorE = FormFactor(crossAxisMinWidth: 700);
/// }
/// ```
///
/// Children matching logic that implemented in [DefaultResponsiveLayoutDelegate] class
/// consider the order of form factors list in [FormFactors] widget when matching
/// children for missing form factors.
///
/// See also:
/// - [ResponsiveLayoutDelegate]
///
class ResponsiveLayout extends StatefulWidget {
  /// Creates an instance of ResponsiveLayout widget.
  ///
  const ResponsiveLayout({
    Key? key,
    required this.children,
    this.delegate = const DefaultResponsiveLayoutDelegate(),
  }) : super(key: key);

  /// A list of possible child widgets matched to form factors.
  ///
  final Map<FormFactor, Widget> children;

  /// Provides a logic of matching child widgets to form factors.
  ///
  /// Defaults to [DefaultResponsiveLayoutDelegate] instance.
  ///
  final ResponsiveLayoutDelegate delegate;

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
      _children.addAll(widget.delegate.resolveChildren(widget.children, formFactorsData));
    }
    return _children[formFactorsData.currentFormFactor]!;
  }
}

/// An interface of matching child widgets to form factors.
///
/// See also:
/// - [DefaultResponsiveLayoutDelegate]
/// - [ResponsiveLayout]
/// - [FormFactorsData]
///
abstract class ResponsiveLayoutDelegate {
  /// For given list of supported form factors contained in [formFactorsData]
  /// and explicitly matched widgets, returns a map of matched widgets for all
  /// supported form factors.
  Map<FormFactor, Widget> resolveChildren(Map<FormFactor, Widget> explicitChildren, FormFactorsData formFactorsData);
}

/// Default implementation of [ResponsiveLayoutDelegate].
///
/// Considering order of supported form factors list, fills all missing matches.
/// Widgets are matching separately for portrait and landscape orientation.
/// For each orientation, until the explicit match is found, the first given match
/// is used as default.
///
/// Example:
/// ```dart
/// FormFactors(
///   formFactors: const <FormFactor>[
///     Screens.formFactorA,
///     Screens.formFactorALandscape,
///     Screens.formFactorB,
///     Screens.formFactorC,
///     Screens.formFactorD,
///     Screens.formFactorE,
//    ],
///   child: ResponsiveLayout(
///     children: {
///       Screens.formFactorB: WidgetB(),
///       Screens.formFactorD: WidgetD(),
///     }
///   )
/// )
///
/// class Screens {
///   static const formFactorA = FormFactor(crossAxisMinWidth: 300);
///   static const formFactorALandscape = FormFactor(crossAxisMinWidth: 300, orientation: Orientation.landscape);
///   static const formFactorB = FormFactor(crossAxisMinWidth: 400);
///   static const formFactorC = FormFactor(crossAxisMinWidth: 500);
///   static const formFactorD = FormFactor(crossAxisMinWidth: 600);
///   static const formFactorE = FormFactor(crossAxisMinWidth: 700);
/// }
/// ```
/// For given list of form factors and explicit children matches in ResponsiveLayout,
/// the default delegate will produce the following matches:
/// ``` dart
/// {
///   Screens.formFactorA: WidgetB(),
///   Screens.formFactorB: WidgetB(),
///   Screens.formFactorC: WidgetB(),
///   Screens.formFactorD: WidgetD(),
///   Screens.formFactorE: WidgetD(),
///   Screens.formFactorALandscape: WidgetB(),
/// }
/// ```
///
class DefaultResponsiveLayoutDelegate implements ResponsiveLayoutDelegate {
  /// Creates an instance of ResponsiveLayoutDelegate.
  ///
  const DefaultResponsiveLayoutDelegate();

  @override
  Map<FormFactor, Widget> resolveChildren(Map<FormFactor, Widget> explicitChildren, FormFactorsData formFactorsData) {
    final result = <FormFactor, Widget>{};

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
