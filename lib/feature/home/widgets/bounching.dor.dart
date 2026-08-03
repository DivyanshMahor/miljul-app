import 'package:flutter/material.dart';

class ThreeBouncingDot extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;
  const ThreeBouncingDot({
    super.key,
   this.color = Colors.red,
   this.size = 10,
    this.duration = const Duration(milliseconds: 500)
  });

  @override
  State<ThreeBouncingDot> createState() => _ThreeBouncingDotState();
}

class _ThreeBouncingDotState extends State<ThreeBouncingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration*3,
    )..repeat();
    super.initState();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBot(int index){
    return ScaleTransition(
        scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(index/3, (index+1)/3,
                curve: Curves.easeInOut),

        ),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, _buildBot).map(
          (dot) => Padding(padding: EdgeInsets.symmetric(horizontal: 2),
          child: dot,
          ),
      ).toList(),
    );
  }
}
