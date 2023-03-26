import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

Widget Function(
  BuildContext context,
  int index,
  Animation<double> animation,
) animationItemBuilder(
  Widget Function(int index) child, {
  EdgeInsets padding = EdgeInsets.zero,
}) =>
    (
      BuildContext context,
      int index,
      Animation<double> animation,
    ) =>
        FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: padding,
              child: child(index),
            ),
          ),
        );

Widget loadingListItem() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        CardLoading(
          height: 30,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          width: 100,
          margin: EdgeInsets.only(bottom: 10),
        ),
        CardLoading(
            height: 100,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            margin: EdgeInsets.only(bottom: 10)),
        CardLoading(
          height: 30,
          width: 200,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          margin: EdgeInsets.only(bottom: 10),
        ),
      ],
    ),
  );
}
