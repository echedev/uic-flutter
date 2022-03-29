// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:uic/list_uic.dart';

class ListUicScreen extends StatefulWidget {
  ListUicScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ListUicScreenState createState() => _ListUicScreenState();
}

class _ListUicScreenState extends State<ListUicScreen> {
  late ListUicController<int> _controller;

  int _loadingAttempts = 0;

  @override
  void initState() {
    super.initState();
    _controller = ListUicController<int>(
//      items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
      onGetItems: (int page) => _getItems(page),
//      initialLoading: false,
//      allowPagination: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListUic<int>(
        controller: _controller,
        itemBuilder: (item) {
          return ListTile(
            title: Text('Title $item'),
            subtitle: Text('Subtitle $item'),
          );
        },
//        emptyDataIcon: Icon(Icons.refresh, size: 72.0, color: Colors.amberAccent),
//        emptyDataText: "You don't have any item",
//        emptyDataView: Center(
//          child: Text("Empty",
//            style: Theme.of(context).textTheme.headline1,
//          ),
//        ),
//        emptyErrorIcon: Icon(Icons.error, size: 72.0, color: Colors.redAccent),
//        emptyErrorText: "Data loading failed",
//        emptyErrorView: Center(
//          child: Text("Failed",
//            style: Theme.of(context).textTheme.headline1,
//          ),
//        ),
//        emptyProgressText: "Please wait...",
//        emptyProgressView: Center(
//          child: Text("Wait...",
//            style: Theme.of(context).textTheme.headline1,
//          ),
//        ),
//        errorText: "Something went wrong",
//        errorColor: Colors.orangeAccent,
//        nextPageProgressView: ProgressUic(
//          text: 'Loading...',
//          textLocation: ProgressUicTextLocation.right,
//        ),
      ),
    );
  }

  Future<List<int>> _getItems(int page) async {
    _loadingAttempts++;
    print("_getItems(): page=$page, attemmpt=$_loadingAttempts");
    await Future.delayed(Duration(seconds: 3));
    final result = <int>[];
    if (_loadingAttempts == 1) {
      return result;
    }
    if (_loadingAttempts == 2) {
      return Future.error('Error loading data');
    }
    if (_loadingAttempts == 4) {
      return result;
    }
    if (_loadingAttempts == 6) {
      return Future.error('Error loading data');
    }
    if (page == 11) {
      return result;
    }
    for (int i = 1; i <= 10; i++) {
      result.add((page - 1) * 10 + i);
    }
    return result;
  }
}
