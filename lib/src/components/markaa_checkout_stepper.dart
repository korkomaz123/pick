import 'package:markaa/src/theme/theme.dart';
import 'package:flutter/material.dart';

class MarkaaCheckoutStepper extends StatefulWidget {
  final List<Widget> items;
  final int totalSteps;
  final int currentStep;

  MarkaaCheckoutStepper({this.items, this.totalSteps, this.currentStep = 0})
      : assert(totalSteps == items.length);

  @override
  _MarkaaCheckoutStepperState createState() => _MarkaaCheckoutStepperState();
}

class _MarkaaCheckoutStepperState extends State<MarkaaCheckoutStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        children: List.generate(
          widget.items.length,
          (index) {
            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: primaryColor,
                      width: index <= widget.currentStep ? 3 : 1,
                    ),
                  ),
                ),
                child: widget.items[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
