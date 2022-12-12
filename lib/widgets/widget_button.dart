import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class WidgetButton extends StatelessWidget {
  const WidgetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        textStyle: const TextStyle(
            color: Colors.white, fontSize: 15, fontStyle: FontStyle.normal),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        shadowColor: Colors.lightBlue,
      ),
      child: Row(
        children: const [
          Icon(Ionicons.navigate_outline),
          SizedBox(width: 10),
          Text("Share My Location"),
        ],
      ),
    );
  }
}
