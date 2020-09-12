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
              return Container(color: Colors.green,);
            case LoadableDataState.initialLoadingError:
              return Container(color: Colors.red);
            case LoadableDataState.empty:
              return Container(color: Colors.yellow);
            case LoadableDataState.ready:
              return Container(color: Colors.blue);
            case LoadableDataState.loading:
              return Container(color: Colors.orange);
            case LoadableDataState.error:
              return Container(color: Colors.red);
          }
          return Container();
        },
      ),
    );
  }
}