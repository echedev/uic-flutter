import 'dart:async';

import 'package:flutter/foundation.dart';

class StatefulData<T> extends ChangeNotifier {
  StatefulData({
    this.isEmptyValidator = _defaultIsEmptyValidator,
    required Future<T?> Function() loader,
  }) {
    _loader = loader;
    _source = null;
    loadData();
  }

  StatefulData.watch({
    this.isEmptyValidator = _defaultIsEmptyValidator,
    required Stream<T?> Function() source,
  }) {
    _loader = null;
    _source = source;
    loadData();
  }

  static bool _defaultIsEmptyValidator(Object? data) => data == null;

  bool Function(T? data) isEmptyValidator;

  late final Future<T?> Function()? _loader;

  late final Stream<T?> Function()? _source;

  StreamSubscription? _subscription;

  T? _data;
  T? get data => _data;

  StatefulDataError? _error;
  StatefulDataError? get error => _error;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
      }
      else {
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

// class StatefulDataValue<T> {
//   StatefulDataValue({
//     this.data,
//     this.error,
//     this.isLoading = true,
//   });
//
//   T? data;
//
//   StatefulDataError? error;
//
//   bool isLoading;
//
//   StatefulDataValue<T> copyWith({
//     T? data,
//     StatefulDataError? error,
//     bool? isLoading,
//   }) {
//     return StatefulDataValue<T>(
//       data: data ?? this.data,
//       error: (isLoading ?? true) ? null : (error ?? this.error),
//       isLoading: isLoading ?? this.isLoading,
//     );
//   }
// }

enum StatefulDataState {
  initialLoading,
  initialLoadingError,
  empty,
  ready,
  loading,
  error,
}

class StatefulDataError {
  StatefulDataError({
    this.message,
    this.originalError,
  });

  String? message;

  Object? originalError;
}
