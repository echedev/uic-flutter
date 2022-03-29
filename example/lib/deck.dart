// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:uic/widgets.dart';

List<Widget> examplesDeck(BuildContext context) {
  return <Widget>[
    Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Deck(
        collapsedSize: 48.0,
//        collapseOnTap: false,
//                              expandedSize: 200.0,
//                              mainAxisSize: 600,
        items: <DeckItem>[
          DeckItem(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
            childExpanded: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
          DeckItem(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
            childExpanded: Container(
              decoration: const BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
          DeckItem(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
            childExpanded: Container(
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ];
}
