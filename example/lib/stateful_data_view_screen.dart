import 'package:flutter/material.dart';
import 'package:uic/stateful_data/stateful_data.dart';

class UicStatefulDataViewScreen  extends StatefulWidget {
  UicStatefulDataViewScreen({Key key}) : super(key: key);

  @override
  _UicStatefulDataViewScreenState createState() => _UicStatefulDataViewScreenState();
}

class _UicStatefulDataViewScreenState extends State<UicStatefulDataViewScreen> {

  StatefulData<ExampleData> _data;

  int _loadingAttempts = 0;

  @override
  void initState() {
    super.initState();
    _data = StatefulData<ExampleData>(
//      isEmpty: (data) => true,
      loader: _loadData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LoadableUic Demo'),
      ),
      body: UicStatefulDataView<ExampleData>(
        statefulData: _data,
        builder: (context, data) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${data.header}',
                  style: Theme.of(context).textTheme.headline1,
                ),
                Text('${data.message}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    child: Text('Reload'),
                    onPressed: () => _data.loadData(),
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Future<ExampleData> _loadData() async {
    await Future.delayed(Duration(seconds: 3));
    _loadingAttempts++;

    if (_loadingAttempts == 1) {
      throw Exception();
    }
    else if (_loadingAttempts == 2) {
      return null;
    }
    else if (_loadingAttempts == 3) {
      return ExampleData(
          header: 'Header',
          message: 'This is your content');
    }
    else if (_loadingAttempts == 4) {
      throw Exception();
    }
    return ExampleData(
        header: 'Header',
        message: 'Your content was updated');
  }
}

class ExampleData {
  ExampleData({
    this.header,
    this.message,
  });

  String header;

  String message;

}