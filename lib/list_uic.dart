library list_uic;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Default empty view shows icon and text in the center of screen. You can
/// provide your own icon and/or text in [emptyIcon] and [emptyText] parameters.
/// To use your custom view for empty state set [emptyView] parameter.
///
/// See also:
///
/// * [ListUicEmptyDataView]
class ListUic<T> extends StatelessWidget {
  ListUic({
    Key key,
    @required this.controller,
    @required this.itemBuilder,
    this.emptyIcon = const Icon(Icons.sentiment_dissatisfied, size: 96.0,),
    this.emptyText = 'No results',
    Widget emptyView,
  }) : assert(emptyView != null || emptyText != null),
        emptyView = emptyView ?? ListUicEmptyDataView(icon: emptyIcon, text: emptyText),
        super(key: key);

  final ListUicController controller;

  ///
  final IndexedWidgetBuilder itemBuilder;

  /// Icon to display in default empty view
  ///
  /// See also:
  ///
  /// * [ListUicEmptyDataView]
  final Icon emptyIcon;

  /// Text to display in default empty view
  final String emptyText;

  /// View to display when the list is empty.
  final Widget emptyView;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller.items,
      child: Consumer<ValueNotifier<StatefulData<List<T>>>>(
        builder: (context, data, child) {
          return Stack(
            children: <Widget>[
              if (data.value.isEmpty && !data.value.isLoading)
                emptyView,
              if (!data.value.isEmpty)
                ListUicDataView(
                  itemBuilder: itemBuilder,),

            ],
          );
        },
      ),
    );
  }

}

class ListUicDataView extends StatelessWidget {
  const ListUicDataView({
    Key key,
    this.itemBuilder,
  }) : super(key: key);

  ///
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: itemBuilder,
    );
  }
}

class ListUicEmptyDataView extends StatelessWidget {
  const ListUicEmptyDataView({
    Key key,
    this.icon,
    this.text,
  }) : super(key: key);

  final Icon icon;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          icon,
          Text(text,
            style: Theme.of(context).textTheme.headline,
          ),
        ],
      ),
    );
  }
}

class ListUicController<T> {
  ListUicController({
    List<T> items
  });

  ValueNotifier<StatefulData<List<T>>> _items;

  ValueNotifier<StatefulData<List<T>>> get items => _items;

  int _page = 1;

  Function getItems;

  Future<void> refresh() async {
    _page = 1;
    List<T> result = await getItems(_page);
//    items = result;
  }

  Future<void> nextPage() async {
    _page++;
    List<T> result = await getItems(_page);
//    items.addAll(result);
  }
}

class StatefulData<T> {
  StatefulData({
    this.data,
    this.isEmpty,
    this.isLoading,
    this.isError,
    this.error,
  });

  T data;
  bool isEmpty;
  bool isLoading;
  bool isError;
  String error;

  StatefulData<T> copyWith({
    T data,
    bool isEmpty,
    bool isLoading,
    bool isError,
    String error,
  }) {
    return StatefulData(
      data: data ?? this.data,
      isEmpty: isEmpty ?? this.isEmpty,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      error: error ?? this.error,
    );
  }
}