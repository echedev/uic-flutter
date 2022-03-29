// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:uic/responsive_layout.dart';

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FormFactors(
      formFactors: const <FormFactor>[
        Screens.formFactorA,
        Screens.formFactorALandscape,
        Screens.formFactorB,
        Screens.formFactorC,
        Screens.formFactorD,
        Screens.formFactorE,
      ],
      child: const ResponsiveLayoutScreen(),
    );
  }
}

class ResponsiveLayoutScreen extends StatelessWidget {
  const ResponsiveLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ResponsiveLayout Demo'),
      ),
      body: ResponsiveLayout(
        children: {
          Screens.formFactorB: _ResponsiveView(
            name: 'B',
            color: Colors.lightBlueAccent,
          ),
          Screens.formFactorD: _ResponsiveView(
            name: 'D',
            color: Colors.lightGreenAccent,
          ),
          Screens.formFactorALandscape: _ResponsiveView(
            name: 'ALandscape',
            color: Colors.lightBlue,
          ),
        },
      ),
    );
  }
}

class _ResponsiveView extends StatelessWidget {
  const _ResponsiveView({
    Key? key,
    required this.color,
    required this.name,
  }) : super(key: key);

  final Color color;

  final String name;

  @override
  Widget build(BuildContext context) {
    final formFactor = FormFactors.of(context).currentFormFactor;
    final orientation = FormFactors.of(context).orientation;
    return Container(
      color: color,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${formFactor.runtimeType.toString()}, '
              'crossAxisMinWidth=${formFactor.crossAxisMinWidth}, '
              'orientation=${formFactor.orientation}',
              textAlign: TextAlign.center,
            ),
            Text('Device orientation: $orientation'),
            Text(name),
          ],
        ),
      ),
    );
  }
}

class Screens {
  static const formFactorA = FormFactor(crossAxisMinWidth: 300);

  static const formFactorALandscape =
      FormFactor(crossAxisMinWidth: 300, orientation: Orientation.landscape);

  static const formFactorB = FormFactor(crossAxisMinWidth: 400);

  static const formFactorC = FormFactor(crossAxisMinWidth: 500);

  static const formFactorD = FormFactor(crossAxisMinWidth: 600);

  static const formFactorE = FormFactor(crossAxisMinWidth: 700);
}
