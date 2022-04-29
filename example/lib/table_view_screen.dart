// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:uic/table_view.dart';

class TableViewScreen extends StatelessWidget {
  const TableViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableView Demo'),
      ),
      body: TableView(
        columns: const [
          TableViewColumn(
            id: '1',
            title: 'Column 1',
          ),
          TableViewColumn(
            id: '2',
            title: 'Column 2',
          ),
          TableViewColumn(
            id: '3',
            title: 'Column 3 Column 3 Column 3 Column 3 Column 3',
            width: 160.0,
          ),
        ],
        rowCount: 10,
        cellBuilder: (context, rowIndex, column) {
          return Text('R$rowIndex:C${column.id}');
        },
        onCellFocused: ({required int rowIndex, required int columnIndex}) {
          print('TableView::onCellFocused: row=$rowIndex, column=$columnIndex');
        },
      ),
    );
  }
}
