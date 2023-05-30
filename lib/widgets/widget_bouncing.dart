import 'package:flutter/material.dart';

class WidgetBouncing extends StatefulWidget {
  const WidgetBouncing({
    super.key,
    this.onTap,
    required this.child,
  });

  final Function()? onTap;
  final Widget child;

  @override
  State<WidgetBouncing> createState() => _WidgetBouncingState();
}

class _WidgetBouncingState extends State<WidgetBouncing>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  bool _isMove = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        _isMove = false;

        if (widget.onTap != null) {
          _controller.forward();
        }
      },
      onPointerUp: (PointerUpEvent event) {
        if (widget.onTap != null) {
          _controller.reverse();

          if (!_isMove) {
            _isMove = false;
            widget.onTap?.call();
          }
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        _isMove = true;

        if (widget.onTap != null) {
          _controller.reverse();
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }
}
