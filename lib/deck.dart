import 'dart:math';
import 'package:flutter/material.dart';

class Deck extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // TODO: We should honor 'Deck' orientation to apply 'mainAxisSize' either on height or width
    double eventualHeight = mainAxisSize ?? MediaQuery.of(context).size.height / 2;
    double eventualExpandedSize = expandedSize ?? eventualHeight / items.length;
    DeckData data = DeckData(
      height: eventualHeight,
      animationValues: items.map((item) => 0.0).toList(),
      expandedStates: Map.fromIterable(items, key: (item) => item, value: (item) => false),
      items: items,
    );
    return Container(
      height: eventualHeight,
      child: SingleChildScrollView(
        child: Container(
          height: items.length * eventualExpandedSize,
          child: Flow(
            delegate: DeckFlowDelegate(
              collapsedSize: collapsedSize,
              expandedSize: eventualExpandedSize,
              data: data,
            ),
            children: [...items.map((item) => _DeckItem(
              child: item.child,
              childExpanded: item.childExpanded,
              index: items.indexOf(item),
              animationListener: (double value) {
                data.setAnimationValue(items.indexOf(item), value);
              },
              expandedListener: (bool value) {
                data.setExpanded(item, value);
              },
            ))],
          ),
        ),
      ),
    );
  }

}

class DeckFlowDelegate extends FlowDelegate {
  DeckFlowDelegate({
    @required this.data,
    this.collapsedSize,
    this.expandedSize,
  }) : super(repaint: data);

  final DeckData data;

  final double collapsedSize;

  final double expandedSize;

  @override
  void paintChildren(FlowPaintingContext context) {
    List<double> childrenHeight = data.items
        .map((item) => (data.expandedStates[item]) ?
          max(expandedSize * data.animationValues[data.items.indexOf(item)], collapsedSize) :
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
  bool shouldRepaint(DeckFlowDelegate oldDelegate) {
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

class _DeckItem extends StatefulWidget {
  _DeckItem({
    Key key,
    this.animationListener,
    this.child,
    this.childExpanded,
    this.expandedListener,
    this.index,
  });

  final void Function(double value) animationListener;

  final Widget child;

  final Widget childExpanded;

  final void Function(bool value) expandedListener;

  final int index;

  @override
  State<_DeckItem> createState() => _DeckItemState();
}

class _DeckItemState extends State<_DeckItem> with SingleTickerProviderStateMixin {

  AnimationController _animation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animation = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation.addListener(() => widget.animationListener(_animation.value));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: _isExpanded ? widget.childExpanded : widget.child,
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
          _isExpanded ? _animation.forward() : _animation.reverse();
          widget.expandedListener(_isExpanded);
        });
      },
    );
  }
}

class DeckData extends ChangeNotifier {
  DeckData({
    this.animationValues,
    this.expandedStates,
    this.height,
    this.items,
  });

  final List<double> animationValues;

  final Map<DeckItem, bool> expandedStates;

  final double height;

  final List<DeckItem> items;

  void setAnimationValue(int i, double value) {
    animationValues[i] = value;
    notifyListeners();
  }

  void setExpanded(DeckItem item, bool value) {
    expandedStates[item] = value;
    notifyListeners();
  }
}