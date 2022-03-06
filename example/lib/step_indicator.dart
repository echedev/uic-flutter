import 'package:flutter/material.dart';
import 'package:uic/widgets.dart';

List<Widget> examplesStepIndicator(BuildContext context) {
  return <Widget>[
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Default view'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepIndicator(
        selectedStepIndex: 2,
        totalSteps: 5,
/*
* Check the commented parameters below to learn available customization options
*/
//        completedStep: Icon(Icons.check_circle,
//          color: Theme.of(context).primaryColor,
//        ),
//        incompleteStep: Icon(Icons.radio_button_unchecked,
//          color: Theme.of(context).primaryColor,
//        ),
//        selectedStep: Icon(Icons.radio_button_checked,
//          color: Theme.of(context).accentColor,
//        ),
//        colorCompleted: Theme.of(context).primaryColor,
//        colorIncomplete: Colors.black12,
//        colorLineCompleted: Colors.blueAccent,
//        colorLineIncomplete: Colors.blueAccent,
//        colorSelected: Theme.of(context).accentColor,
//        expanded: true,
//        itemSize: 32.0,
//        lineLength: 50.0,
//        lineWidth: 1.0,
//        padding: const EdgeInsets.all(0.0),
//        showLines: true,
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Expanded, with lines'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepIndicator(
        selectedStepIndex: 2,
        totalSteps: 5,
        expanded: true,
        showLines: true,
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Custom colors'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepIndicator(
        selectedStepIndex: 2,
        totalSteps: 5,
        colorCompleted: Colors.lightBlueAccent,
        colorSelected: Colors.redAccent,
        colorIncomplete: Colors.lightBlueAccent,
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          'Custom step widget'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: StepIndicator(
        selectedStepIndex: 2,
        totalSteps: 5,
        completedStep: Icon(
          Icons.check_circle,
          color: Theme.of(context).primaryColor,
        ),
        incompleteStep: Icon(
          Icons.radio_button_unchecked,
          color: Theme.of(context).primaryColor,
        ),
        selectedStep: Icon(
          Icons.radio_button_checked,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
  ];
}
