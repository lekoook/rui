import 'package:flutter/material.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RobotSummaryPanel extends StatelessWidget {
  const RobotSummaryPanel({
    super.key,
    required this.robotStatusViewModel
  });

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 200,
        maxHeight: 200,
      ),
      child: ShadTable.list(
        children: [
          [ShadTableCell(child: Text('Battery')), ShadTableCell(child: SelectableText(robotStatusViewModel.batteryPercentage.toString()))]
        ]
      )
    );
  }
}