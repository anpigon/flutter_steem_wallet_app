import 'package:flutter/material.dart';

class NumberSlideAnimation extends StatefulWidget {
  final String number;

  final TextStyle textStyle;

  final Duration duration;

  final Curve curve;

  NumberSlideAnimation({
    required this.number,
    this.textStyle = const TextStyle(fontSize: 16.0),
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeIn,
  }) : assert(int.tryParse(number) != null);

  @override
  _NumberSlideAnimationState createState() => _NumberSlideAnimationState();
}

class _NumberSlideAnimationState extends State<NumberSlideAnimation> {
  double _width = 1000.0;
  final _rowKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print(getRowSize().width.toString());
      setState(() {
        _width = getRowSize().width;
      });

      print(_width.toString());
    });
  }

  Size getRowSize() {
    final box = _rowKey.currentContext!.findRenderObject() as RenderBox;
    return box.size;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      key: _rowKey,
      children: List.generate(widget.number.length, (position) {
        return NumberCol(
          animateTo: int.parse(widget.number[position]),
          textStyle: widget.textStyle,
          duration: widget.duration,
          curve: widget.curve,
        );
      }),
    );
  }
}

/class NumberCol extends StatefulWidget {
  final int animateTo;
  final TextStyle textStyle;
  final Duration duration;
  final Curve curve;

  NumberCol({
    required this.animateTo,
    required this.textStyle,
    required this.duration,
    required this.curve,
  }) : assert(animateTo >= 0 && animateTo < 10);

  @override
  _NumberColState createState() => _NumberColState();
}

class _NumberColState extends State<NumberCol>
    with SingleTickerProviderStateMixin {
  ScrollController? _scrollController;

  double _elementSize = 0.0;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _elementSize = _scrollController!.position.maxScrollExtent / 10;
      setState(() {});

      _scrollController!.animateTo(_elementSize * widget.animateTo,
          duration: widget.duration, curve: widget.curve);
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: _elementSize),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: List.generate(10, (position) {
              return Text(position.toString(), style: widget.textStyle);
            }),
          ),
        ),
      ),
    );
  }
}
