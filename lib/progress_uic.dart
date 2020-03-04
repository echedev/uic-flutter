library progress_uic;

import 'package:flutter/material.dart';

class ProgressUic extends StatelessWidget {
  ProgressUic({
    Key key,
    this.text = '',
    this.textLocation = ProgressUicTextLocation.bottom,
  }) :
    super(key: key);

  /// Text to display near the progress indicator
  final String text;

  /// Where the text is located related to progress indicator
  ///
  /// Can be one of [ProgressUicTextLocation] values - *top*, *bottom*, *left* or
  /// *right*. Defaults to *bottom*
  final ProgressUicTextLocation textLocation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _layoutViews(context),
    );
  }

  Widget _layoutViews(BuildContext context) {
    switch (textLocation) {
      case ProgressUicTextLocation.top:
      case ProgressUicTextLocation.bottom:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _getViews(context),
        );
      case ProgressUicTextLocation.left:
      case ProgressUicTextLocation.right:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _getViews(context),
        );
      default:
        return Container();
    }
  }

  List<Widget> _getViews(BuildContext context) {
    List<Widget> result = List();
    if (textLocation == ProgressUicTextLocation.top
        || textLocation == ProgressUicTextLocation.left) {
      if (text.isNotEmpty) {
        result.add(_buildText(context));
      }
    }
    result.add(CircularProgressIndicator());
    if (textLocation == ProgressUicTextLocation.bottom
        || textLocation == ProgressUicTextLocation.right) {
      if (text.isNotEmpty) {
        result.add(_buildText(context));
      }
    }
    return result;
  }

  Widget _buildText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(text,
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }
}

enum ProgressUicTextLocation { top, bottom, left, right }
