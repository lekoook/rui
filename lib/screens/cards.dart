import 'package:flutter/material.dart';
import 'package:rui/data/data_types.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
