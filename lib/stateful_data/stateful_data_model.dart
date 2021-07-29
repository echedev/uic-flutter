import 'dart:async';

import 'package:flutter/foundation.dart';

class StatefulData<T> extends ValueNotifier<StatefulDataValue<T>> {
  StatefulData({
    this.isEmptyValidator = _defaultIsEmptyValidator,
    required Future<T?> Function() loader,
  }) : super(StatefulDataValue<T>()) {
    _loader = loader;
    _source = null;
    loadData();
  }

  StatefulData.watch({
    this.isEmptyValidator = _defaultIsEmptyValidator,
    required Stream<T?> Function() source,
  }) : super(StatefulDataValue<T>()) {
    _loader = null;
    _source = source;
    loadData();
  }

  static bool _defaultIsEmptyValidator(dynamic data) => data == null;

  bool Function(T? data) isEmptyValidator;

  late final Future<T?> Function()? _loader;

  late final Stream<T?> Function()? _source;

  StreamSubscription? _subscription;

  T? get data => value.data;

  StatefulDataError? get error => value.error;

  bool get isLoading => value.isLoading;

  StatefulDataState get state {
    if (value.isLoading) {
      if (isEmptyValidator.call(data)) {
        return StatefulDataState.initialLoading;
      } else {
        return StatefulDataState.loading;
      }
    } else {
      if (value.error == null) {
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
    if (!value.isLoading) {
      value = value.copyWith(isLoading: true);
    }
    try {
      // One-time data loading
      if (_loader != null) {
        T? result = await _loader!();
        value = value.copyWith(
          data: result,
          isLoading: false,
        );
      }
      // Watching on data changes
      else if (_source != null) {
        await _subscription?.cancel();
        _subscription = _source!().listen(
          (result) {
            value = value.copyWith(
              data: result,
              isLoading: false,
            );
          },
          onError: (error) {
            value = value.copyWith(
              error: StatefulDataError(
                message: 'Unexpected error while watching the data',
                originalError: error,
              ),
              isLoading: false,
            );
          },
          cancelOnError: false,
        );
      }
      else {
        // We should not hit this branch.
        throw Exception('StatefulData must have either "loader" or "watcher"');
      }
    } catch (e) {
      value = value.copyWith(
        error: StatefulDataError(message: e.toString(), originalError: e),
        isLoading: false,
      );
      rethrow;
    }
  }
}

class StatefulDataValue<T> {
  StatefulDataValue({
    this.data,
    this.error,
    this.isLoading = true,
  });

  T? data;

  StatefulDataError? error;

  bool isLoading;

  StatefulDataValue<T> copyWith({
    T? data,
    StatefulDataError? error,
    bool? isLoading,
  }) {
    return StatefulDataValue<T>(
      data: data ?? this.data,
      error: (isLoading ?? true) ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

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
