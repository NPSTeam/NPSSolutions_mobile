import 'package:flutter/material.dart';

import '../../../models/scrumboard_model.dart';

class ScrumboardBoardPage extends StatefulWidget {
  const ScrumboardBoardPage({super.key, required this.scrumboard});

  final ScrumboardModel scrumboard;

  @override
  State<ScrumboardBoardPage> createState() => _ScrumboardBoardPageState();
}

class _ScrumboardBoardPageState extends State<ScrumboardBoardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: ,
        );
  }
}
