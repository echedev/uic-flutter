import 'package:flutter/material.dart';

import '../progress_uic.dart';

import 'package:uic/stateful_data/stateful_data.dart';

class UicStatefulDataView<T> extends StatelessWidget {
  UicStatefulDataView({
    Key? key,
    required this.statefulData,
    required this.builder,
    this.emptyView,
    this.errorBuilder,
    this.initialLoadingView,
    this.initialLoadingErrorView,
    this.loadingView,
  }) : super(key: key);

  final StatefulData<T> statefulData;

  final Widget Function(BuildContext context, T data) builder;

  final Widget? emptyView;

  final Widget Function(BuildContext context, T? data, StatefulDataError? error)? errorBuilder;

  final Widget? initialLoadingView;

  final Widget? initialLoadingErrorView;

  final Widget? loadingView;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StatefulDataValue<T>>(
      valueListenable: statefulData,
      builder: (context, value, child) {
        switch (statefulData.state) {
          case StatefulDataState.initialLoading:
            return initialLoadingView ??
                UicStatefulDataDefaultViews.of(context)?.initialLoading ??
                UicStatefulDataInitialLoadingView(
                  text: 'Loading...',
                );
          case StatefulDataState.initialLoadingError:
            return initialLoadingErrorView ??
                UicStatefulDataDefaultViews.of(context)?.initialLoadingError ??
                UicStatefulDataInitialLoadingErrorView(
                  statefulData: statefulData,
                );
          case StatefulDataState.empty:
            return emptyView ??
                UicStatefulDataDefaultViews.of(context)?.empty ??
                UicStatefulDataEmptyView(
                  statefulData: statefulData,
                );
          case StatefulDataState.ready:
            return builder(context, value.data!);
          case StatefulDataState.loading:
            return loadingView ??
                UicStatefulDataDefaultViews.of(context)?.loading ??
                UicStatefulDataLoadingView(
                  child: value.data == null ? SizedBox.shrink() : builder(context, value.data!),
                );
          case StatefulDataState.error:
            if (errorBuilder != null) {
              return errorBuilder!(
                  context, value.data, value.error);
            } else {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //   content: Text(loadableData.error?.message ?? ''),
                //   behavior: SnackBarBehavior.floating,
                //   backgroundColor: Colors.redAccent,
                // ));
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                    content: Text(value.error?.message ?? ''),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.redAccent,
                  ) // SnackBar
                  );
              });
              return value.data == null ? SizedBox.shrink() : builder(context, value.data!);
            }
          default:
            return SizedBox.shrink();
        }
      },
    );
  }
}

class UicStatefulDataDefaultViews extends InheritedWidget {
  UicStatefulDataDefaultViews({
    Key? key,
    this.empty,
    this.initialLoading,
    this.initialLoadingError,
    this.loading,
    required Widget child,
  }) : super(child: child);
  // TODO: Add assert if no views are defined

  final Widget? empty;

  final Widget? initialLoading;

  final Widget? initialLoadingError;

  final Widget? loading;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static UicStatefulDataDefaultViews? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UicStatefulDataDefaultViews>();
  }
}

class UicStatefulDataEmptyView extends StatelessWidget {
  UicStatefulDataEmptyView({
    Key? key,
    required this.statefulData,
  }) : super(key: key);

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
              child: Text('Try again'),
              onPressed: () => statefulData.loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

class UicStatefulDataInitialLoadingView extends StatelessWidget {
  UicStatefulDataInitialLoadingView({
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

class UicStatefulDataInitialLoadingErrorView extends StatelessWidget {
  UicStatefulDataInitialLoadingErrorView({
    Key? key,
    required this.statefulData,
  }) : super(key: key);

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
            child: RaisedButton(
              child: Text('Try again'),
              onPressed: () => statefulData.loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

class UicStatefulDataLoadingView extends StatelessWidget {
  UicStatefulDataLoadingView({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ProgressUic(
      child: child,
      dimContent: true,
    );
  }
}
