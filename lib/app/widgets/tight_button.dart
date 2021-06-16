import 'package:flutter/material.dart';

class TightButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TightButton(
    this.text,
    this.onPressed, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(elevation: 0),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
