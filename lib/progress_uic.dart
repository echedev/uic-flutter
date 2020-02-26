library progress_uic;

import 'package:flutter/material.dart';

class ProgressUic extends StatelessWidget {
  ProgressUic({
    Key key,
    this.text = '',
  }) :
    super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          if (text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(text,
                style: Theme.of(context).textTheme.headline,
              ),
            )
        ],
      ),
    );
  }
}
