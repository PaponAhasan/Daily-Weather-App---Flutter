import 'package:flutter/cupertino.dart';
import 'dart:async';
class ParallaxBackground extends StatefulWidget {
  const ParallaxBackground({super.key});

  @override
  _ParallaxBackgroundState createState() => _ParallaxBackgroundState();
}

class _ParallaxBackgroundState extends State<ParallaxBackground> {
  final images = [
    'images/cloud1.png',
    'images/cloud2.png',
    'images/cloud3.png',
    'images/cloud4.png',
  ];

  double offset = 0;
  double movementFactor = 0.5;
  double screenWidth = 0;
  double rowWidth = 2000;
  double rowOp = 0.5;

  @override
  void didChangeDependencies() {
    screenWidth = MediaQuery.of(context).size.width;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            left: offset + screenWidth,
            child: SizedBox(
              width: rowWidth,
              child: Opacity(
                opacity: rowOp,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: images.map((e) => Expanded(child: Image.asset(e, height: 200,))).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    startMovement();
  }

  void startMovement() {
    setState(() {
      if(rowOp == 0.0) {
        rowOp = 0.5;
      }
      offset -= movementFactor;
    });
    if(offset < -(rowWidth + screenWidth)) {
      rowOp = 0.0;
      offset = screenWidth;
    }
    Future.delayed(const Duration(milliseconds: 50), startMovement);
  }
}