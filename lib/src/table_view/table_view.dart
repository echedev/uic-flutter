import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget to display data in a table view.
///
/// Allows to navigate between cells using keyboard or pointer device.
///
/// See also:
/// - [TableViewColumn]
///
class TableView extends StatefulWidget {
  /// Creates an instance of 'TableView'.
  ///
  const TableView({
    Key? key,
    required this.columns,
    required this.cellBuilder,
    required this.rowCount,
  }) : super(key: key);

  /// List of column definitions for the table.
  ///
  final List<TableViewColumn> columns;

  /// A function that returns a widget for a cell.
  ///
  /// Should return a widget that represent a content for the cell of specified
  /// row index and column.
  ///
  final Widget Function(BuildContext context, int rowIndex, TableViewColumn column) cellBuilder;

  /// Number of rows in the table.
  ///
  final int rowCount;

  static _TableViewData of(BuildContext context, _TableViewData aspect) {
    final _TableViewInherited? tableViewInherited = InheritedModel.inheritFrom<_TableViewInherited>(context, aspect: aspect);
    assert(tableViewInherited != null, 'No "_TableViewInherited" found in context');
    return tableViewInherited!.data;
  }

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {

  late int _focusedRowIndex;

  late int _focusedColumnIndex;

  @override
  void initState() {
    super.initState();
    _focusedRowIndex = -1;
    _focusedColumnIndex = -1;
  }

  @override
  Widget build(BuildContext context) {
    return _TableViewInherited(
      data: _TableViewData(
        focusedRowIndex: _focusedRowIndex,
        focusedColumn: _focusedColumnIndex > -1 ? widget.columns[_focusedColumnIndex] : null,
      ),
      child: Focus(
        debugLabel: 'TableView',
        onKeyEvent: (node, event) => _handleKeyEvent(event),
        child: Column(
          children: [
            _TableViewHeader(columns: widget.columns),
            Expanded(
              child: ListView.builder(
                itemCount: widget.rowCount,
                itemBuilder: (context, index) => _TableViewRow(
                  columns: widget.columns,
                  index: index,
                  cellBuilder: widget.cellBuilder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    var result = KeyEventResult.ignored;
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        if (_focusedRowIndex < widget.rowCount - 1) {
          _focusedRowIndex += 1;
          result = KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (_focusedRowIndex > 0) {
          _focusedRowIndex -= 1;
          result = KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        if (_focusedColumnIndex < widget.columns.length - 1) {
          _focusedColumnIndex += 1;
          result = KeyEventResult.handled;
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        if (_focusedColumnIndex > 0) {
          _focusedColumnIndex -= 1;
          result = KeyEventResult.handled;
        }
      }
    }
    if (result == KeyEventResult.handled) {
      setState(() {});
    }
    return result;
  }
}

class TableViewColumn {
  const TableViewColumn({
    required this.id,
    this.title = '',
    this.width,
  });

  final String id;

  final String title;

  final double? width;
}

class _TableViewData {
  _TableViewData({
    required this.focusedRowIndex,
    this.focusedColumn,
  });

  final int focusedRowIndex;

  final TableViewColumn? focusedColumn;

  _TableViewData copyWith({
    int? focusedRowIndex,
    TableViewColumn? focusedColumn,
  }) {
    return _TableViewData(
      focusedRowIndex: focusedRowIndex ?? this.focusedRowIndex,
      focusedColumn: focusedColumn ?? this.focusedColumn,
    );
  }
}

class _TableViewInherited extends InheritedModel<_TableViewData> {
  const _TableViewInherited({
    required this.data,
    required Widget child,
  }) : super(child: child);

  final _TableViewData data;

  @override
  bool updateShouldNotify(_TableViewInherited oldWidget) =>
      data.focusedRowIndex != oldWidget.data.focusedRowIndex ||
      data.focusedColumn != oldWidget.data.focusedColumn;

  @override
  bool updateShouldNotifyDependent(_TableViewInherited oldWidget, Set<_TableViewData> dependencies) {
    if (dependencies.any((item) => item.focusedRowIndex == data.focusedRowIndex ||
        item.focusedRowIndex == oldWidget.data.focusedRowIndex ||
        item.focusedColumn == data.focusedColumn ||
        item.focusedColumn == oldWidget.data.focusedColumn)) {
      return true;
    }
    return false;
  }
}

class _TableViewHeader extends StatelessWidget {
  const _TableViewHeader({
    Key? key,
    required this.columns,
  }) : super(key: key);

  final List<TableViewColumn> columns;

  @override
  Widget build(BuildContext context) {
    return _TableViewRow(
      columns: columns,
      index: -1,
      cellBuilder: (context, _, column) => Text(column.title),
      // decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      // height: 72,
    );
  }
}

class _TableViewRow extends StatelessWidget {
  const _TableViewRow({
    Key? key,
    required this.columns,
    required this.index,
    required this.cellBuilder,
    this.decoration,
    this.height,
  }) : super(key: key);

  final List<TableViewColumn> columns;

  final int index;

  final Widget Function(BuildContext context, int rowIndex, TableViewColumn column) cellBuilder;

  final Decoration? decoration;

  final double? height;

  static const double _defaultRowHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: height ?? _defaultRowHeight,
        maxHeight: height ?? double.infinity,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            ...columns.map((column) => _TableViewCell(
              rowIndex: index,
              column: column,
              decoration: decoration,
              child: cellBuilder(context, index, column),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class _TableViewCell extends StatelessWidget {
  const _TableViewCell({
    Key? key,
    required this.rowIndex,
    required this.column,
    required this.child,
    this.decoration,
    this.isSelected = false,
  }) : super(key: key);

  final int rowIndex;

  final TableViewColumn column;

  final Widget child;

  final Decoration? decoration;

  final bool isSelected;

  static const double _defaultColumnWidth = 80.0;

  @override
  Widget build(BuildContext context) {
    final tableViewData = TableView.of(context, _TableViewData(
      focusedRowIndex: rowIndex,
      focusedColumn: column,
    ));
    return Container(
      width: column.width ?? _defaultColumnWidth,
      decoration: tableViewData.focusedRowIndex == rowIndex
          ? tableViewData.focusedColumn == column
            ? BoxDecoration(color: Theme.of(context).colorScheme.secondary.withOpacity(0.1))
            : BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(0.1))
          : decoration,
      alignment: Alignment.centerLeft,
      child: child,
    );
  }
}
