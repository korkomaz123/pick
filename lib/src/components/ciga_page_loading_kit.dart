import 'package:flutter/material.dart';
import 'package:ciga/src/theme/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BounceLoadingSpinner extends StatefulWidget {
  @override
  _BounceLoadingSpinnerState createState() => _BounceLoadingSpinnerState();
}

class _BounceLoadingSpinnerState extends State<BounceLoadingSpinner>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primaryColor,
    );
  }
}

class PulseLoadingSpinner extends StatefulWidget {
  @override
  _PulseLoadingSpinnerState createState() => _PulseLoadingSpinnerState();
}

class _PulseLoadingSpinnerState extends State<PulseLoadingSpinner>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primaryColor,
    );
  }
}

class RippleLoadingSpinner extends StatefulWidget {
  @override
  _RippleLoadingSpinnerState createState() => _RippleLoadingSpinnerState();
}

class _RippleLoadingSpinnerState extends State<RippleLoadingSpinner>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      controller: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1200),
      ),
      color: primaryColor,
    );
  }
}
