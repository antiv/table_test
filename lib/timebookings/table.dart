import 'package:flutter/material.dart';
import 'package:flutter_table_example/demo_data/data.dart';
import 'package:flutter_table_example/timebookings/details.dart';
import 'package:flutter_table_example/timebookings/table_action.dart';
import 'package:flutter_table_example/timebookings/table_constants.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class TimeBookingTable extends StatefulWidget {
  const TimeBookingTable({super.key});

  @override
  State<TimeBookingTable> createState() => _TimeBookingTableState();
}

class _TimeBookingTableState extends State<TimeBookingTable> {
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

  PlutoGridStateManager? gridAStateManager;

  PlutoGridStateManager? gridBStateManager;

  Key? currentRowKey;

  void gridAHandler() {
    if (gridAStateManager?.currentRow == null) {
      return;
    }

    if (gridAStateManager?.currentRow!.key != currentRowKey) {
      currentRowKey = gridAStateManager?.currentRow!.key;

      gridBStateManager?.setShowLoading(true);

      fetchUserActivity(gridAStateManager?.currentRow);
    }
  }

  void fetchUserActivity(PlutoRow? currentRow) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          final rows = currentRow?.cells.keys.map((e) => PlutoRow(
              cells: {'Title': PlutoCell(value: e), 'Value': currentRow.cells[e] ?? PlutoCell(value: 'N/A')},
          )).toList();

          print(rows);
          gridBStateManager?.removeRows(gridBStateManager?.rows ?? []);
          gridBStateManager?.resetCurrentState();
          gridBStateManager?.appendRows(rows!);
        });

        gridBStateManager?.setShowLoading(false);
      });
  }

  @override
  void initState() {
    rows = DummyData.rowsByColumns(length: 100, columns: columns);
    super.initState();
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
              child: PlutoDualGrid(
                display: PlutoDualGridDisplayRatio(
                  ratio: 0.8,
                ),
                gridPropsA: PlutoDualGridProps(
                  columns: columns,
                  rows: rows,
                  onChanged: (PlutoGridOnChangedEvent event) {
                    print(event);
                  },
                  onLoaded: (PlutoGridOnLoadedEvent event) {
                    gridAStateManager = event.stateManager;
                    gridAStateManager?.setShowColumnFilter(true);
                    event.stateManager.addListener(gridAHandler);
                  },
                  configuration: TableConstants.configuration,
                ), gridPropsB: PlutoDualGridProps(
                columns: gridBColumns,
                rows: gridBRows,
                configuration: TableConstants.configuration,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  gridBStateManager = event.stateManager;
                },
              ),
              ),
          ),
        ),
        if (stateManager?.checkedRows.isNotEmpty ?? false)
          SizedBox(
            width: 300,
              child: DetailsData(
                clearSelected: () {

                  // TimeBookingTableState.selectedRows.add([]);
                },
              ),
              ),

      ],
    );
  }
}