import 'package:flutter/material.dart';

import 'package:flutter_table_example/demo_data/data.dart';
import 'package:flutter_table_example/state/table_state.dart';
import 'package:flutter_table_example/timebookings/details.dart';
import 'package:flutter_table_example/timebookings/table_action.dart';
import 'package:flutter_table_example/timebookings/table_constants.dart';
import 'package:flutter_table_example/timebookings/vertical_split_view.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class TimeBookingTable2 extends StatefulWidget {
  const TimeBookingTable2({super.key});

  @override
  State<TimeBookingTable2> createState() => _TimeBookingTable2State();
}

class _TimeBookingTable2State extends State<TimeBookingTable2> {
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
                key: ValueKey('VerticalSplitView${stateManager?.checkedRows.isNotEmpty ?? false}'),
                ratio: (stateManager?.checkedRows.isNotEmpty ?? false) ? 0.8 : 1,
                left: PlutoGrid(
                  mode: PlutoGridMode.normal,
                  columns: columns,
                  rows: rows,
                  // columnGroups: columnGroups,
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    stateManager = event.stateManager;
                    stateManager?.setShowColumnFilter(true);
                    event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                  },
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
                    TimeBookingTableState.selectedRows.add(stateManager?.checkedRows ?? []);
                    setState(() {});
                  },
                ),
                right: (stateManager?.checkedRows.isNotEmpty ?? false) ? SizedBox(
                  width: 300,
                  child: DetailsData(
                    clearSelected: () {},
                  ),
                ): const SizedBox(),
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