import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uic/progress_uic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uic/checkbox_uic.dart';

class ProgressUicScreen  extends StatefulWidget {
  ProgressUicScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProgressUicScreenState createState() => _ProgressUicScreenState();
}

class _ProgressUicScreenState extends State<ProgressUicScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool _inProgress3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Default view'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProgressUic(),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Custom color and size'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProgressUic(
                      color: Colors.redAccent,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Message'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProgressUic(
                      text: 'Loading...',
                      textLocation: ProgressUicTextLocation.right,
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('Wrap content view'.toUpperCase(),
                        style: Theme.of(context).textTheme.caption,
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProgressUic(
                      inProgress: _inProgress3,
                      text: 'Loading...',
                      textLocation: ProgressUicTextLocation.bottom,
                      textStyle: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.white,
                      ),
                      dimContent: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Text('This is a content view.'),
                            Text('When it is in progress state, ProgressUic will dim the content'),
                            RaisedButton(
                              child: Text('Start progress',),
                              onPressed: () {
                                setState(() {
                                  _inProgress3 = true;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
