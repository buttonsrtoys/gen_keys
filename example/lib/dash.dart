import 'package:flutter/material.dart';

const double _dashSize = 100;

class Dash extends StatelessWidget {
  const Dash({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _dashSize * 1.5,
      width: _dashSize * 1.5,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Center(
        child: Icon(
          Icons.flutter_dash,
          size: _dashSize,
        ),
      ),
    );
  }
}
