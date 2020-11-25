import 'package:flutter/material.dart';
import 'package:uic/widgets.dart';

List<Widget> examplesActionButton(BuildContext context) {
  return <Widget>[
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('Default view'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: ActionButton(
        action: () {
          return Future.delayed(Duration(seconds: 5));
        },
//        onActionCompleted: () => print('Action completed'),
//        onActionStarted: () => print('Action started'),
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Theme.of(context).accentColor,
          minimumSize: Size(100.0, 32.0),
        ),
        child: Text('Action Button'),
      ),
    ),
  ];
}
