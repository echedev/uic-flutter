import 'package:flutter/foundation.dart';

class LoadableData<T> extends ValueNotifier<_LoadableDataValue<T>> {
  LoadableData() : super(_LoadableDataValue<T>());

  T get data => value.data;

  bool get isLoading => value.isLoading;

  LoadableDataState get state {
    if (value.isLoading) {
      if (value.data == null) {
        return LoadableDataState.initialLoading;
      }
      else {
        return LoadableDataState.loading;
      }
    }
    else {
      if (value.error == null) {
        if (data == null) {
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

  T Function() onLoad;

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