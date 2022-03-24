library list_uic;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'progress_uic.dart';

/// UI component that shows a list of items and controls all related states.
///
/// List UI component display a list of items using [ListView] widget.
/// It requires a [ListUicController] object to manage its states and load data.
/// Beside of [controller] you have to define a [itemBuilder] parameter, which
/// is a function that creates list item widget by the item object.
///
/// ## Data loading
///
/// **ListUic** supports pull-to-refresh gesture to reload the list items.
/// While loading, the progress indicator is displayed. If data loading failed,
/// a snack bar with [errorText] message is shown.
///
/// If controller's `allowPagination` property is set to true, loading data page
/// by page (infinite scrolling) is enabled. When user scroll the list to the end,
/// the next page of data is loading. The controller manages the current page to load.
/// During data loading the [nextPageProgressView] widget is displaying at the
/// end of the list. By default it is a circular progress indicator. You can
/// provide your custom progress widget for it.
///
/// ## Empty state
///
/// When there are no data loaded yet, 'ListUic' can show empty state views.
///
/// Default empty data view shows icon and text in the center of screen and
/// allows user to reload the data. You can provide your own icon and/or text
/// in [emptyDataIcon] and [emptyDataText] parameters. To use your custom view
/// for empty data state set your widget in [emptyDataView] parameter.
///
/// When initial data loading is failed, the empty error view is shown. The
/// default empty error view contains icon and text in the center of screen and
/// allows user to reload the data. You can provide your own icon and/or text
/// in [emptyErrorIcon] and [emptyErrorText] parameters. To use your custom view
/// for empty error state set your widget in [emptyDataView] parameter.
///
/// While initial data loading, the empty progress view is displayed. Default
/// empty progress view shows the circular progress indicator and text. You can
/// your text for empty progress view in [emptyProgressText] parameter or provide
/// your custom empty progress view in [emptyProgressView] parameter.
///
/// See also:
/// * [ListUicController]
/// * [ListUicEmptyView]
/// * [ListUicEmptyProgressView]
/// * [ListUicNextPageProgressView]
/// * [ListView]
///
class ListUic<T> extends StatelessWidget {
  ListUic({
    Key? key,
    required this.controller,
    required this.itemBuilder,
    this.emptyDataIcon = const Icon(
      Icons.sentiment_dissatisfied,
      size: 96.0,
      color: Colors.black26,
    ),
    this.emptyDataText = 'No results',
    Widget? emptyDataView,
    this.emptyErrorIcon = const Icon(
      Icons.error_outline,
      size: 96.0,
      color: Colors.black26,
    ),
    this.emptyErrorText = 'Error loading data',
    Widget? emptyErrorView,
    this.emptyProgressText = 'Loading...',
    Widget? emptyProgressView,
    Widget? nextPageProgressView,
    this.errorText = 'Error loading data',
    this.errorColor = Colors.redAccent,
  })  : assert(emptyDataView != null || emptyDataText.isNotEmpty),
        emptyDataView = emptyDataView ??
            ListUicEmptyView(
                controller: controller,
                icon: emptyDataIcon,
                text: emptyDataText),
        emptyErrorView = emptyErrorView ??
            ListUicEmptyView(
                controller: controller,
                icon: emptyErrorIcon,
                text: emptyErrorText),
        emptyProgressView = emptyProgressView ??
            ListUicEmptyProgressView(text: emptyProgressText),
        nextPageProgressView =
            nextPageProgressView ?? const ListUicNextPageProgressView(),
        super(key: key);

  /// Manages the list state
  final ListUicController<T> controller;

  /// Callback that returns list item widget
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

  /// View to display in the bottom of the list when next page of data is loading.
  final Widget nextPageProgressView;

  /// Text to display in snack bar when data loading is failed
  final String errorText;

  /// Color of the error snack bar
  final Color errorColor;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller.state,
      child: Consumer<ValueNotifier<_ListUicState>>(
        builder: (context, state, child) {
          switch (state.value) {
            case _ListUicState.emptyData:
              return emptyDataView;
            case _ListUicState.emptyProgress:
              return emptyProgressView;
            case _ListUicState.emptyError:
              return emptyErrorView;
            case _ListUicState.data:
            case _ListUicState.progress:
            case _ListUicState.progressNextPage:
            case _ListUicState.error:
              return _buildDataView(context, state.value);
            default:
              return Container();
          }
        },
      ),
    );
  }

  Widget _buildDataView(BuildContext context, _ListUicState state) {
    if (state == _ListUicState.error) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorText),
          behavior: SnackBarBehavior.floating,
          backgroundColor: errorColor,
        ));
//        ScaffoldMessenger.of(context)
//          ..hideCurrentSnackBar()
//          ..showSnackBar(SnackBar(
//            content: Text(errorText),
//            behavior: SnackBarBehavior.floating,
//            backgroundColor: errorColor,
//          ) // SnackBar
//              );
      });
    }
    if (state == _ListUicState.progressNextPage) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        controller.scrollController.animateTo(
            controller.scrollController.position.maxScrollExtent,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 500));
      });
    }
    int itemCount = (state != _ListUicState.progressNextPage)
        ? controller.items.value.length
        : controller.items.value.length + 1;
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.scrollController,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (state == _ListUicState.progressNextPage &&
              index == itemCount - 1) {
            return nextPageProgressView;
          } else {
            return itemBuilder(controller.items.value[index]);
          }
        },
      ),
    );
  }
}

/// Default empty list view.
///
/// Displays icon, text and button to reload the data
///
/// See also:
/// * [ListUic]
///
class ListUicEmptyView extends StatelessWidget {
  const ListUicEmptyView({
    Key? key,
    required this.controller,
    required this.icon,
    required this.text,
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
            child: Text(
              text,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              child: const Text('Refresh'),
              onPressed: () => controller.refresh(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Default progress view for empty list.
///
/// Displays progress indicator and text during the initial data loading
///
/// See also:
/// * [ListUic]
///
class ListUicEmptyProgressView extends StatelessWidget {
  const ListUicEmptyProgressView({
    Key? key,
    this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return ProgressUic(
      text: text,
    );
  }
}

/// Default progress view for when loading next page of data.
///
/// Displays progress indicator at the bottom of the list.
///
/// See also:
/// * [ListUic]
///
class ListUicNextPageProgressView extends StatelessWidget {
  const ListUicNextPageProgressView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 72.0,
      child: ProgressUic(),
    );
  }
}

/// A controller for [ListUic] widget.
///
/// It manages list component states and data.
///
/// 'ListUic' controller is typically stored as a member variable in [State]
/// object and is reused in each [State.build].
///
/// You have to provide the [onGetItems] callback that is used to load list
/// items by specified page.
///
/// Controller implements the following flow:
/// - If the initial data provided in [items] parameter, the list component will
/// shows that data on its creation.
/// - When initial items are not provided or the empty list is provided, and
/// [initialLoading] parameter is set to 'true' the controller will start loading
/// list items.
/// - During initial data loading controller forces the list component to show
/// empty progress view.
/// - If there are no data, an empty data view is shown.
/// - If initial data loading failed, an empty error view is shown.
/// - In normal state, when list items are loaded and shown, pull to refresh
/// gesture is supported to reload the data. The progress indicator is shown
/// during the data loading.
/// - If data loading failed, a snack bar with error message is shown
/// - When [allowPagination] parameter is set to 'true', the page by page
/// (infinite scrolling) is enabled. When user scroll the list to the end, the
/// controller start loading next page of items.
/// - During loading next page of data, controller forces the list component to
/// show progress view at the end of the list.
/// - If next page data loading failed, a snack bar with error message is shown.
///
/// See also:
/// * [ListUic]

class ListUicController<T> {
  ListUicController({
    List<T>? items,
    required this.onGetItems,
    this.initialLoading = true,
    this.allowPagination = true,
  }) {
    _items = ValueNotifier(items ?? <T>[]);
    _page = 1;
    if (_items.value.isEmpty) {
      if (initialLoading) {
        _state = ValueNotifier(_ListUicState.emptyProgress);
        refresh();
      } else {
        _state = ValueNotifier(_ListUicState.emptyData);
      }
    } else {
      _state = ValueNotifier(_ListUicState.data);
    }

    if (allowPagination) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if (_readyForNextPage) {
            _readyForNextPage = false;
            nextPage();
          }
        } else if (_scrollController.position.pixels <=
            _scrollController.position.maxScrollExtent - 10.0) {
          _readyForNextPage = true;
        }
      });
    }
  }

  late final ValueNotifier<_ListUicState> _state;
  ValueNotifier<_ListUicState> get state => _state;

  late final ValueNotifier<List<T>> _items;

  /// Items to show in the list
  ValueNotifier<List<T>> get items => _items;

  /// Whether to load data if there are no initial data provided
  ///
  /// Defaults to 'true'
  bool initialLoading;

  /// Whether pagination is allowed
  ///
  /// Defaults to 'true'
  bool allowPagination;

  late int _page;

  /// Callback to load list items by the page
  Future<List<T>?> Function(int) onGetItems;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  bool _readyForNextPage = true;

  Future<void> refresh() async {
    // Show progress view
    if (_state.value == _ListUicState.emptyData ||
        _state.value == _ListUicState.emptyError) {
      _state.value = _ListUicState.emptyProgress;
    } else if (_state.value != _ListUicState.emptyProgress) {
      _state.value = _ListUicState.progress;
    }
    // Load first page of the data
    _page = 1;
    await _loadItems(_page)
        // Show data
        .then((result) {
      _items.value = result;
      if (_items.value.isEmpty) {
        _state.value = _ListUicState.emptyData;
      } else {
        _state.value = _ListUicState.data;
      }
    })
        // Show error
        .catchError((error) {
      if (_state.value == _ListUicState.emptyProgress) {
        _state.value = _ListUicState.emptyError;
      } else {
        _state.value = _ListUicState.error;
      }
    });
  }

  Future<void> nextPage() async {
    if (_state.value == _ListUicState.progressNextPage) {
      return;
    }
    _state.value = _ListUicState.progressNextPage;
    await _loadItems(_page + 1).then((result) {
      if (result.isNotEmpty) {
        List<T> newItems = _items.value;
        newItems.addAll(result);
        _items.value = newItems;
        _page++;
      }
      _state.value = _ListUicState.data;
    }).catchError((error) {
      _state.value = _ListUicState.error;
    });
  }

  Future<List<T>> _loadItems(int page) async {
    return await onGetItems(page) ?? <T>[];
  }
}

enum _ListUicState {
  emptyData,
  emptyProgress,
  emptyError,
  data,
  progress,
  progressNextPage,
  error
}
