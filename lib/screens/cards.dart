import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:rui/data/data_types.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

@Preview(name: 'RobotConnectionCard')
Widget robotConnectionCard() {
  return ShadApp(
    home: RobotConnectionCard(
      onConnectPressed: (url) {},
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

  final Function(String)? onConnectPressed;
  final Function()? onCancelPressed;
  final ValueNotifier? doneNotifier;

  @override
  State<StatefulWidget> createState() => _RobotConnectionCardState();
}

class _RobotConnectionCardState extends State<RobotConnectionCard> {
  final _formKey = GlobalKey<ShadFormState>();

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      title: Text('Connect Robot'),
      child: ShadForm(
        key: _formKey,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350, maxHeight: 250),
          child: Column(
            children: [
              ShadInputFormField(
                id: 'address',
                label: const Text('Address'),
                placeholder: const Text('Enter address'),
                description: const Text('Robot\'s address for connection.'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Cannot be empty.';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null) {
                    return 'Not a valid URL address.';
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
                        widget.onConnectPressed?.call(_formKey.currentState!.value['address']);
                        if (widget.doneNotifier != null) {
                        }
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
