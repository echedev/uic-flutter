import 'package:flutter/material.dart';
import 'package:uic/responsive_layout/responsive_layout.dart';

class ResponsiveLayoutScreen  extends StatefulWidget {
  ResponsiveLayoutScreen({Key? key}) : super(key: key);

  @override
  _ResponsiveLayoutScreenState createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ResponsiveLayout Demo'),
      ),
      body: FormFactors(
        formFactors: const <FormFactor>{
          FormFactorA(),
          FormFactorB(),
          FormFactorC(),
          FormFactorD(),
          FormFactorE(),
        },
        child: ResponsiveLayout(
          children: {
            FormFactorB: Container(color: Colors.lightBlueAccent,),
            FormFactorD: Container(color: Colors.lightGreenAccent,),
          },
        ),
      ),
    );
  }
}

class FormFactorA implements FormFactor {
  const FormFactorA();

  @override
  double get maxWidth => 300;
}

class FormFactorB implements FormFactor {
  const FormFactorB();

  @override
  double get maxWidth => 400;
}

class FormFactorC implements FormFactor {
  const FormFactorC();

  @override
  double get maxWidth => 500;
}

class FormFactorD implements FormFactor {
  const FormFactorD();

  @override
  double get maxWidth => 600;
}

class FormFactorE implements FormFactor {
  const FormFactorE();

  @override
  double get maxWidth => 700;
}