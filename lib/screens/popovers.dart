import 'package:rui/data/data_types.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'cards.dart';
import 'package:flutter/material.dart';

class ConnectRobotPopover extends StatefulWidget {
  const ConnectRobotPopover({
    super.key,
    this.onConnectPressed,
    this.onCancelPressed,
    this.connectedNotifier
  });

  final void Function(String)? onConnectPressed;
  final void Function()? onCancelPressed;
  final ValueNotifier<RobotConnectionStatus>? connectedNotifier;

  @override
  State<StatefulWidget> createState() => _ConnectRobotPopoverState();
}

class _ConnectRobotPopoverState extends State<ConnectRobotPopover> {
  final controller = ShadPopoverController();

  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      controller: controller,
      popover: (context) {
        return RobotConnectionCard(
          onConnectPressed: (address) {
            widget.onConnectPressed?.call(address);
            controller.hide();
          },
          onCancelPressed: () {
            widget.onCancelPressed?.call();
            controller.hide();
          }
        );
      },
      child: ValueListenableBuilder(
        valueListenable: widget.connectedNotifier ?? ValueNotifier(null),
        builder: (context, value, child) {
          Icon icon;
          if (widget.connectedNotifier == null) {
            icon = Icon(Icons.wifi);
          } else {
            if (widget.connectedNotifier!.value == RobotConnectionStatus.connected) {
              icon = Icon(Icons.wifi);
            } else {
              icon = Icon(Icons.wifi_off);
            }
          }
          return ShadButton(
            onPressed: controller.toggle,
            leading: icon,
            child: const Text('Connect'),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
