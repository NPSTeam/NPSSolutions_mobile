import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class WidgetButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? backgroundColor;
  final double? radius;
  final Widget? leftIcon;

  const WidgetButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.radius,
    this.leftIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        onPressed.call();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.blue,
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 15, fontStyle: FontStyle.normal),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 10))),
        shadowColor: Colors.lightBlue,
      ),
      child: Row(
        children: [
          leftIcon ?? const SizedBox.shrink(),
          if (leftIcon != null) const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
