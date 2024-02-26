import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class TableConstants extends PlutoGridLocaleText {
  const TableConstants();

  const TableConstants.serbian({
    // Column menu
    super.unfreezeColumn = 'Odblokiraj kolonu',
    super.freezeColumnToStart = 'Zaključaj na početak',
    super.freezeColumnToEnd = 'Zaključaj na kraj',
    super.autoFitColumn = 'Prilagodi kolonu',
    super.hideColumn = 'Sakrij kolonu',
    super.setColumns = 'Podesi kolone',
    super.setFilter = 'Podesi filter',
    super.resetFilter = 'Resetuj filter',
    // SetColumns popup
    super.setColumnsTitle = 'Naslov kolone',
    // Filter popup
    super.filterColumn = 'Kolona',
    super.filterType = 'Tip',
    super.filterValue = 'Vrednost',
    super.filterAllColumns = 'Sve kolone',
    super.filterContains = 'Sadrži',
    super.filterEquals = 'Jednako',
    super.filterStartsWith = 'Počinje sa',
    super.filterEndsWith = 'Završava sa',
    super.filterGreaterThan = 'Veće od',
    super.filterGreaterThanOrEqualTo = 'Veće ili jednako',
    super.filterLessThan = 'Manje od',
    super.filterLessThanOrEqualTo = 'Manje ili jednako',
    // Date popup
    super.sunday = 'Ne',
    super.monday = 'Po',
    super.tuesday = 'Ut',
    super.wednesday = 'Sr',
    super.thursday = 'Če',
    super.friday = 'Pe',
    super.saturday = 'Su',
    // Time column popup
    super.hour = 'Sat',
    super.minute = 'Minut',
    // Common
    super.loadingText = 'Učitavanje...',
  });

  static final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      enableRowChecked: true,
      readOnly: true,
      footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          type: PlutoAggregateColumnType.count,
          alignment: Alignment.center,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Count',
                style: TextStyle(color: Colors.blue),
              ),
              const TextSpan(text: ' : '),
              TextSpan(text: text),
            ];
          },
        );
      },
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Age',
      field: 'age',
      type: PlutoColumnType.number(),
    ),
    PlutoColumn(
      title: 'Role',
      field: 'role',
      type: PlutoColumnType.select(<String>[
        'Programmer',
        'Designer',
        'Owner',
      ]),
    ),
    PlutoColumn(
      title: 'Role 2',
      field: 'role2',
      type: PlutoColumnType.select(
        <String>[
          'Programmer',
          'Designer',
          'Owner',
        ],
        onItemSelected: (event) {
          print('selected event: $event');
        },
        builder: (item) {
          return Row(children: [
            Icon(item == 'Programmer' ? Icons.code :
            item == 'Designer' ? Icons.design_services: Icons.person,
              color: item == 'Programmer' ? Colors.green :
              item == 'Designer' ? Colors.blue : Colors.red,),
            const SizedBox(width: 8),
            Text(item),
          ]);
        },
      ),
    ),
    PlutoColumn(
      title: 'Joined',
      field: 'joined',
      type: PlutoColumnType.date(
        format: 'dd.MM.yyyy'
      ),
    ),
    PlutoColumn(
      title: 'Working time',
      field: 'working_time',
      type: PlutoColumnType.time(),
    ),
    PlutoColumn(
      title: 'Salary',
      field: 'salary',
      type: PlutoColumnType.currency(
        symbol: '€',
      ),
      footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          formatAsCurrency: true,
          type: PlutoAggregateColumnType.sum,
          format: '#,###',
          alignment: Alignment.center,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Sum',
                style: TextStyle(color: Colors.red),
              ),
              const TextSpan(text: ' : '),
              TextSpan(text: text),
            ];
          },
        );
      },
    ),
  ];

  static final configuration = PlutoGridConfiguration(
      style: PlutoGridStyleConfig(
        gridBorderColor: const Color(0xFF335287),
        borderColor: const Color(0xFFF6C812),
        filterHeaderIconColor: const Color(0xFFF6C812),
        gridBorderRadius: const BorderRadius.all(Radius.circular(15)),
        checkedColor: const Color(0xFFF6C812).withOpacity(0.5),
        activatedBorderColor: const Color(0xFF335287),
        // activatedColor: Theme.of(context).primaryColor.withOpacity(0.1),
        evenRowColor: const Color(0xFFF6C812).withOpacity(0.1),
        // enableColumnBorderVertical: false,
        // enableColumnBorderHorizontal: false,
        filterHeaderColor: const Color(0xFF335287).withOpacity(0.2),
        gridPopupBorderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      columnSize: const PlutoGridColumnSizeConfig(
        autoSizeMode: PlutoAutoSizeMode.scale,
      ),
      // localeText: const PlutoGridLocaleText.german(),
  );
}