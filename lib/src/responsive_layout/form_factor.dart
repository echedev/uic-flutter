import 'package:flutter/widgets.dart';

/// A model of the screen.
///
/// It is used to define all supported screens and matched views.
///
/// See also:
/// - [FormFactors]
/// - [ResponsiveLayout]
///
class FormFactor {
  /// Creates an instance of the FormFactor.
  ///
  const FormFactor({
    this.crossAxisMinWidth = 0.0,
    this.orientation = Orientation.portrait,
  });

  /// Minimum size of the screen in cross axis.
  ///
  final double crossAxisMinWidth;

  /// Orientation of the screen.
  ///
  final Orientation orientation;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FormFactor &&
        other.crossAxisMinWidth == crossAxisMinWidth &&
        other.orientation == orientation;
  }

  @override
  int get hashCode => hashValues(crossAxisMinWidth, orientation);
}
