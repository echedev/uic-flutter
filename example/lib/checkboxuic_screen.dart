import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uic/checkbox_uic.dart';

class CheckboxUicScreen  extends StatelessWidget {
  CheckboxUicScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CheckboxUic(
              title: 'Simple check box with label',
              onChanged: (value) {
                print('$value');
              },
            ),
            CheckboxUic(
              title: 'Show additional description',
              description: 'This is description for checked state.',
              descriptionUnchecked: 'CheckboxUic can show description text, which can be '
                  'individual for each state (checked and unchecked).',
              onChanged: (value) {
                print('$value');
              },
            ),
            CheckboxUic(
              title: 'Disbaled check box',
              description: "Don't set 'onChanged' callback to make the CheckboxUic disabled.",
            ),
            CheckboxUic(
              initialValue: true,
              title: 'Check box that is checked by deafult',
              description: "Use 'initialValue' parameter for initial checkbox state.",
              onChanged: (value) {
                print('$value');
              },
            ),
            CheckboxUic(
              title: 'Check box with custom description view',
              descriptionView: Icon(Icons.sentiment_satisfied,
                color: Colors.greenAccent,
                size: 48.0,
              ),
              descriptionViewUnchecked: Icon(Icons.sentiment_dissatisfied,
                color: Colors.redAccent,
                size: 48.0,
              ),
              onChanged: (value) {
                print('$value');
                final snackBar = SnackBar(content: Text('Checkbox state: $value'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
            CheckboxUic(
              title: "I've reviewed all examples",
              descriptionView: Text('Thank you!'),
              descriptionViewUnchecked: RichText(
                text: TextSpan(
                  text: "You can find more info in ",
                  style: Theme.of(context).textTheme.caption,
                  children: [
                    TextSpan(
                      text: "UIC package docs",
                      style: Theme.of(context).textTheme.caption?.copyWith(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () { launch('https://pub.dev/packages/uic'); }
                    ),
                  ],
                ),
              ),
              onChanged: (value) {
                print('$value');
              },
            ),
          ],
        ),
      ),
    );
  }
}
