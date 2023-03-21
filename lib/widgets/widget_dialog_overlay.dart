import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetDialogOverlay extends StatefulWidget {
  const WidgetDialogOverlay({
    super.key,
    this.title,
    this.body,
  });

  final String? title;
  final Widget? body;

  @override
  State<StatefulWidget> createState() => WidgetDialogOverlayState();
}

class WidgetDialogOverlayState extends State<WidgetDialogOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.85),
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (widget.title == null && widget.body == null)
                    ? const Padding(
                        padding: EdgeInsets.all(50.0),
                        child: Text("NPS Solutions Dialog"),
                      )
                    : const SizedBox(),
                widget.title != null
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.title!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox(),
                widget.body != null
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: widget.body!,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
