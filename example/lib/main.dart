import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uic/widgets.dart';

import 'listuic_screen.dart';
import 'loginuic_screen.dart';
import 'checkboxuic_screen.dart';
import 'progressuic_screen.dart';

import 'step_indicator.dart';

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
        dividerColor: Colors.transparent,
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            indicatorColor: Theme.of(context).accentColor,
            tabs: [
              Tab(text: 'Components',),
              Tab(text: 'Widgets'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              ListView(
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
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                      title: Text('LoginUic'),
                      subtitle: Text('The component, implementing a login form and Sign In / Sign Up flows.'),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginUicScreen(title: 'LoginUic Demo')),);
                      },
                    ),
                  ),
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
                  Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0, right: 16.0),
                      title: Text('ProgressUic',
                        style: GoogleFonts.robotoMono(
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Use it either as an individual progress indicator '
                            'with additional customizable features, or as a wrapper '
                            'of content view that can be in progress state.'),
                      ),
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              ProgressUicScreen(title: 'ProgressUic Demo')),);
                      },
                    ),
                  ),
                ],
              ),
              ListView(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, ),
                      child: ExpansionTile(
                        title: Text('InlineTextField',
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Makes Text widget editable. Double tap on the text '
                            'will show inline input text field instead of static text.',
                            style: Theme.of(context).textTheme.body2.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                Text('You can '),
                                InlineTextField(
                                  text: 'edit me',
                                  style: Theme.of(context).textTheme.body1.copyWith(
                                    color: Colors.lightBlueAccent,
                                  ),
/*
* Check the commented parameters below to learn available customization options
*/
//                                  child: Row(
//                                    children: [
//                                      Icon(Icons.add, color: Colors.lightBlueAccent,),
//                                      Text('Add text',
//                                        style: Theme.of(context).textTheme.bodyText1.copyWith(
//                                          color: Colors.lightBlueAccent,
//                                        )
//                                      ),
//                                    ],
//                                  ),
//                                  styleEditing: Theme.of(context).textTheme.bodyText1.copyWith(
//                                    color: Colors.lightBlueAccent,
//                                  ),
//                                  decoration: InputDecoration()
//                                    ..applyDefaults(Theme.of(context).inputDecorationTheme),
                                  onEditingComplete: (value) {
                                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context).accentColor,
                                      content: Text(value),
                                    ));
                                  },
                                ),
                                Text(' right here'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, ),
                      child: ExpansionTile(
                        title: Text('StepIndicator',
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Simple, but highly customizable steps (or pages) indicator',
                            style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        children: [
                          ...examplesStepIndicator(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
