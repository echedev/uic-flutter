import 'package:flutter/material.dart';
import 'package:uic/responsive_layout/responsive_layout.dart';

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormFactors(
      formFactors: const <FormFactor>{
        FormFactorA(),
        FormFactorALandscape(),
        FormFactorB(),
        FormFactorC(),
        FormFactorD(),
        FormFactorE(),
      },
      child: const ResponsiveLayoutScreen(),
    );
  }
}

class ResponsiveLayoutScreen  extends StatelessWidget {
  const ResponsiveLayoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ResponsiveLayout Demo'),
      ),
      body: ResponsiveLayout(
        items: const [
          ResponsiveLayoutItem(
            formFactor: FormFactorB(),
            child: _ResponsiveView(
              name: 'B',
              color: Colors.lightBlueAccent,
            ),
          ),
          ResponsiveLayoutItem(
            formFactor: FormFactorD(),
            child: _ResponsiveView(
              name: 'D',
              color: Colors.lightGreenAccent,
            ),
          ),
          ResponsiveLayoutItem(
            formFactor: FormFactorALandscape(),
            child: _ResponsiveView(
              name: 'ALandscape',
              color: Colors.lightBlue,
            ),
          ),
        ],
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
            Text('${formFactor.runtimeType.toString()}, '
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

class FormFactorA extends FormFactor {
  const FormFactorA();

  @override
  double get crossAxisMinWidth => 300;
}

class FormFactorALandscape extends FormFactor {
  const FormFactorALandscape();

  @override
  double get crossAxisMinWidth => 300;

  @override
  Orientation get orientation => Orientation.landscape;
}

class FormFactorB extends FormFactor {
  const FormFactorB();

  @override
  double get crossAxisMinWidth => 400;
}

class FormFactorC extends FormFactor {
  const FormFactorC();

  @override
  double get crossAxisMinWidth => 500;
}

class FormFactorD extends FormFactor {
  const FormFactorD();

  @override
  double get crossAxisMinWidth => 600;
}

class FormFactorE extends FormFactor {
  const FormFactorE();

  @override
  double get crossAxisMinWidth => 700;
}
