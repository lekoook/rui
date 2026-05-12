import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:rui/screens/app_constants.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConnectRobotPopover extends StatefulWidget {
  const ConnectRobotPopover({
    super.key,
    this.onConnectPressed,
    this.onDisconnectPressed,
    this.onClosePressed,
    required this.connectedNotifier
  });

  final void Function(String, int)? onConnectPressed;
  final VoidCallback? onDisconnectPressed;
  final void Function()? onClosePressed;
  final ValueNotifier<RobotConnectionStatus> connectedNotifier;

  @override
  State<StatefulWidget> createState() => _ConnectRobotPopoverState();
}

class _ConnectRobotPopoverState extends State<ConnectRobotPopover> {
  final _controller = ShadPopoverController();
  final _formKey = GlobalKey<ShadFormState>();
  final _hostPattern = RegExp(r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)+([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$');
  final _portPattern = RegExp(r'^((6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9]{2})|(6[0-4][0-9]{3})|([1-5][0-9]{4})|([0-5]{0,5})|([0-9]{1,4}))$');


  @override
  Widget build(BuildContext context) {
    return ShadPopover(
      controller: _controller,
      popover: (context) {
        return ShadForm(
          key: _formKey,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.sm,
                children: [
                  Container(
                    alignment: AlignmentGeometry.bottomLeft,
                    child: Text('Connect Robot', style: ShadTheme.of(context).textTheme.h3),
                  ),
                  ShadSeparator.horizontal(margin: EdgeInsets.zero),
                  ShadInputFormField(
                    id: 'address',
                    label: const Text('Address'),
                    placeholder: const Text('Enter address'),
                    description: const Text('Robot\'s address for connection.'),
                    initialValue: 'localhost',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (host) {
                      if (!_hostPattern.hasMatch(host) && host != 'localhost') {
                        return 'Invalid host address.';
                      }
                      return null;
                    },
                  ),
                  ShadInputFormField(
                    id: 'port',
                    label: const Text('Port'),
                    placeholder: const Text('Enter port'),
                    description: const Text('Robot\'s port for connection.'),
                    initialValue: '80',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (port) {
                      if (!_portPattern.hasMatch(port)) {
                        return 'Not a valid port number.';
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 3,
                        child: ShadButton.secondary(
                          expands: true,
                          onPressed: () {
                            widget.onClosePressed?.call();
                            _controller.hide();
                          },
                          child: const Text('Close'),
                        ),
                      ),
                      Spacer(),
                      Expanded(
                        flex: 3,
                        child: ValueListenableBuilder(
                          valueListenable: widget.connectedNotifier,
                          builder: (_, value, _) {
                            if (value == RobotConnectionStatus.connected) {
                              _controller.hide();
                            }
                            return ShadButton(
                              expands: true,
                              enabled: switch (value) {
                                RobotConnectionStatus.disconnected => true,
                                _ => false
                              },
                              onPressed: switch (value) {
                                RobotConnectionStatus.disconnected => () {
                                  if (_formKey.currentState!.saveAndValidate()) {
                                    widget.onConnectPressed?.call(
                                      _formKey.currentState!.value['address'],
                                      int.parse(_formKey.currentState!.value['port'])
                                    );
                                  }
                                },
                                _ => null
                              },
                              child: switch (value) {
                                RobotConnectionStatus.connecting => Center(
                                  child: CircularProgressIndicator(constraints: BoxConstraints.tight(Size.fromRadius(20))),
                                ),
                                _ => const Text('Connect')
                              },
                            );
                          }
                        )
                      ),
                      Spacer(),
                    ],
                  )
                ],
              ),
            ),
          )
        );
      },
      child: ValueListenableBuilder(
        valueListenable: widget.connectedNotifier,
        builder: (context, value, child) {
          return Tooltip(
            message: switch (value) {
              RobotConnectionStatus.disconnected => 'Connect to robot',
              RobotConnectionStatus.connected => 'Disconnect from robot',
              _ => 'Connecting to robot'
            },
            child: ShadButton(
              onPressed: switch (value) {
                RobotConnectionStatus.connected => () {
                  widget.onDisconnectPressed?.call();
                  _controller.hide();
                },
                _ => _controller.toggle
              },
              leading: switch (value) {
                RobotConnectionStatus.connected => const Icon(Icons.wifi),
                _ => const Icon(Icons.wifi_off)
              },
              child: switch (value) {
                RobotConnectionStatus.connected => const Text('Disconnect'),
                RobotConnectionStatus.connecting => const Text('Connecting'),
                _ => const Text('Connect')
              },
            )
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
