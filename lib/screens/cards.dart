import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: 'RobotConnectionCard')
Widget robotConnectionCard() {
  return ShadApp(
    home: RobotConnectionCard(
      onConnectPressed: (host, port) {},
      onCancelPressed: () {}
    )
  );
}

class TableInfoCard extends ShadCard {
  TableInfoCard({
    required this.pairList,
    super.key,
    super.title,
    super.description,
    super.footer,
    super.padding,
    super.backgroundColor,
    super.radius,
    super.border,
    super.shadows,
    super.width,
    super.height,
    super.leading,
    super.trailing,
    super.rowMainAxisAlignment,
    super.rowCrossAxisAlignment,
    super.columnMainAxisAlignment,
    super.columnCrossAxisAlignment,
    super.rowMainAxisSize,
    super.columnMainAxisSize,
    super.clipBehavior,
  }) : super(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ShadTable.list(
        columnSpanExtent:(column) {
          if (column == 0) {
            return FixedTableSpanExtent(100);
          } else {
            return const RemainingTableSpanExtent();
          }
        },
        rowSpanExtent: (row) => FixedTableSpanExtent(30),
        children: pairList.map(
          (item) => [
            ShadTableCell(child: Text(item.$1)),
            ShadTableCell(child: Text(item.$2)),
          ]
        ),
      )
    ),
  );

  final List<(String, String)> pairList;
}
class MapInfoCard extends TableInfoCard {
  MapInfoCard({
    required this.mapData,
    super.key,
    super.footer,
    super.padding,
    super.backgroundColor,
    super.radius,
    super.border,
    super.shadows,
    super.width,
    super.height,
    super.leading,
    super.trailing,
    super.rowMainAxisAlignment,
    super.rowCrossAxisAlignment,
    super.columnMainAxisAlignment,
    super.columnCrossAxisAlignment,
    super.rowMainAxisSize,
    super.columnMainAxisSize,
    super.clipBehavior,
  }) : super(
    title: Text(mapData.name),
    description: Text(mapData.description),
    pairList: [
      ('Resolution', mapData.resolution.toString()),
      ('Width', mapData.width.toString()),
      ('Height', mapData.height.toString()),
      ('Origin', mapData.origin.toString2D()),
    ]
  );

  final MapData mapData;
}

class RobotConnectionCard extends StatefulWidget {
  const RobotConnectionCard({
    super.key,
    this.onConnectPressed,
    this.onCancelPressed,
    this.doneNotifier
  });

  final Function(String, int)? onConnectPressed;
  final Function()? onCancelPressed;
  final ValueNotifier? doneNotifier;

  @override
  State<StatefulWidget> createState() => _RobotConnectionCardState();
}

class _RobotConnectionCardState extends State<RobotConnectionCard> {
  final _formKey = GlobalKey<ShadFormState>();
  final _hostPattern = RegExp(r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$|^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)+([A-Za-z]|[A-Za-z][A-Za-z0-9\-]*[A-Za-z0-9])$');
  final _portPattern = RegExp(r'^((6553[0-5])|(655[0-2][0-9])|(65[0-4][0-9]{2})|(6[0-4][0-9]{3})|([1-5][0-9]{4})|([0-5]{0,5})|([0-9]{1,4}))$');

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: Text('Connect Robot'),
      child: ShadForm(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 300),
          child: Column(
            spacing: 4,
            children: [
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
                // inputFormatters: [FilteringTextInputFormatter.allow(_portPattern)],
              ),
              Expanded(child: Container()),
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
                      }
                    },
                    child: const Text('Connect'),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}
