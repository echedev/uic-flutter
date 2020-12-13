import 'package:flutter/material.dart';
import 'package:uic/progress_uic.dart';
import 'package:uic/widgets.dart';

List<Widget> examplesActionButton(BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
  return <Widget>[
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('Default view'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            action: () async {
              return Future.delayed(Duration(seconds: 5));
            },
            child: Text('Text'),
          ),
          ActionButton(
            action: () async {
              return Future.delayed(Duration(seconds: 5));
            },
            buttonType: ActionButtonType.elevated,
            child: Text('Elevated'),
          ),
          ActionButton(
            action: () async {
              return Future.delayed(Duration(seconds: 5));
            },
            buttonType: ActionButtonType.outlined,
            child: Text('Outlined'),
          ),
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('Custom style'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            action: () {
              return Future.delayed(Duration(seconds: 5));
            },
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: Theme.of(context).accentColor,
              textStyle: Theme.of(context).textTheme.headline5
            ),
            child: Text('Text'),
          ),
          ActionButton(
            action: () {
              return Future.delayed(Duration(seconds: 5));
            },
            buttonType: ActionButtonType.elevated,
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline5
            ),
            child: Text('Elevated'),
          ),
          ActionButton(
            action: () {
              return Future.delayed(Duration(seconds: 5));
            },
            buttonType: ActionButtonType.outlined,
            style: OutlinedButton.styleFrom(
              primary: Theme.of(context).accentColor,
              side: BorderSide(color: Theme.of(context).accentColor,),
            ),
            child: Text('Outlined'),
          ),
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('Custom progress view'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            action: () {
              return Future.delayed(Duration(seconds: 5));
            },
            buttonType: ActionButtonType.outlined,
            style: TextButton.styleFrom(
              minimumSize: Size(180.0, 72.0),
            ),
            progressView: ProgressUic(
              color: Colors.redAccent,
              size: 20.0,
              text: 'Action in progress',
              textStyle: Theme.of(context).textTheme.button,
            ),
            child: Text('Action button'),
          ),
        ],
      ),
    ),
    Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text('Handling action state'.toUpperCase(),
          style: Theme.of(context).textTheme.caption,
        )
    ),
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            action: () {
              return Future.delayed(Duration(seconds: 5));
            },
            onActionStarted: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Action started'),
              ));
            },
            child: Text('Started'),
          ),
          ActionButton(
            action: () {
              return Future.delayed(Duration(seconds: 5));
            },
            onActionCompleted: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Action completed'),
              ));
            },
            buttonType: ActionButtonType.elevated,
            child: Text('Completed'),
          ),
          ActionButton(
            action: () {
              return Future.error('Some error');
            },
            onActionError: (error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Action error: ${error.toString()}'),
              ));
            },
            buttonType: ActionButtonType.outlined,
            child: Text('Error'),
          ),
        ],
      ),
    ),
  ];
}
