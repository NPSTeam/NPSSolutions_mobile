import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WidgetRefresher extends StatelessWidget {
  const WidgetRefresher({
    super.key,
    required this.controller,
    this.onRefresh,
    this.onLoading,
    this.child,
  });

  final RefreshController controller;
  final Function()? onRefresh;
  final Function()? onLoading;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      physics: const BouncingScrollPhysics(),
      controller: controller,
      header: const ClassicHeader(
        idleText: 'Pull to refresh',
        releaseText: 'Release to refresh',
        refreshingText: 'Refreshing...',
        completeText: 'Refreshed',
        failedText: 'Refresh failed',
        textStyle: TextStyle(color: Colors.black),
        iconPos: IconPosition.top,
        releaseIcon: Icon(Icons.arrow_upward, color: Colors.black),
        refreshingIcon: Icon(Icons.refresh, color: Colors.black),
        completeIcon: Icon(Icons.check, color: Colors.black),
        failedIcon: Icon(Icons.close, color: Colors.black),
      ),
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}
