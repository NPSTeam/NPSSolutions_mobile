import 'package:flutter/material.dart';
import 'package:nps_social/configs/theme/color_const.dart';

class WidgetOutlinedButton extends StatefulWidget {
  final String text;
  final Function onPressed;

  const WidgetOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<WidgetOutlinedButton> createState() => _WidgetOutlinedButtonState();
}

class _WidgetOutlinedButtonState extends State<WidgetOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onPressed.call();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
              color: ColorConst.blue, width: 1, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(
        widget.text,
        style: const TextStyle(color: ColorConst.blue),
      ),
    );
  }
}
