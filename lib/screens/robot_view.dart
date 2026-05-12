import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/data/robot_model.dart';
import 'package:rui/data/robot_status_view_model.dart';
import 'package:rui/data/sensor_msgs.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:rui/screens/labels.dart';
import 'package:rui/screens/popovers.dart';
import 'package:rui/screens/robot_dashboard_tab.dart';
import 'package:rui/screens/robot_maps_tab.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabsList.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90.0,
          title: RobotHeaderView(robotStatusViewModel: robotStatusViewModel),
          bottom: const TabBar(
            textScaler: TextScaler.linear(1.52),
            tabs: tabsList
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            spacing: AppSpacing.sm,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: TabBarView(
                    children: [
                      RobotDashboardTab(robotStatusViewModel: robotStatusViewModel),
                      RobotWaypoints(),
                      RobotMapsTab(robotStatusViewModel: robotStatusViewModel),
                    ]
                  ),
                )
              ),
              RobotStatusFooterView(robotStatusViewModel: robotStatusViewModel)
            ],
          ),
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
          spacing: AppSpacing.sm,
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
            ConnectRobotPopover(
              onConnectPressed: (host, port) {
                robotStatusViewModel.connectToRobot(host, port);
              },
              onDisconnectPressed: () {
                robotStatusViewModel.disconnectRobot();
              },
              onCancelPressed: () {},
              connectedNotifier: robotStatusViewModel.connectionNotifier,
            )
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
      padding: EdgeInsets.all(AppSpacing.sm),
        child: Row(
        spacing: AppSpacing.sm,
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

class RobotWaypoints extends StatelessWidget {
  const RobotWaypoints({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Waypoints View')
    );
  }
}
