library progress_uic;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressUic extends StatelessWidget {
  const ProgressUic({
    Key key,
    this.child,
    this.dimColor = Colors.black38,
    this.dimContent = false,
    this.inProgress = true,
    this.text = '',
    this.textLocation = ProgressUicTextLocation.bottom,
  })  : assert(!(!inProgress && child == null),
            "You must define 'child', when 'inProgress' is false"),
        assert(!(inProgress && dimContent && child == null),
            "You must define 'child', when 'dimContent' is true"),
        super(key: key);

  /// Content to display.
  final Widget child;

  /// A color to dim the content with.
  ///
  /// Defaults to 'black38'.
  final Color dimColor;

  /// Whether or not to dim the content while progress indicator is shown.
  ///
  /// If set to 'true', the content below the progress indicator remains visible
  /// and dimmed with [dimColor]. When 'false', the progress indicator replaces
  /// the content.
  ///
  /// Defaults to 'false'.
  final bool dimContent;

  /// The progress state.
  ///
  /// Progress indicator is shown if this set to 'true'.
  final bool inProgress;

  /// Text to display near the progress indicator
  final String text;

  /// Where the text is located related to progress indicator
  ///
  /// Can be one of [ProgressUicTextLocation] values - *top*, *bottom*, *left* or
  /// *right*. Defaults to *bottom*
  final ProgressUicTextLocation textLocation;

  @override
  Widget build(BuildContext context) {
    if (inProgress) {
      if (dimContent) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            child,
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: dimColor,
              ),
            ),
            Center(
              child: _layoutViews(context),
            ),
          ],
        );
      } else {
        return Center(
          child: _layoutViews(context),
        );
      }
    } else {
      return child;
    }
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
    if (textLocation == ProgressUicTextLocation.top ||
        textLocation == ProgressUicTextLocation.left) {
      if (text.isNotEmpty) {
        result.add(_buildText(context));
      }
    }
    result.add(CircularProgressIndicator());
    if (textLocation == ProgressUicTextLocation.bottom ||
        textLocation == ProgressUicTextLocation.right) {
      if (text.isNotEmpty) {
        result.add(_buildText(context));
      }
    }
    return result;
  }

  Widget _buildText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

enum ProgressUicTextLocation { top, bottom, left, right }
