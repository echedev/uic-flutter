import 'package:flutter/material.dart';

import 'stateful_data_default_views.dart';
import 'stateful_data_model.dart';

/// A widget to display [StatefulData] according to its state.
///
/// StatefulDataView listens provided [statefulData] instance and updates the UI
/// according to the data state.
///
/// When the data is ready, the [builder] function is used to display data view.
///
/// To display accompanying states, optional [emptyView], [errorBuilder], [initialLoadingView],
/// [initialLoadingErrorView] and [loadingView] parameters could be passed.
///
/// You can set common data state views for all [StatefulDataView] widgets
/// by placing [StatefulDataDefaultViews] widget somewhere upper in the widget tree.
///
/// If some of those values are missed, then default views will be used for corresponding states.
///
/// See also:
/// - [StatefulData]
/// - [StatefulDataState]
/// - [StatefulDataError]
/// - [StatefulDataDefaultViews]
///
class StatefulDataView<T> extends StatefulWidget {
  /// Creates [StatefulDataView] widget.
  ///
  const StatefulDataView({
    Key? key,
    required this.statefulData,
    required this.builder,
    this.emptyView,
    this.errorBuilder,
    this.initialLoadingView,
    this.initialLoadingErrorView,
    this.loadingView,
  }) : super(key: key);

  /// An instance of [StatefulData] of specified type.
  ///
  final StatefulData<T> statefulData;

  /// A function to build a widget that represent a provided data instance.
  ///
  final Widget Function(BuildContext context, T data) builder;

  /// A widget to display in case of empty data.
  ///
  /// If it is not specified, the widget provided by nearest [StatefulDataDefaultViews] will be used.
  /// In case it is also not specified, then [StatefulDataEmptyView] widget is displayed.
  ///
  final Widget? emptyView;

  /// A function that build a widget in case of error.
  ///
  /// Current [data] instance and [error] are provided in parameters of this callback function.
  ///
  final Widget Function(
      BuildContext context, T? data, StatefulDataError? error)? errorBuilder;

  /// A widget to display during initial data loading.
  ///
  /// If it is not specified, the widget provided by nearest [StatefulDataDefaultViews] will be used.
  /// In case it is also not specified, then [StatefulDataInitialLoadingView] widget is displayed.
  ///
  final Widget? initialLoadingView;

  /// A widget to display in case of initial data loading failed.
  ///
  /// If it is not specified, the widget provided by nearest [StatefulDataDefaultViews] will be used.
  /// In case it is also not specified, then [StatefulDataInitialLoadingErrorView] widget is displayed.
  ///
  final Widget? initialLoadingErrorView;

  /// A widget to display during data loading.
  ///
  /// If it is not specified, the widget provided by nearest [StatefulDataDefaultViews] will be used.
  /// In case it is also not specified, then [StatefulDataLoadingView] widget is displayed.
  ///
  final Widget? loadingView;

  @override
  _StatefulDataViewState<T> createState() => _StatefulDataViewState<T>();
}

class _StatefulDataViewState<T> extends State<StatefulDataView<T>> {
  @override
  void initState() {
    super.initState();
    widget.statefulData.addListener(_onStatefulDataChanged);
  }

  @override
  void didUpdateWidget(StatefulDataView<T> oldWidget) {
    if (widget.statefulData != oldWidget.statefulData) {
      oldWidget.statefulData.removeListener(_onStatefulDataChanged);
      widget.statefulData.addListener(_onStatefulDataChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.statefulData.removeListener(_onStatefulDataChanged);
    super.dispose();
  }

  void _onStatefulDataChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.statefulData.state) {
      case StatefulDataState.initialLoading:
        return widget.initialLoadingView ??
            StatefulDataDefaultViews.of(context)?.initialLoading ??
            const StatefulDataInitialLoadingView(
              text: 'Loading...',
            );
      case StatefulDataState.initialLoadingError:
        return widget.initialLoadingErrorView ??
            StatefulDataDefaultViews.of(context)?.initialLoadingError ??
            StatefulDataInitialLoadingErrorView(
              statefulData: widget.statefulData,
            );
      case StatefulDataState.empty:
        return widget.emptyView ??
            StatefulDataDefaultViews.of(context)?.empty ??
            StatefulDataEmptyView(
              statefulData: widget.statefulData,
            );
      case StatefulDataState.ready:
        return widget.builder(context, widget.statefulData.data!);
      case StatefulDataState.loading:
        return widget.loadingView ??
            StatefulDataDefaultViews.of(context)?.loading ??
            StatefulDataLoadingView(
              child: widget.statefulData.data == null
                  ? const SizedBox.shrink()
                  : widget.builder(context, widget.statefulData.data!),
            );
      case StatefulDataState.error:
        if (widget.errorBuilder != null) {
          return widget.errorBuilder!(
              context, widget.statefulData.data, widget.statefulData.error);
        } else {
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(widget.statefulData.error?.message ?? ''),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.redAccent,
              ));
          });
          return widget.statefulData.data == null
              ? const SizedBox.shrink()
              : widget.builder(context, widget.statefulData.data!);
        }
      default:
        return const SizedBox.shrink();
    }
  }
}
