// ignore_for_file: public_member_api_docs

import 'package:example/table_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uic/widgets.dart';

import 'listuic_screen.dart';
import 'responsive_layout_screen.dart';
import 'stateful_data_view_screen.dart';
import 'loginuic_screen.dart';
import 'checkboxuic_screen.dart';
import 'progressuic_screen.dart';

import 'action_button.dart';
import 'deck.dart';
import 'step_indicator.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UIC Demo',
      theme: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blueGrey,
              secondary: Colors.amber,
            ),
        primaryColor: Colors.blueGrey,
        toggleableActiveColor: Colors.amber,
        dividerColor: Colors.transparent,
      ),
      home: const MyHomePage(title: 'UIC Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
            indicatorColor: Theme.of(context).colorScheme.secondary,
            tabs: const [
              Tab(
                text: 'Components',
              ),
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
                  ComponentsItem(
                    title: 'ListUic',
                    subtitle:
                        'Wrapper of ListView, which implements related data '
                        'loading and state management logic.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ListUicScreen(title: 'ListUic Demo')),
                      );
                    },
                  ),
                  ComponentsItem(
                    title: 'StatefulData and StatefulDataView',
                    subtitle:
                        'StatefulData is an observable data model that provides interface for implementing data loading logic and notifies its listeners when the data state changed. '
                        'StatefulDataView listens the data state and displays the data when it is ready, or loading or error views on corresponding data states.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const UicStatefulDataViewScreen()),
                      );
                    },
                  ),
                  ComponentsItem(
                    title: 'ResponsiveLayout and FormFactors',
                    subtitle:
                        'Allows to easily show content on multiple screen sizes and platforms. '
                        'Define form factors that your app will support and wrap matched views in ResponsiveLayout widget, '
                        'which will automatically update the layout depending on current screen size and orientation.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResponsiveApp()),
                      );
                    },
                  ),
                  ComponentsItem(
                    title: 'TableView',
                    subtitle:
                    'TableView.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TableViewScreen()),
                      );
                    },
                  ),
                  ComponentsItem(
                    title: 'LoginUic',
                    subtitle:
                        'A Login form, that hides most of the UI logic under the hood, but still customizable to fit your app design.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const LoginUicScreen(title: 'LoginUic Demo')),
                      );
                    },
                  ),
                  ComponentsItem(
                    title: 'CheckboxUic',
                    subtitle: 'Enhanced checkbox that maintain its state, has a'
                        'title and can show additional description in each state.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CheckboxUicScreen(title: 'CheckboxUic Demo')),
                      );
                    },
                  ),
                  ComponentsItem(
                    title: 'ProgressUic',
                    subtitle:
                        'Use it either as an individual progress indicator '
                        'with additional customizable features, or as a wrapper '
                        'of content view that can be in progress state.',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProgressUicScreen(
                                title: 'ProgressUic Demo')),
                      );
                    },
                  ),
                ],
              ),
              ListView(
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'ActionButton',
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'A wrapper on button, that manages an action state, '
                            'and allows to lock the button and to change its appearance '
                            'while the action is in progress.',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Colors.black54,
                                    ),
                          ),
                        ),
                        children: [
                          ...examplesActionButton(context, _scaffoldKey),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'Deck',
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Displays stacked cards where only headers visible initially, '
                            'and allows to expand each card',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Colors.black54,
                                    ),
                          ),
                        ),
                        children: [
                          ...examplesDeck(context),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'InlineTextField',
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Makes Text widget editable. Double tap on the text '
                            'will show inline input text field instead of static text.',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Colors.black54,
                                    ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: <Widget>[
                                const Text('You can '),
                                InlineTextField(
                                  text: 'edit me',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
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
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      content: Text(value),
                                    ));
                                  },
                                ),
                                const Text(' right here'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'StepIndicator',
                          style: GoogleFonts.robotoMono(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Simple, but highly customizable steps (or pages) indicator',
                            style:
                                Theme.of(context).textTheme.bodyText1?.copyWith(
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

class ComponentsItem extends StatelessWidget {
  const ComponentsItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  final String title;

  final String subtitle;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        title: Text(
          title,
          style: GoogleFonts.robotoMono(
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  color: Colors.black54,
                ),
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
