import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  StepIndicator({
    Key key,
    this.colorCompleted,
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
    @required this.selectedStepIndex,
    @required this.totalSteps,
  }) :
      this.colorLineIncomplete = colorLineIncomplete ?? colorIncomplete,
      super(key: key);

  final Color colorCompleted;

  final Color colorIncomplete;

  final Color colorLineIncomplete;

  final Color colorSelected;

  final Widget completedStep;

  final bool expanded;

  final Widget incompleteStep;

  final double itemSize;

  final double lineLength;

  final double lineWidth;

  final EdgeInsetsGeometry padding;

  final Widget selectedStep;

  final int selectedStepIndex;

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
    Color eventualColorLineIncomplete = colorLineIncomplete ?? eventualColorIncomplete;
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
       color: eventualColorCompleted,
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
    result.add(incompleteStep ?? _Step(
      color: eventualColorIncomplete,
      size: itemSize,
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
