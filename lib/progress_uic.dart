library progress_uic;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProgressUic extends StatelessWidget {
  const ProgressUic({
    Key key,
    this.child,
    this.color,
    this.dimColor = Colors.black38,
    this.dimContent = false,
    this.inProgress = true,
    this.looseConstraints = false,
    this.size,
    this.text = '',
    this.textLocation = ProgressUicTextLocation.bottom,
    this.textStyle,
  })  : assert(!(!inProgress && child == null),
            "You must define 'child', when 'inProgress' is false"),
        assert(!(inProgress && dimContent && child == null),
            "You must define 'child', when 'dimContent' is true"),
        super(key: key);

  /// Content to display.
  final Widget child;

  /// A color of progress indicator.
  ///
  /// Defaults to [ThemeData.accentColor].
  final Color color;

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

  /// Whether or not the widget size will be as small as possible, assuming
  /// the [size].
  ///
  /// Defaults to 'false', that means the widget will fit all available space.
  final bool looseConstraints;

  /// The size of the progress indicator
  ///
  /// Defaults to 36.0, which is specified in [CircularProjectIndicator]
  final double size;

  /// Text to display near the progress indicator
  final String text;

  /// Where the text is located related to progress indicator
  ///
  /// Can be one of [ProgressUicTextLocation] values - *top*, *bottom*, *left* or
  /// *right*. Defaults to *bottom*
  final ProgressUicTextLocation textLocation;

  /// A text style.
  ///
  /// Defaults to [TextTheme.headline5].
  final TextStyle textStyle;

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
          widthFactor: looseConstraints ? 1.0 : null,
          heightFactor: looseConstraints ? 1.0 : null,
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
    result.add(SizedBox(
      width: size,
      height: size,
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: color),
        child: CircularProgressIndicator()
      ),
    ));
    if (textLocation == ProgressUicTextLocation.bottom ||
        textLocation == ProgressUicTextLocation.right) {
      if (text.isNotEmpty) {
        result.add(_buildText(context));
      }
    }
    return result;
  }

  Widget _buildText(BuildContext context) {
    double top = textLocation == ProgressUicTextLocation.bottom ? 16.0 : 0;
    double bottom = textLocation == ProgressUicTextLocation.top ? 16.0 : 0;
    double left = textLocation == ProgressUicTextLocation.right ? 16.0 : 0;
    double right = textLocation == ProgressUicTextLocation.left ? 16.0 : 0;
    return Padding(
      padding: EdgeInsets.only(top: top, bottom: bottom, left: left, right: right),
      child: Text(
        text,
        style: textStyle ?? Theme.of(context).textTheme.headline5,
      ),
    );
  }
}

enum ProgressUicTextLocation { top, bottom, left, right }
