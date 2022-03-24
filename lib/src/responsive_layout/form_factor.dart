import 'package:flutter/widgets.dart';

abstract class FormFactor {
  const FormFactor();

  double get crossAxisMinWidth => 0.0;

  Orientation get orientation => Orientation.portrait;

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
