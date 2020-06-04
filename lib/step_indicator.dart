import 'package:flutter/material.dart';

/// A widget to display progress through a sequence of steps.
///
/// StepIndicator can be useful to show a current item in sliders and carousels, or
/// a current page in a flow where user has to pass through a sequence of screens.
///
/// The default view is a row of filled circles, optionally connected by lines.
///
/// You must specify the [totalSteps] and [selectedStepIndex] values.
///
/// Basic customization options for StepIndicator are [itemSize], [expanded],
/// [padding], [showLines] and [lineLength].
///
/// The color of step items is defined by [colorCompleted], [colorSelected] and
/// [colorIncomplete] parameters.
/// You can provide your custom step widgets for each step state in [completedStep],
/// [selectedStep] and [incompleteStep].
///
/// Connecting lines are not shown by default. Use [showLines] to turn lines on.
/// The following option can be used to customize lines appearance: [colorLineCompleted],
/// [colorLineIncomplete], [lineWidth].
///
class StepIndicator extends StatelessWidget {
  StepIndicator({
    Key key,
    this.colorCompleted,
    Color colorLineCompleted,
    this.colorIncomplete,
    Color colorLineIncomplete,
    this.colorSelected,
    this.completedStep,
    this.expanded = false,
    this.incompleteStep,
    this.itemSize = 16.0,
    this.lineLength,
    this.lineWidth,
    this.padding = const EdgeInsets.all(4.0),
    this.selectedStep,
    this.showLines = false,
    @required this.selectedStepIndex,
    @required this.totalSteps,
  }) :
      this.colorLineCompleted = colorLineCompleted ?? colorCompleted,
      this.colorLineIncomplete = colorLineIncomplete ?? colorIncomplete,
      super(key: key);

  /// The color of completed steps.
  ///
  /// It is applied when the default step widget is used.
  /// Also this color is used to draw lines, connecting completed steps.
  /// Defaults to primary color of the current theme.
  final Color colorCompleted;

  /// The color of incomplete steps.
  ///
  /// It is applied when the default step widget is used.
  /// Also this color is used to draw lines, connecting incomplete steps.
  /// Defaults to 'black12' color.
  final Color colorIncomplete;

  /// The color of lines connecting completed steps.
  ///
  /// Use this value to define the color of completed lines, when it have to be
  /// different from the color of completed step items.
  ///
  /// Defaults to [colorCompleted].
  final Color colorLineCompleted;

  /// The color of lines connecting incomplete steps.
  ///
  /// Use this value to define the color of incomplete lines, when it have to be
  /// different from the color of incomplete step items.
  ///
  /// Defaults to [colorIncomplete].
  final Color colorLineIncomplete;

  /// The color of currently selected step.
  ///
  /// It is applied when the default step widget is used.
  /// Defaults to accent color of the current theme.
  final Color colorSelected;

  /// A widget to show for completed steps
  ///
  /// If it is not defined, the default filled circle widget is used.
  final Widget completedStep;

  /// Should the step indicator expand in its main axis to all available space.
  ///
  /// When set to 'true', step items are spaced evenly and connecting lines are
  /// expanded between them. The [lineLength] is ignored in this case.
  /// Defaults to 'false'. In this case step items are grouped in center and the
  /// [lineLength] controls a distance between them.
  final bool expanded;

  /// A widget to show for incomplete steps.
  ///
  /// If it is not defined, the default filled circle widget is used.
  final Widget incompleteStep;

  /// The size of step item.
  ///
  /// It is applied when the default step widget is used.
  /// Defaults to '16.0'.
  final double itemSize;

  /// The length of connecting line.
  ///
  /// The line is drawn between step items and defines a distance between them.
  /// Defaults to '16.0'.
  final double lineLength;

  /// The width of connecting line.
  ///
  /// The line is drawn between step items and defines a distance between them.
  /// Defaults to '2.0'.
  final double lineWidth;

  /// Defines an empty space around the step item.
  ///
  /// Defaults to '4.0'.
  final EdgeInsetsGeometry padding;

  /// A widget to show for currently selected step.
  ///
  /// If it is not defined, the default filled circle widget is used.
  final Widget selectedStep;

  /// Index of selected step.
  ///
  /// The selected step item is drawn as defined in [selectedStep].
  /// All step items before selected step are drawn as [completedStep] and all
  /// step items after it are drawn as [incompleteStep].
  final int selectedStepIndex;

  /// Should the step items to be connected by lines.
  ///
  /// Defaults to 'false'.
  final bool showLines;

  /// The total number of steps.
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: expanded ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ..._buildSteps(context),
      ],
    );
  }

  List<Widget> _buildSteps(BuildContext context) {
    Color eventualColorCompleted = colorCompleted ?? Theme.of(context).primaryColor;
    Color eventualColorIncomplete = colorIncomplete ?? Colors.black12;
    Color eventualColorLineCompleted = showLines ? colorLineCompleted ?? eventualColorCompleted : Colors.transparent;
    Color eventualColorLineIncomplete = showLines ? colorLineIncomplete ?? eventualColorIncomplete : Colors.transparent;
    Color eventualColorSelected = colorSelected ?? Theme.of(context).accentColor;
    List<Widget> result = [];
    // Completed steps
    for (int i = 1; i < selectedStepIndex; i++) {
     result.add(Padding(
       padding: padding,
       child: completedStep ?? _Step(
         color: eventualColorCompleted,
         size: itemSize,
       ),
     ));
     result.add(_Line(
       color: eventualColorLineCompleted,
       expanded: expanded,
       length: lineLength,
       width: lineWidth,
     ));
    }
    // Selected step
    result.add(Padding(
      padding: padding,
      child: selectedStep ?? _Step(
        color: eventualColorSelected,
        size: itemSize,
      ),
    ));
    if (selectedStepIndex < totalSteps) {
      result.add(_Line(
        color: eventualColorLineIncomplete,
        expanded: expanded,
        length: lineLength,
        width: lineWidth,
      ));
    }
    // Incomplete steps
    for (int i = selectedStepIndex + 1; i <= totalSteps - 1; i++) {
      result.add(Padding(
        padding: padding,
        child: incompleteStep ?? _Step(
          color: eventualColorIncomplete,
          size: itemSize,
        ),
      ));
      result.add(_Line(
        color: eventualColorLineIncomplete,
        expanded: expanded,
        length: lineLength,
        width: lineWidth,
      ));
    }
    result.add(Padding(
      padding: padding,
      child: incompleteStep ?? _Step(
        color: eventualColorIncomplete,
        size: itemSize,
      ),
    ));

    return result;
  }
}

class _Step extends StatelessWidget {
  const _Step({
    Key key,
    this.color,
    this.size = 16.0,
  }) : super(key: key);

  final Color color;

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    Key key,
    this.color,
    this.expanded = false,
    double length,
    double width,
  }) : this.length = expanded ? double.infinity : length ?? 16.0,
        this.width = width ?? 2.0,
        super(key: key);

  final Color color;

  final bool expanded;

  final double length;

  final double width;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: length,
      height: width,
      decoration: BoxDecoration(
        color: color,
      ),
    );
    if (expanded) {
      return Expanded(
        child: child,
        flex: 1,
      );
    }
    else {
      return child;
    }
  }
}
