import 'dart:async';

import 'package:flutter/foundation.dart';

/// A wrapper on data that tracks data state and notifies its listeners on changes.
///
/// It a common case when you have a data that should be loaded from some data source
/// and you need to update your UI according to the current data state - loading, ready or error.
///
/// StatefulData is a wrapper on piece of data of specified type that handles
/// data loading logic and notifies its listeners on data state changes.
/// Supported data states are defined by [StatefulDataState].
///
/// Typically StatefulData is used in couple with [StatefulDataView] widget, that
/// automatically update the UI according to the current state of StatefulData instance.
///
/// See also:
/// - [StatefulDataState]
/// - [StatefulDataError]
/// - [StatefulDataView]
///
class StatefulData<T> extends ChangeNotifier {
  /// Creates an instance of StatefulData.
  ///
  /// A [loader] function for single data loading must be provided.
  ///
  /// If [startLoading] is 'true', that is default behavior, then data loading is
  /// started immediately on creating the object.
  ///
  StatefulData({
    required Future<T?> Function() loader,
    this.isEmptyValidator = _defaultIsEmptyValidator,
    bool startLoading = true,
  }) {
    _loader = loader;
    _source = null;
    if (startLoading) {
      loadData();
    }
  }

  /// Creates an instance of StatefulData, that watches data changes.
  ///
  /// A [source] stream that provides data updates must be defined.
  ///
  StatefulData.watch({
    required Stream<T?> Function() source,
    this.isEmptyValidator = _defaultIsEmptyValidator,
  }) {
    _loader = null;
    _source = source;
    loadData();
  }

  static bool _defaultIsEmptyValidator(Object? data) => data == null;

  /// Checks if the data is empty.
  ///
  /// Default behavior is to check if the data object is 'null'.
  ///
  /// Possible alternate behavior could be set when the data is a list. In this
  /// case validator could check if the list does contain any item or not.
  ///
  bool Function(T? data) isEmptyValidator;

  late final Future<T?> Function()? _loader;

  late final Stream<T?> Function()? _source;

  StreamSubscription? _subscription;

  T? _data;

  /// Current instance of data.
  ///
  T? get data => _data;

  StatefulDataError? _error;

  /// A last error that happened on data loading.
  ///
  /// It contains a value when the [state] is either [StatefulDataState.initialLoadingError]
  /// or [StatefulDataState.error].
  ///
  StatefulDataError? get error => _error;

  bool _isLoading = false;

  /// Indicates that data is loading.
  ///
  bool get isLoading => _isLoading;

  /// Current state of the data.
  ///
  /// Possible options are defined by [StatefulDataState].
  ///
  StatefulDataState get state {
    if (_isLoading) {
      if (isEmptyValidator.call(data)) {
        return StatefulDataState.initialLoading;
      } else {
        return StatefulDataState.loading;
      }
    } else {
      if (_error == null) {
        if (isEmptyValidator.call(data)) {
          return StatefulDataState.empty;
        } else {
          return StatefulDataState.ready;
        }
      } else {
        if (data == null) {
          return StatefulDataState.initialLoadingError;
        } else {
          return StatefulDataState.error;
        }
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  /// Loads the data.
  ///
  /// To get the data it either calls [loader] function or listen the [source] stream.
  ///
  /// Updates the data state and notify listeners of [StatefulData] object on changes.
  ///
  Future<void> loadData() async {
    if (!_isLoading) {
      _error = null;
      _isLoading = true;
      notifyListeners();
    }
    try {
      // One-time data loading
      if (_loader != null) {
        _data = await _loader!();
        _error = null;
        _isLoading = false;
        notifyListeners();
      }
      // Watching on data changes
      else if (_source != null) {
        await _subscription?.cancel();
        _subscription = _source!().listen(
          (result) {
            _data = result;
            _error = null;
            _isLoading = false;
            notifyListeners();
          },
          onError: (error) {
            _error = StatefulDataError(
              message: 'Unexpected error while watching the data',
              originalError: error,
            );
            _isLoading = false;
            notifyListeners();
          },
          cancelOnError: false,
        );
      } else {
        // We should not hit this branch.
        throw Exception('StatefulData must have either "loader" or "watcher"');
      }
    } catch (e) {
      _error = StatefulDataError(message: e.toString(), originalError: e);
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}

/// List of possible states of the data.
///
enum StatefulDataState {
  /// Data is loading at the first time, or the previously loaded data was empty.
  ///
  initialLoading,

  /// An error occurred on initial data loading.
  ///
  initialLoadingError,

  /// Data was successfully loaded but it is empty.
  ///
  empty,

  /// Data was successfully loaded and its value is available.
  ///
  ready,

  /// Data loading is in progress.
  ///
  loading,

  /// An error occurred on data loading.
  ///
  error,
}

/// An error that might happen during the data loading.
///
class StatefulDataError {
  /// Creates an instance of StatefulDataError.
  ///
  StatefulDataError({
    this.message,
    this.originalError,
  });

  /// Error message.
  ///
  String? message;

  /// Original error.
  ///
  Object? originalError;
}
