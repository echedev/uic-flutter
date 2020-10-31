import 'dart:math';
import 'package:flutter/material.dart';

/// Displays stacked child widgets (typically cards), so the only headers are visible
/// initially. Each item in a [Deck] can be expanded.
///
/// List of [DeckItem] objects, provided in the [items] parameter, defines the
/// content of child widgets in their collapsed and expanded states.
///
/// The widget height is adjusted to fit all children in respect their expanded state.
/// The size is limited by [mainAxisSize], which defaults to half of the device screen height.
///
/// Deck item size is defined by [collapsedSize] and [expandedSize] parameters.
/// When they are not set, an item in the collapsed state takes 48p, and its
/// expanded size is calculated by number of items and total Deck size.
///
/// See also:
/// * [DeckItem]
///
class Deck extends StatefulWidget {
  Deck({
    Key key,
    this.collapsedSize = 48.0,
    this.expandedSize,
    @required this.items,
    this.mainAxisSize,
  }) : super(key: key);

  /// The size of child widget in the collapsed state.
  ///
  /// Defaults to 48.0.
  final double collapsedSize;

  /// The size of child widget in the expanded state.
  ///
  /// By default, it is calculated based on items number and total widget size.
  final double expandedSize;

  /// The list of [DeckItem] data objects, where the content of child widgets is
  /// defined for both collapsed and expanded states.
  final List<DeckItem> items;

  /// The maximum Deck size.
  ///
  /// Defaults to half of the screen size.
  final double mainAxisSize;

  @override
  _DeckState createState() => _DeckState();
}

class _DeckState extends State<Deck> with TickerProviderStateMixin {
  _DeckData _data;

  double _eventualHeight;

  @override
  void initState() {
    super.initState();
    _data = _DeckData(
      items: widget.items,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: We should honor 'Deck' orientation to apply 'mainAxisSize' either on height or width
    _eventualHeight =
        widget.mainAxisSize ?? MediaQuery.of(context).size.height / 2;
    double eventualExpandedSize =
        widget.expandedSize ?? _eventualHeight / widget.items.length;
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.collapsedSize * widget.items.length,
        maxHeight: _eventualHeight,
      ),
      child: SingleChildScrollView(
        child: Flow(
          delegate: _DeckFlowDelegate(
            collapsedSize: widget.collapsedSize,
            expandedSize: eventualExpandedSize,
            data: _data,
          ),
          children: [
            ...widget.items.map(
              (item) => GestureDetector(
                  child: (_data.expandedStates[item] ?? false)
                      ? Container(
                          height: eventualExpandedSize + widget.collapsedSize,
                          child: item.childExpanded ?? item.child,
                        )
                      : Container(
                          height: widget.collapsedSize + widget.collapsedSize,
                          child: item.child),
                  onTap: () {
                    setState(() {
                      _data.setExpanded(item, !_data.expandedStates[item]);
                      _data.expandedStates[item]
                          ? _data.animations[item].forward()
                          : _data.animations[item].reverse();
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class _DeckFlowDelegate extends FlowDelegate {
  _DeckFlowDelegate({
    @required this.data,
    this.collapsedSize,
    this.expandedSize,
  })  : _expandedStates = Map.from(data.expandedStates),
        super(repaint: data);

  final double collapsedSize;

  final _DeckData data;

  final double expandedSize;

  final Map<DeckItem, bool> _expandedStates;

  @override
  Size getSize(BoxConstraints constraints) {
    double childrenHeight = data.items
        .map((item) =>
            (data.expandedStates[item]) ? expandedSize : collapsedSize)
        .fold(0.0, (previousValue, element) => previousValue + element);
    return Size(
        constraints.maxWidth, min(constraints.maxHeight, childrenHeight));
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    List<double> childrenHeight = data.items
        .map((item) => (data.expandedStates[item])
            ? max(expandedSize * data.animations[item].value, collapsedSize)
            : collapsedSize)
        .toList();
    for (int i = 0; i < context.childCount; ++i) {
      context.paintChild(
        i,
        transform: Matrix4.translationValues(
          0,
          context.size.height -
              childrenHeight.sublist(i, context.childCount).fold(
                  0.0, (previousValue, element) => previousValue + element),
          0,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(_DeckFlowDelegate oldDelegate) {
    for (DeckItem item in data.expandedStates.keys) {
      if (data.expandedStates[item] != oldDelegate._expandedStates[item])
        return true;
    }
    return false;
  }

  @override
  bool shouldRepaint(_DeckFlowDelegate oldDelegate) {
    return false;
  }
}

/// A data object, that represents collapsed and expanded content of the
/// [Deck] item.
///
class DeckItem {
  DeckItem({
    Key key,
    this.child,
    this.childExpanded,
  });

  /// The widget to display when the item is collapsed
  final Widget child;

  /// The widget to display when the item is expanded
  final Widget childExpanded;
}

class _DeckData extends ChangeNotifier {
  _DeckData({
    this.items,
    this.vsync,
  }) {
    animations = Map.fromIterable(items,
        key: (item) => item,
        value: (item) {
          AnimationController animation = AnimationController(
            duration: const Duration(milliseconds: 300),
            vsync: vsync,
          );
          animation.addListener(() => notifyListeners());
          return animation;
        });
    expandedStates =
        Map.fromIterable(items, key: (item) => item, value: (item) => false);
  }

  Map<DeckItem, AnimationController> animations;

  Map<DeckItem, bool> expandedStates;

  final List<DeckItem> items;

  final TickerProvider vsync;

  void setExpanded(DeckItem item, bool value) {
    expandedStates[item] = value;
    notifyListeners();
  }
}
