import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:npssolutions_mobile/configs/themes/color_const.dart';
import 'package:npssolutions_mobile/controllers/workspace_detail_controller.dart';
import 'package:npssolutions_mobile/pages/home_page/workspace_tab/workspace_detail_page/workspace_users_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../models/workspace_model.dart';
import '../../../../widgets/widget_multi_select_bottom_sheet_field.dart';
import '../../../../widgets/widget_text_field.dart';

class WorkspaceDetailPage extends StatefulWidget {
  const WorkspaceDetailPage({super.key, required this.workspaceId});

  final int workspaceId;

  @override
  State<WorkspaceDetailPage> createState() => _WorkspaceDetailPageState();
}

class _WorkspaceDetailPageState extends State<WorkspaceDetailPage> {
  final WorkspaceDetailController _workspaceDetailController =
      Get.put(WorkspaceDetailController());
  bool isLoadingWorkspace = true;

  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  List<MultiSelectItem> _serviceItemList = [];
  List<String> _selectedServices = [];

  final RoundedLoadingButtonController _updateWorkspaceBtnController =
      RoundedLoadingButtonController();

  _loadData() async {
    EasyLoading.show();

    await _workspaceDetailController
        .getWorkspaceDetail(widget.workspaceId)
        .then(
      (value) {
        if (value) {
          _codeController.text =
              _workspaceDetailController.workspace!.code ?? '';
          _nameController.text =
              _workspaceDetailController.workspace!.name ?? '';
          _addressController.text =
              _workspaceDetailController.workspace!.address ?? '';
          _selectedServices =
              _workspaceDetailController.workspace!.registerServices ?? [];
        }
      },
    );

    await _workspaceDetailController.getWorkspaceServices().then((value) {
      _serviceItemList.clear();
      _serviceItemList = value
          .map((e) => MultiSelectItem<String>(e.value ?? '', e.label ?? ''))
          .toList();
    });

    setState(() {
      isLoadingWorkspace = false;
    });

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // Get.showOverlay(
    //   asyncFunction: () =>
    //       _workspaceDetailController.getWorkspaceDetail(widget.workspaceId),
    // );

    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkspaceDetailController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorConst.primary,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Text(controller.workspace?.name ?? "Workspace"),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Get.to(
                      () => WorkspaceUsersPage(workspaceId: widget.workspaceId),
                      transition: Transition.cupertino);
                },
                child: const Padding(
                    padding: EdgeInsets.all(8.0), child: Icon(Ionicons.people)),
              ),
            ],
          ),
          body: isLoadingWorkspace
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      WidgetTextField(
                        labelText: 'Code',
                        hintText: 'Code',
                        controller: _codeController,
                      ),
                      const SizedBox(height: 10),
                      WidgetTextField(
                        labelText: 'Name',
                        hintText: 'Name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 10),
                      WidgetTextField(
                        labelText: 'Address',
                        hintText: 'Address',
                        controller: _addressController,
                      ),
                      const SizedBox(height: 10),
                      WidgetMultiSelectBottomSheetField(
                        buttonText: 'Services',
                        title: const Text("Services"),
                        items: _serviceItemList,
                        initialValue: _selectedServices,
                        onConfirm: (values) =>
                            _selectedServices = values.cast(),
                        chipDisplay: MultiSelectChipDisplay(
                          onTap: (value) =>
                              setState(() => _selectedServices.remove(value)),
                        ),
                      ),
                      const SizedBox(height: 20),
                      RoundedLoadingButton(
                        controller: _updateWorkspaceBtnController,
                        animateOnTap: false,
                        onPressed: _updateWorkspace,
                        child: const Text('Update',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  void _updateWorkspace() async {
    EasyLoading.show();
    await _workspaceDetailController.updateWorkspace(WorkspaceModel(
      id: widget.workspaceId,
      code: _codeController.text,
      name: _nameController.text,
      address: _addressController.text,
      registerServices: _selectedServices,
    ));
    EasyLoading.dismiss();

    // _createWorkspaceBtnController.success();
    // await Future.delayed(const Duration(seconds: 1));
    // _createWorkspaceBtnController.reset();
    // Get.back();
  }
}
