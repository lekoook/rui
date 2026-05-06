import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:rui/screens/labels.dart';
import 'package:rui/screens/map_display.dart';
import 'package:rui/screens/robot_status_panel.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: 'Robot Dashboard')
Widget robotDashboard() {
  final rm = RobotModel();
  final vm = RobotStatusViewModel(robotModel: rm);
  return RobotDashboard(robotStatusViewModel: vm);
}

class RobotMainView extends StatefulWidget {
  const RobotMainView({super.key});

  @override
  State<StatefulWidget> createState() => _RobotMainView();
}

class _RobotMainView extends State<RobotMainView> {
  _RobotMainView() : robotModel = RobotModel() {
    robotStatusViewModel = RobotStatusViewModel(robotModel: robotModel);
  }

  RobotModel robotModel;
  late RobotStatusViewModel robotStatusViewModel;
  static const List<Tab> tabsList = <Tab>[
    Tab(text: 'Dashboard',),
    Tab(text: 'Waypoints',),
    Tab(text: 'Maps',),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsList.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.0,
          title: RobotHeaderView(robotStatusViewModel: robotStatusViewModel),
          bottom: const TabBar(
            tabs: tabsList
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child:TabBarView(
                children: [
                  RobotDashboard(robotStatusViewModel: robotStatusViewModel),
                  RobotWaypoints(),
                  RobotMaps(),
                ]
              ),
            ),
            RobotStatusFooterView(robotStatusViewModel: robotStatusViewModel)
          ],
        )
      )
    );
  }
}

class RobotHeaderView extends StatelessWidget {
  const RobotHeaderView({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 8.0,
          children: [
            Icon(
              Icons.computer,
              color: Colors.cyan,
              size: 48.0,
              semanticLabel: "App icon.",
            ),
            Expanded(
              child: Text('Robot Command & Control'),
            ),
          ],
        ),
        ShadSeparator.horizontal()
      ],
    );
  }
}

class RobotStatusFooterView extends StatefulWidget {
  const RobotStatusFooterView({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotStatusFooterViewState();
}

class _RobotStatusFooterViewState extends State<RobotStatusFooterView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
        child: Row(
        spacing: 8.0,
        children: [
          ValueListenableBuilder<RobotConnectionStatus>(
            valueListenable: widget.robotStatusViewModel.connectionNotifier,
            builder: (context, connection, child) {
              return ConnectionStatusLabel(status: connection);
            }
          ),
          ValueListenableBuilder<AutonomyStatus>(
            valueListenable: widget.robotStatusViewModel.autonomyNotifier,
            builder: (context, autonomy, child) {
              return AutonomyStatusLabel(status: autonomy);
            }
          ),
          ValueListenableBuilder<BatteryState>(
            valueListenable: widget.robotStatusViewModel.batteryStateNotifier,
            builder: (context, battery, child) {
              return BatteryStateLabel(state: battery);
            }
          ),
        ],
      )
    );
  }
}

class RobotDashboard extends StatefulWidget {
  const RobotDashboard({required this.robotStatusViewModel, super.key});

  final RobotStatusViewModel robotStatusViewModel;

  @override
  State<StatefulWidget> createState() => _RobotDashboard();
}

class _RobotDashboard extends State<RobotDashboard> {
  @override
  void initState() {
    super.initState();
    widget.robotStatusViewModel.fetchCurrentMap();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRect(
            child: ValueListenableBuilder(
              valueListenable: widget.robotStatusViewModel.currentMapNotifier,
              builder: (context, value, child) {
                return MapDisplay(mapData: value);
              }
            ),
          )
        ),
        RobotStatusPanel(robotStatusViewModel: widget.robotStatusViewModel),
      ],
    );
  }
}

class RobotWaypoints extends StatelessWidget {
  const RobotWaypoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Waypoints View')
    );
  }
}

class RobotMaps extends StatelessWidget {
  const RobotMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Maps View')
    );
  }
}
