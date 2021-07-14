import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:uic/stateful_data/stateful_data.dart';
import '../progress_uic.dart';

class LoadableUic<T> extends StatelessWidget {
  LoadableUic({
    Key? key,
    required this.builder,
    this.emptyView,
    this.errorBuilder,
    this.initialLoadingView,
    this.initialLoadingErrorView,
    required this.loadableData,
    this.loadingView,
  }) : super(key: key);

  final Widget Function(BuildContext context, T data) builder;

  final Widget? emptyView;

  final Widget Function(BuildContext context, T? data, StatefulDataError? error)?
      errorBuilder;

  final Widget? initialLoadingView;

  final Widget? initialLoadingErrorView;

  final StatefulData<T> loadableData;

  final Widget? loadingView;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: loadableData,
      child: Consumer<StatefulData<T>>(
        builder: (context, loadableData, child) {
          switch (loadableData.state) {
            case StatefulDataState.initialLoading:
              return initialLoadingView ??
                  LoadableUicViews.of(context)?.initialLoading ??
                  LoadableUicInitialLoadingView(
                    text: 'Loading...',
                  );
            case StatefulDataState.initialLoadingError:
              return initialLoadingErrorView ??
                  LoadableUicViews.of(context)?.initialLoadingError ??
                  LoadableUicInitialLoadingErrorView(
                    loadableData: loadableData,
                  );
            case StatefulDataState.empty:
              return emptyView ??
                  LoadableUicViews.of(context)?.empty ??
                  LoadableUicEmptyView(
                    loadableData: loadableData,
                  );
            case StatefulDataState.ready:
              return builder(context, loadableData.data!);
            case StatefulDataState.loading:
              return loadingView ??
                  LoadableUicViews.of(context)?.loading ??
                  LoadableUicLoadingView(
                    child: loadableData.data == null ? SizedBox.shrink() : builder(context, loadableData.data!),
                  );
            case StatefulDataState.error:
              if (errorBuilder != null) {
                return errorBuilder!(
                    context, loadableData.data, loadableData.error);
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
                     content: Text(loadableData.error?.message ?? ''),
                     behavior: SnackBarBehavior.floating,
                     backgroundColor: Colors.redAccent,
                   ) // SnackBar
                       );
                });
                return loadableData.data == null ? SizedBox.shrink() : builder(context, loadableData.data!);
              }
          }
          return Container();
        },
      ),
    );
  }
}

class LoadableUicViews extends InheritedWidget {
  LoadableUicViews({
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

  static LoadableUicViews? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LoadableUicViews>();
  }
}

class LoadableUicEmptyView extends StatelessWidget {
  LoadableUicEmptyView({
    Key? key,
    required this.loadableData,
  }) : super(key: key);

  final StatefulData loadableData;

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
              onPressed: () => loadableData.loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadableUicInitialLoadingView extends StatelessWidget {
  LoadableUicInitialLoadingView({
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

class LoadableUicInitialLoadingErrorView extends StatelessWidget {
  LoadableUicInitialLoadingErrorView({
    Key? key,
    required this.loadableData,
  }) : super(key: key);

  final StatefulData loadableData;

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
              loadableData.error?.message ?? '',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RaisedButton(
              child: Text('Try again'),
              onPressed: () => loadableData.loadData(),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadableUicLoadingView extends StatelessWidget {
  LoadableUicLoadingView({
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
