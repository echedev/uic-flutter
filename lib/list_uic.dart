library list_uic;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'progress_uic.dart';

/// Default empty view shows icon and text in the center of screen. You can
/// provide your own icon and/or text in [emptyDataIcon] and [emptyDataText] parameters.
/// To use your custom view for empty state set [emptyDataView] parameter.
///
/// See also:
///
/// * [ListUicEmptyDataView]
/// * [ListUicEmptyProgressView]
///
class ListUic<T> extends StatelessWidget {
  ListUic({
    Key key,
    @required this.controller,
    @required this.itemBuilder,
    this.emptyDataIcon = const Icon(Icons.sentiment_dissatisfied,
      size: 96.0, color: Colors.black26,),
    this.emptyDataText = 'No results',
    Widget emptyDataView,
    this.emptyErrorIcon = const Icon(Icons.error_outline,
      size: 96.0, color: Colors.black26,),
    this.emptyErrorText = 'Error loading data',
    Widget emptyErrorView,
    this.emptyProgressText = 'Loading...',
    Widget emptyProgressView,
  }) : assert(emptyDataView != null || emptyDataText != null),
        emptyDataView = emptyDataView ?? ListUicEmptyDataView(
            controller: controller,
            icon: emptyDataIcon,
            text: emptyDataText),
        emptyErrorView = emptyDataView ?? ListUicEmptyDataView(
            controller: controller,
            icon: emptyErrorIcon,
            text: emptyErrorText),
        emptyProgressView = emptyProgressView ?? ListUicEmptyProgressView(text: emptyProgressText),
        super(key: key);

  ///
  final ListUicController<T> controller;

  ///
  final Widget Function(T item) itemBuilder;

  /// Icon to display in default empty data view
  final Icon emptyDataIcon;

  /// Text to display in default empty data view
  final String emptyDataText;

  /// View to display when the list is empty.
  final Widget emptyDataView;

  /// Icon to display in default empty error view
  final Icon emptyErrorIcon;

  /// Text to display in default empty error view
  final String emptyErrorText;

  /// View to display when the initial data loading is failed.
  final Widget emptyErrorView;

  /// Text to display in default empty progress view
  final String emptyProgressText;

  /// View to display when the initial data loading is in progress.
  final Widget emptyProgressView;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller.state,
      child: Consumer<ValueNotifier<ListUicState>>(
        builder: (context, state, child) {
          switch (state.value) {
            case ListUicState.emptyData:
              return emptyDataView;
            case ListUicState.emptyProgress:
              return emptyProgressView;
            case ListUicState.emptyError:
              return emptyErrorView;
            case ListUicState.data:
              return _dataView();
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget _dataView() {
    return ListView.builder(
      itemCount: controller.items.value.length,
      itemBuilder: (context, index) {
        return itemBuilder(controller.items.value[index]);
      },
    );
  }
}

class ListUicEmptyDataView extends StatelessWidget {
  const ListUicEmptyDataView({
    Key key,
    @required this.controller,
    this.icon,
    this.text,
  }) : super(key: key);

  final ListUicController controller;

  final Icon icon;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(text,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
              child: Text('Refresh'),
              onPressed: () => controller.refresh(),
            ),
          ),
        ],
      ),
    );
  }
}

class ListUicEmptyProgressView extends StatelessWidget {
  const ListUicEmptyProgressView({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return ProgressUic(
      text: text,
    );
  }
}

class ListUicController<T> {
  ListUicController({
    List<T> items,
    @required this.onGetItems,
    this.initialLoading = true,
  }) {
    _items = ValueNotifier(items ?? List());
    _page = 1;
    if (_items.value.isEmpty) {
      if (initialLoading) {
        _state = ValueNotifier(ListUicState.emptyProgress);
        refresh();
      }
      else {
        _state = ValueNotifier(ListUicState.emptyData);
      }
    }
    else {
      _state = ValueNotifier(ListUicState.data);
    }
  }

  ValueNotifier<ListUicState> _state;
  ValueNotifier<ListUicState> get state => _state;

  ValueNotifier<List<T>> _items;
  ValueNotifier<List<T>> get items => _items;

  bool initialLoading;

  int _page;

  Future<List<T>> Function(int) onGetItems;

  Future<void> refresh() async {
    // Show progress view
    if (_state.value == ListUicState.emptyData
          || _state.value == ListUicState.emptyError) {
      _state.value = ListUicState.emptyProgress;
    }
    // Load first page of the data
    _page = 1;
    _loadItems()
        // Show data
        .then((result) {
          _items.value = result;
          if (_items.value.isEmpty) {
            _state.value = ListUicState.emptyData;
          }
          else {
            _state.value = ListUicState.data;
          }
        })
        // Show error
        .catchError((error) {
          _state.value = ListUicState.emptyError;
        });
  }

  Future<void> nextPage() async {
    _page++;
    List<T> result = await _loadItems();
    result.addAll(await onGetItems(_page));
    items.value = result;
  }

  Future<List<T>> _loadItems() async {
    return await onGetItems(_page) ?? List();
  }
}

enum ListUicState { init,
                      emptyData, emptyProgress, emptyError,
                      data, progress, error }
