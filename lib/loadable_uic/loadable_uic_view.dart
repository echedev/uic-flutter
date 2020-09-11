import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uic/loadable_uic/loadable_uic.dart';

class LoadableUic<T> extends StatelessWidget {
  LoadableUic({
    Key key,
    @required this.loadableData,

  });

  final LoadableData<T> loadableData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: loadableData,
      child: Consumer<LoadableData<T>>(
        builder: (context, loadableData, child) {
          switch (loadableData.state) {
            case LoadableDataState.initialLoading:
              return Container();
            case LoadableDataState.initialLoadingError:
              return Container();
            case LoadableDataState.empty:
              return Container();
            case LoadableDataState.ready:
              return Container();
            case LoadableDataState.loading:
              return Container();
            case LoadableDataState.error:
              return Container();
          }
          return Container();
        },
      ),
    );
  }
}