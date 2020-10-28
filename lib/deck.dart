import 'dart:math';
import 'package:flutter/material.dart';

class Deck extends StatefulWidget {
  Deck({
    Key key,
    this.collapsedSize = 48.0,
    this.expandedSize,
    @required this.items,
    this.mainAxisSize,
  }) : super (key: key);

  final double collapsedSize;

  final double expandedSize;

  final List<DeckItem> items;

  final double mainAxisSize;

  @override
  _DeckState createState() => _DeckState();
}

class _DeckState extends State<Deck> with TickerProviderStateMixin {

  DeckData _data;

  double _eventualHeight;

  @override
  void initState() {
    super.initState();
    _data = DeckData(
      items: widget.items,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: We should honor 'Deck' orientation to apply 'mainAxisSize' either on height or width
    _eventualHeight = widget.mainAxisSize ?? MediaQuery.of(context).size.height / 2;
    double eventualExpandedSize = widget.expandedSize ?? _eventualHeight / widget.items.length;
    return Container(
        constraints: BoxConstraints(
          minHeight: widget.collapsedSize * widget.items.length,
          maxHeight: _eventualHeight,
        ),
//      child: SingleChildScrollView(
//        child: Container(
//          height: items.length * eventualExpandedSize,
          child: Flow(
            delegate: DeckFlowDelegate(
              collapsedSize: widget.collapsedSize,
              expandedSize: eventualExpandedSize,
              data: _data,
            ),
            children: [...widget.items.map((item) =>
              GestureDetector(
                child: _data.expandedStates[item] ? item.childExpanded ?? item.child : item.child,
                onTap: () {
                  setState(() {
                    _data.setExpanded(item, !_data.expandedStates[item]);
                    _data.expandedStates[item] ?
                      _data.animations[item].forward() : _data.animations[item].reverse();
                  });
                }),
              )],
          ),
//        ),
//      ),
    );
  }
}

class DeckFlowDelegate extends FlowDelegate {
  DeckFlowDelegate({
    @required this.data,
    this.collapsedSize,
    this.expandedSize,
  }) : _expandedStates = Map.from(data.expandedStates),
        super(repaint: data);

  final double collapsedSize;

  final DeckData data;

  final double expandedSize;

  final Map<DeckItem, bool> _expandedStates;

  @override
  Size getSize(BoxConstraints constraints) {
    print('getSize');
    double childrenHeight = data.items
        .map((item) => (data.expandedStates[item]) ?
          max(expandedSize, collapsedSize) :
          collapsedSize)
        .fold(0.0, (previousValue, element) => previousValue + element);
    return Size(constraints.maxWidth, min(constraints.maxHeight, childrenHeight));
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    print('paintChildren');
    List<double> childrenHeight = data.items
        .map((item) => (data.expandedStates[item]) ?
          max(expandedSize * data.animations[item].value, collapsedSize) :
          collapsedSize)
        .toList();
    for (int i = 0; i < context.childCount; ++i) {
      context.paintChild(i,
        transform: Matrix4.translationValues(
          0,
          context.size.height - childrenHeight.sublist(i, context.childCount)
              .fold(0.0, (previousValue, element) => previousValue + element),
          0,
        ),
      );
    }
  }

  @override
  bool shouldRelayout(DeckFlowDelegate oldDelegate) {
    for (DeckItem item in data.expandedStates.keys) {
      if (data.expandedStates[item] != oldDelegate._expandedStates[item])
        return true;
    }
    print('shouldRelayout(): false');
    return false;
  }

  @override
  bool shouldRepaint(DeckFlowDelegate oldDelegate) {
    print('shouldRepaint');
    return false;
  }
}

class DeckItem {
  DeckItem({
    Key key,
    this.child,
    this.childExpanded,
  });

  final Widget child;

  final Widget childExpanded;
}

class DeckData extends ChangeNotifier {
  DeckData({
//    this.animationValues,
//    this.animations,
//    this.expandedStates,
//    this.height,
    this.items,
    this.vsync,
  }) {
    animations = Map.fromIterable(items, key: (item) => item,
      value: (item) {
        AnimationController animation = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: vsync,
        );
        animation.addListener(() => notifyListeners());
        return animation;
      }
    );
    expandedStates = Map.fromIterable(items, key: (item) => item, value: (item) => false);
  }

//  final List<double> animationValues;

  Map<DeckItem, AnimationController> animations;

  Map<DeckItem, bool> expandedStates;

//  final double height;

  final List<DeckItem> items;

  final TickerProvider vsync;

//  void setAnimationValue(int i, double value) {
//    animationValues[i] = value;
//    notifyListeners();
//  }

  void setExpanded(DeckItem item, bool value) {
    expandedStates[item] = value;
    notifyListeners();
  }
}