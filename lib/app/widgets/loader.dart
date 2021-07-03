import 'package:flutter/material.dart';

class Loader extends StatefulWidget {
  final Color color;

  const Loader({Key? key, required this.color}) : super(key: key);

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animationRotation;
  late final Animation<double> _animationRadiousOut;
  late final Animation<double> _animationRadiousIn;

  final double _initialRadious = 30.0;
  double _radious = 30.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animationRadiousIn = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.5, curve: Curves.linear),
      ),
    );

    _animationRadiousOut = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.linear),
      ),
    );

    _animationRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _controller.addListener(() {
      setState(() {
        if (_controller.value >= 0.0 && _controller.value <= 0.5) {
          _radious = _initialRadious * _animationRadiousIn.value;
        } else if (_controller.value >= 0.5 && _controller.value <= 1.0) {
          _radious = _initialRadious * _animationRadiousOut.value;
        }
      });
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dot = Dot(
      size: 15.0,
      color: widget.color,
    );

    return Container(
      child: Center(
        child: RotationTransition(
          turns: _animationRotation,
          child: Container(
            width: 50.0,
            height: 50.0,
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(0, _radious),
                  child: dot,
                ),
                Transform.translate(
                  offset: Offset(_radious, 0),
                  child: dot,
                ),
                Transform.translate(
                  offset: Offset(-_radious, 0),
                  child: dot,
                ),
                Transform.translate(
                  offset: Offset(0, -_radious),
                  child: dot,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double size;
  final Color color;

  const Dot({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
