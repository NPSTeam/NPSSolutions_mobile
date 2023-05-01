import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/themes/color_const.dart';

class ScrumboardTab extends StatefulWidget {
  const ScrumboardTab({super.key});

  @override
  State<ScrumboardTab> createState() => _ScrumboardTabState();
}

class _ScrumboardTabState extends State<ScrumboardTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConst.primary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25.0),
                Text(
                  'remaining tasks',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 25.0),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: Get.width,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(color: Colors.blueAccent, blurRadius: 10)
                ],
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35.0),
                  topRight: Radius.circular(35.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 50,
                        height: 6,
                        decoration: BoxDecoration(
                            color: ColorConst.lightPrimary,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(color: Colors.yellow),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
