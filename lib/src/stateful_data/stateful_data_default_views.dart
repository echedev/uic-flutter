import 'package:flutter/material.dart';

import '../../progress_uic.dart';
import 'stateful_data_model.dart';

/// Provides default views for [StatefulDataView] widgets placed below in the widget tree.
///
/// It is useful when the same data state views can be used by multiple [StatefulDataView] widgets.
/// So they could be specified once by this [StatefulDataDefaultViews] widget,
/// and then be accessed by [StatefulDataView] or other widgets.
///
/// This widget must be placed upper in the widget tree than any widget interested in
/// views defined by it.
///
/// See also:
/// - [StatefulDataEmptyView]
/// - [StatefulDataInitialLoadingView]
/// - [StatefulDataInitialLoadingErrorView]
/// - [StatefulDataLoadingView]
///
class StatefulDataDefaultViews extends InheritedWidget {
  /// Creates an instance of [StatefulDataDefaultViews].
  ///
  const StatefulDataDefaultViews({
    Key? key,
    this.empty,
    this.initialLoading,
    this.initialLoadingError,
    this.loading,
    required Widget child,
  })  : assert(
            empty != null ||
                initialLoading != null ||
                initialLoadingError != null ||
                loading != null,
            'At least one of "empty", "initialLoading", "initialLoadingError" or "loading" should be specified. '
            'Otherwise this instance of "StatefulDataDefaultViews" does not make sense.'),
        super(key: key, child: child);

  /// A widget to display in case of empty data.
  ///
  final Widget? empty;

  /// A widget to display during initial data loading.
  ///
  final Widget? initialLoading;

  /// A widget to display in case of initial data loading failed.
  ///
  final Widget? initialLoadingError;

  /// A widget to display during data loading.
  ///
  final Widget? loading;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static StatefulDataDefaultViews? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<StatefulDataDefaultViews>();
  }
}

/// Default implementation of empty data view.
///
class StatefulDataEmptyView extends StatelessWidget {
  /// Creates an instance of [StatefulDataEmptyView].
  const StatefulDataEmptyView({
    Key? key,
    required this.statefulData,
  }) : super(key: key);

  /// An instance of [StatefulData].
  ///
  final StatefulData statefulData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.sentiment_dissatisfied,
            size: 96.0,
            color: Colors.black26,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'No results',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              child: const Text('Try again'),
              onPressed: () => statefulData.loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Default implementation of initial data loading view.
///
/// Displays a progress indicator with optional text below.
///
class StatefulDataInitialLoadingView extends StatelessWidget {
  /// Creates an instance of [StatefulDataInitialLoadingView].
  ///
  const StatefulDataInitialLoadingView({
    Key? key,
    this.text,
  }) : super(key: key);

  /// Text to display while data is loading.
  ///
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ProgressUic(
      text: text,
    );
  }
}

/// Default implementation of initial data loading error view.
///
class StatefulDataInitialLoadingErrorView extends StatelessWidget {
  /// Creates an instance of [StatefulDataInitialLoadingErrorView].
  ///
  const StatefulDataInitialLoadingErrorView({
    Key? key,
    required this.statefulData,
  }) : super(key: key);

  /// An instance of [StatefulData].
  ///
  final StatefulData statefulData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 96.0,
            color: Colors.black26,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              statefulData.error?.message ?? '',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              child: const Text('Try again'),
              onPressed: () => statefulData.loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Default implementation of data loading view.
///
/// Displays a progress indicator on top of dimmed current content view.
///
class StatefulDataLoadingView extends StatelessWidget {
  /// Creates an instance of [StatefulDataLoadingView].
  ///
  const StatefulDataLoadingView({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// A current content that will be dimmed.
  /// 
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProgressUic(
      child: child,
      dimContent: true,
    );
  }
}
