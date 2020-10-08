import 'package:flutter/foundation.dart';

class LoadableData<T> extends ValueNotifier<_LoadableDataValue<T>> {
  LoadableData({
    this.isEmpty,
    @required this.onLoad,
  }) : super(_LoadableDataValue<T>()) {
    isEmpty ??= (T data) => data == null;
    loadData();
  }

  bool Function(T data) isEmpty;

  final Future<T> Function() onLoad;

  T get data => value.data;

  LoadableDataError get error => value.error;

  bool get isLoading => value.isLoading;

  LoadableDataState get state {
    if (value.isLoading) {
      if (isEmpty(data)) {
        return LoadableDataState.initialLoading;
      }
      else {
        return LoadableDataState.loading;
      }
    }
    else {
      if (value.error == null) {
        if (isEmpty(data)) {
          return LoadableDataState.empty;
        }
        else {
          return LoadableDataState.ready;
        }
      }
      else {
        if (data == null) {
          return LoadableDataState.initialLoadingError;
        }
        else {
          return LoadableDataState.error;
        }
      }
    }
  }

  Future<void> loadData() async {
    if (!value.isLoading) {
      value = value.copyWith(isLoading: true);
    }
    try {
      T result = await onLoad();
      value = value.copyWith(
        data: result,
        isLoading: false,
      );
    }
    catch (e) {
      value = value.copyWith(
        error: LoadableDataError(message: e.toString()),
        isLoading: false,
      );
    }
  }
}

class _LoadableDataValue<T> {
  _LoadableDataValue({
    this.data,
    this.error,
    this.isLoading = true,
  });

  T data;

  LoadableDataError error;

  bool isLoading;

  _LoadableDataValue<T> copyWith({
    T data,
    LoadableDataError error,
    bool isLoading,
  }) {
    return _LoadableDataValue<T>(
      data: data ?? this.data,
      error: isLoading ? null : (error ?? this.error),
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

enum LoadableDataState {
  initialLoading,
  initialLoadingError,
  empty,
  ready,
  loading,
  error,
}

class LoadableDataError {
  LoadableDataError({
    this.message,
  });

  String message;

}