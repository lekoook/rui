import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ConnectRobotPopover extends StatefulWidget {
  const ConnectRobotPopover({
    super.key,
    this.onConnectPressed,
    this.onDisconnectPressed,
    this.onCancelPressed,
    this.connectedNotifier
  });

  final void Function(String, int)? onConnectPressed;
  final VoidCallback? onDisconnectPressed;
  final void Function()? onCancelPressed;
  final ValueNotifier<RobotConnectionStatus>? connectedNotifier;

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
            constraints: const BoxConstraints(maxWidth: 350, maxHeight: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                AppBar(title: Text('Connect Robot'),),
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
                    ShadButton.secondary(
                      onPressed: widget.onCancelPressed,
                      child: const Text('Cancel'),
                    ),
                    Spacer(),
                    ShadButton(
                      onPressed: () {
                        if (_formKey.currentState!.saveAndValidate()) {
                          widget.onConnectPressed?.call(
                            _formKey.currentState!.value['address'],
                            int.parse(_formKey.currentState!.value['port'])
                          );
                          _controller.hide();
                        }
                      },
                      child: const Text('Connect'),
                    )
                  ],
                )
              ],
            ),
          )
        );
      },
      child: ValueListenableBuilder(
        valueListenable: widget.connectedNotifier ?? ValueNotifier(null),
        builder: (context, value, child) {
          Icon icon;
          Text text;
          if (widget.connectedNotifier == null) {
            icon = Icon(Icons.wifi_off);
            text = Text('Connect');
          } else {
            if (widget.connectedNotifier!.value == RobotConnectionStatus.connected) {
              icon = Icon(Icons.wifi);
              text = Text('Disconnect');
            } else {
              icon = Icon(Icons.wifi_off);
              text = Text('Connect');
            }
          }
          if (widget.connectedNotifier?.value == RobotConnectionStatus.connected) {
            return ShadButton(
              onPressed: () {
                widget.onDisconnectPressed?.call();
                _controller.hide();
              },
              leading: icon,
              child: text,
            );
          }
          return ShadButton(
            onPressed: _controller.toggle,
            leading: icon,
            child: text,
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
