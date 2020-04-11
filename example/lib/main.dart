import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'listuic_screen.dart';
//import 'loginuic_screen.dart';
import 'checkboxuic_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UIC Demo',
      theme: Theme.of(context).copyWith(
        primaryColor: Colors.blueGrey,
        accentColor: Colors.amber,
        toggleableActiveColor: Colors.amber,
      ),
      home: MyHomePage(title: 'UIC Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                title: Text('ListUic'),
                subtitle: Text('Wrapper of ListView, which implements related data '
                    'loading and state management logic.'),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListUicScreen(title: 'ListUic Demo')),);
                },
              ),
            ),
//            Card(
//              child: ListTile(
//                title: Text('LoginUic'),
//                subtitle: Text('The component, implementing a login form and Sign In / Sign Up flows.'),
//                onTap: () {
//                  Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => LoginUicScreen(title: 'LoginUic Demo')),);
//                },
//              ),
//            ),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                title: Text('CheckboxUic'),
                subtitle: Text('Enhanced checkbox that maintain its state, has a'
                    'title and can show additional description in each state.'),
                onTap: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        CheckboxUicScreen(title: 'CheckboxUic Demo')),);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
