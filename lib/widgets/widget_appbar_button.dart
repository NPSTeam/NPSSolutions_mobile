import 'package:flutter/material.dart';

class WidgetAppBarButton extends StatefulWidget {
  final String text;
  final Function onPressed;

  const WidgetAppBarButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<WidgetAppBarButton> createState() => _WidgetAppBarButtonState();
}

class _WidgetAppBarButtonState extends State<WidgetAppBarButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onPressed.call();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(widget.text),
    );
  }
}
