import 'package:flutter/material.dart';

import 'package:flutter_table_example/demo_data/data.dart';
import 'package:flutter_table_example/timebookings/details.dart';
import 'package:flutter_table_example/timebookings/table_action.dart';
import 'package:flutter_table_example/timebookings/table_constants.dart';
import 'package:flutter_table_example/timebookings/vertical_split_view.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class TimeBookingTableTree extends StatefulWidget {
  const TimeBookingTableTree({super.key});

  @override
  State<TimeBookingTableTree> createState() => _TimeBookingTableTreeState();
}

class _TimeBookingTableTreeState extends State<TimeBookingTableTree> {
  final List<PlutoColumn> columns = TableConstants.columns;

  late List<PlutoRow> rows = [];

  final List<PlutoColumn> gridBColumns = [
    PlutoColumn(
      title: 'Title',
      field: 'Title',
      type: PlutoColumnType.text(),
      readOnly: true,
    ),
    PlutoColumn(
      title: 'Value',
      field: 'Value',
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoRow> gridBRows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'User information', fields: ['name', 'age']),
    PlutoColumnGroup(title: 'Status', children: [
      PlutoColumnGroup(title: 'A', fields: ['role'], expandedColumn: true),
      PlutoColumnGroup(
          title: 'Etc.', fields: ['joined', 'working_time', 'role2']),
    ]),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  PlutoGridStateManager? stateManager;

  @override
  void initState() {
    rows = DummyData.rowsByColumns(length: 100, columns: columns);
    rowGroupDelegate = PlutoRowGroupTreeDelegate(
      resolveColumnDepth: (column) => stateManager?.columnIndex(column),
      showText: (cell) => true,
      showFirstExpandableIcon: true,
    );
    super.initState();
  }

  void gridAHandler() {
    if (stateManager?.currentRow == null) {
      return;
    }

    /// set currentRow as checked
    stateManager?.checkedRows.contains(stateManager?.currentRow) ?? false
        ? stateManager?.checkedRows.remove(stateManager!.currentRow!)
        : stateManager?.checkedRows.add(stateManager!.currentRow!);
  }

  PlutoRowGroupDelegate? rowGroupDelegate;
  final List<PlutoRow?>? selectedRows = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TableActions(),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(20),
              child:
              VerticalSplitView(
                // key: ValueKey('VerticalSplitView${selectedRows?.isNotEmpty ?? false}'),
                ratio: 0.8, //(selectedRows?.isNotEmpty ?? false) ? 0.8 : 1,
                left: PlutoGrid(
                  mode: PlutoGridMode.normal,
                  columns: columns,
                  rows: rows,
                  // columnGroups: columnGroups,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    stateManager?.setShowColumnFilter(true);
                    stateManager?.setRowGroup(
                      // First, the columns of the PlutoRowGroupByColumnDelegate
                      // start with an empty list.
                      PlutoRowGroupByColumnDelegate(
                        columns: [],
                      ),
                    );
                    event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                  },
                  columnMenuDelegate: _CustomColumnMenuDelegate(),
                  onChanged: (PlutoGridOnChangedEvent event) {
                    /// get changed row
                    print(event.row.cells['name']?.value);
                    print(event);
                  },
                  configuration: TableConstants.configuration,
                  onSelected: (PlutoGridOnSelectedEvent event) {
                    print(event);
                  },
                  onRowChecked: (PlutoGridOnRowCheckedEvent event) {
                    print(event);
                    // TimeBookingTableState.selectedRows.add(stateManager?.checkedRows ?? []);
                    if (event.isRow) {
                      if (event.row?.type.isGroup ?? false) {
                        if (event.isChecked ?? false) {
                          selectedRows?.addAll(event.row?.type.group.children ?? []);
                        } else {
                          selectedRows?.removeWhere((element) => event.row?.type.group.children.contains(element) ?? false);
                        }
                      } else {
                        if (event.isChecked ?? false) {
                          selectedRows?.add(event.row);
                        } else {
                          selectedRows?.remove(event.row);
                        }
                      }
                    } else {
                      if (event.isChecked ?? false) {
                        selectedRows?.addAll(stateManager?.rows ?? []);
                      } else {
                        selectedRows?.clear();
                      }
                    }
                    setState(() {});
                  },
                ),
                right: //(selectedRows?.isNotEmpty ?? false) ?
                SizedBox(
                  width: 300,
                  child: DetailsData(
                    clearSelected: () {},
                    selectedRows: selectedRows,
                  ),
                ),//: const SizedBox(),
              ),
          ),
        ),
        // if (stateManager?.checkedRows.isNotEmpty ?? false)
        //   SizedBox(
        //     width: 300,
        //       child: DetailsData(
        //         clearSelected: () {
        //
        //           // TimeBookingTableState.selectedRows.add([]);
        //         },
        //       ),
        //       ),

      ],
    );
  }
}

class _CustomColumnMenuDelegate implements PlutoColumnMenuDelegate {
  final PlutoColumnMenuDelegateDefault defaultDelegate =
  const PlutoColumnMenuDelegateDefault();

  bool isGroupColumn(PlutoGridStateManager stateManager, PlutoColumn column) {
    return (stateManager.rowGroupDelegate as PlutoRowGroupByColumnDelegate)
        .columns
        .contains(column);
  }

  @override
  List<PopupMenuEntry<dynamic>> buildMenuItems({
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
  }) {
    final Color textColor = stateManager.style.cellTextStyle.color!;

    final groupColumn = isGroupColumn(stateManager, column);

    return [
      ...defaultDelegate.buildMenuItems(
          stateManager: stateManager, column: column),
      PopupMenuItem<dynamic>(
        value: groupColumn ? _CustomMenuItem.unGroup : _CustomMenuItem.toGroup,
        height: 36,
        enabled: true,
        child: Text(
          groupColumn ? 'unGroup' : 'toGroup',
          style: TextStyle(
            color: textColor,
            fontSize: 13,
          ),
        ),
      ),
    ];
  }

  @override
  void onSelected({
    required BuildContext context,
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
    required bool mounted,
    required selected,
  }) {
    if (selected is PlutoGridColumnMenuItem) {
      defaultDelegate.onSelected(
        context: context,
        stateManager: stateManager,
        column: column,
        mounted: mounted,
        selected: selected,
      );
    } else if (selected is _CustomMenuItem) {
      switch (selected) {
        case _CustomMenuItem.toGroup:
          stateManager.setRowGroup(PlutoRowGroupByColumnDelegate(columns: [
            ...(stateManager.rowGroupDelegate as PlutoRowGroupByColumnDelegate)
                .columns,
            column,
          ]));
          stateManager.updateVisibilityLayout();
          break;
        case _CustomMenuItem.unGroup:
          stateManager.setRowGroup(PlutoRowGroupByColumnDelegate(columns: [
            ...(stateManager.rowGroupDelegate as PlutoRowGroupByColumnDelegate)
                .columns
                .where((e) => e.field != column.field),
          ]));
          stateManager.updateVisibilityLayout();
          break;
      }
    }
  }
}

enum _CustomMenuItem {
  toGroup,
  unGroup,
}