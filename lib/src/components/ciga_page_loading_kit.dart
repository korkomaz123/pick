import 'package:flutter/material.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChasingDotsLoadingSpinner extends StatefulWidget {
  @override
  _ChasingDotsLoadingSpinnerState createState() =>
      _ChasingDotsLoadingSpinnerState();
}

class _ChasingDotsLoadingSpinnerState extends State<ChasingDotsLoadingSpinner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      duration: Duration(milliseconds: 1200),
      color: primarySwatchColor,
      size: 30,
    );
  }
}

class CircleLoadingSpinner extends StatefulWidget {
  @override
  _CircleLoadingSpinnerState createState() => _CircleLoadingSpinnerState();
}

class _CircleLoadingSpinnerState extends State<CircleLoadingSpinner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primarySwatchColor,
      size: 30,
    );
  }
}

class PouringHourLoadingSpinner extends StatefulWidget {
  @override
  _PouringHourLoadingSpinnerState createState() =>
      _PouringHourLoadingSpinnerState();
}

class _PouringHourLoadingSpinnerState extends State<PouringHourLoadingSpinner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitPouringHourglass(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primarySwatchColor,
      size: 40,
    );
  }
}

class BounceLoadingSpinner extends StatefulWidget {
  @override
  _BounceLoadingSpinnerState createState() => _BounceLoadingSpinnerState();
}

class _BounceLoadingSpinnerState extends State<BounceLoadingSpinner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primarySwatchColor,
    );
  }
}

class PulseLoadingSpinner extends StatefulWidget {
  @override
  _PulseLoadingSpinnerState createState() => _PulseLoadingSpinnerState();
}

class _PulseLoadingSpinnerState extends State<PulseLoadingSpinner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primarySwatchColor,
    );
  }
}

class RippleLoadingSpinner extends StatefulWidget {
  @override
  _RippleLoadingSpinnerState createState() => _RippleLoadingSpinnerState();
}

class _RippleLoadingSpinnerState extends State<RippleLoadingSpinner>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primarySwatchColor,
    );
  }
}
