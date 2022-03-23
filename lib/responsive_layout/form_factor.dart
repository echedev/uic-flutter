import 'package:flutter/widgets.dart';

abstract class FormFactor {
  const FormFactor();

  double get crossAxisMinWidth => 0.0;

  Orientation get orientation => Orientation.portrait;

}