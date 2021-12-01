import 'package:flutter/material.dart';
import 'package:markaa/src/theme/theme.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class ChasingDotsLoadingSpinner extends StatefulWidget {
  @override
  _ChasingDotsLoadingSpinnerState createState() => _ChasingDotsLoadingSpinnerState();
}

class _ChasingDotsLoadingSpinnerState extends State<ChasingDotsLoadingSpinner> with TickerProviderStateMixin {
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
  final Color loadingColor;

  CircleLoadingSpinner({this.loadingColor = primarySwatchColor});

  @override
  _CircleLoadingSpinnerState createState() => _CircleLoadingSpinnerState();
}

class _CircleLoadingSpinnerState extends State<CircleLoadingSpinner> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      controller: _controller,
      color: widget.loadingColor,
      size: 30,
    );
  }
}

class BounceLoadingSpinner extends StatefulWidget {
  @override
  _BounceLoadingSpinnerState createState() => _BounceLoadingSpinnerState();
}

class _BounceLoadingSpinnerState extends State<BounceLoadingSpinner> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitDoubleBounce(
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class PulseLoadingSpinner extends StatefulWidget {
  @override
  _PulseLoadingSpinnerState createState() => _PulseLoadingSpinnerState();
}

class _PulseLoadingSpinnerState extends State<PulseLoadingSpinner> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitPulse(
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class WaveLoadingSpinner extends StatefulWidget {
  @override
  _WaveLoadingSpinnerState createState() => _WaveLoadingSpinnerState();
}

class _WaveLoadingSpinnerState extends State<WaveLoadingSpinner> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitWave(
      size: 30,
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class RippleLoadingSpinner extends StatefulWidget {
  @override
  _RippleLoadingSpinnerState createState() => _RippleLoadingSpinnerState();
}

class _RippleLoadingSpinnerState extends State<RippleLoadingSpinner> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitRipple(
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class DualRingSpinner extends StatefulWidget {
  @override
  _DualRingSpinnerState createState() => _DualRingSpinnerState();
}

class _DualRingSpinnerState extends State<DualRingSpinner> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitDualRing(
      lineWidth: 2,
      size: 30,
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class SpinningLinesBar extends StatefulWidget {
  @override
  _SpinningLinesBarState createState() => _SpinningLinesBarState();
}

class _SpinningLinesBarState extends State<SpinningLinesBar> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitSpinningLines(
      lineWidth: 2,
      size: 30,
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class ThreeBounceLoadingBar extends StatefulWidget {
  @override
  _ThreeBounceLoadingBarState createState() => _ThreeBounceLoadingBarState();
}

class _ThreeBounceLoadingBarState extends State<ThreeBounceLoadingBar> with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      size: 20,
      controller: _controller,
      color: primarySwatchColor,
    );
  }
}

class BannerLoadingShimmer extends StatefulWidget {
  final double width;
  final double height;

  const BannerLoadingShimmer({Key? key, required this.width, required this.height}) : super(key: key);

  @override
  _BannerLoadingShimmerState createState() => _BannerLoadingShimmerState();
}

class _BannerLoadingShimmerState extends State<BannerLoadingShimmer> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.white,
      ),
    );
  }
}
