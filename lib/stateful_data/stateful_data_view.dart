import 'package:flutter/material.dart';

import '../progress_uic.dart';
import 'stateful_data.dart';

class UicStatefulDataView<T> extends StatefulWidget {
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

  final Widget Function(
      BuildContext context, T? data, StatefulDataError? error)? errorBuilder;

  final Widget? initialLoadingView;

  final Widget? initialLoadingErrorView;

  final Widget? loadingView;

  @override
  _UicStatefulDataViewState<T> createState() => _UicStatefulDataViewState<T>();
}

class _UicStatefulDataViewState<T> extends State<UicStatefulDataView<T>> {
  @override
  void initState() {
    super.initState();
    widget.statefulData.addListener(_onStatefulDataChanged);
  }

  @override
  void didUpdateWidget(UicStatefulDataView<T> oldWidget) {
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
            UicStatefulDataDefaultViews.of(context)?.initialLoading ??
            UicStatefulDataInitialLoadingView(
              text: 'Loading...',
            );
      case StatefulDataState.initialLoadingError:
        return widget.initialLoadingErrorView ??
            UicStatefulDataDefaultViews.of(context)?.initialLoadingError ??
            UicStatefulDataInitialLoadingErrorView(
              statefulData: widget.statefulData,
            );
      case StatefulDataState.empty:
        return widget.emptyView ??
            UicStatefulDataDefaultViews.of(context)?.empty ??
            UicStatefulDataEmptyView(
              statefulData: widget.statefulData,
            );
      case StatefulDataState.ready:
        return widget.builder(context, widget.statefulData.data!);
      case StatefulDataState.loading:
        return widget.loadingView ??
            UicStatefulDataDefaultViews.of(context)?.loading ??
            UicStatefulDataLoadingView(
              child: widget.statefulData.data == null
                  ? SizedBox.shrink()
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
              ? SizedBox.shrink()
              : widget.builder(context, widget.statefulData.data!);
        }
      default:
        return SizedBox.shrink();
    }
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
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UicStatefulDataDefaultViews? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UicStatefulDataDefaultViews>();
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
