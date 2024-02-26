import 'package:flutter/material.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';

class DetailsData extends StatelessWidget {
  final String? id;
  final Function? clearSelected;
  final List<PlutoRow?>? selectedRows;
  const DetailsData({this.id, super.key, this.clearSelected, this.selectedRows});

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<Object>(
    //     stream: TimeBookingTableState.selectedRows,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         List<PlutoRow> selectedRows = snapshot.data as List<PlutoRow>? ?? [];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0, top: 0),
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Selected Rows: ${selectedRows?.length}'),
                          Text('Selected sum: ${selectedRows?.fold(0.0, (sum, row) => sum + row?.cells['salary']!.value).toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 0, bottom: 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var i = 0; i < (selectedRows?.length ?? 0); i++)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      hintText: 'Name',
                                    ),
                                    initialValue: selectedRows?[i]?.cells['name']!.value.toString(),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Role',
                                      hintText: 'Role',
                                    ),
                                    initialValue: selectedRows?[i]?.cells['role']!.value.toString(),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Age',
                                      hintText: 'Age',
                                    ),
                                    initialValue: selectedRows?[i]?.cells['age']!.value.toString(),
                                  ),
                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Salary',
                                      hintText: 'Salary',
                                    ),
                                    initialValue: selectedRows?[i]?.cells['salary']!.value.toString(),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
    //       }
    //       return const SizedBox.shrink();
    //     }
    // );
  }
}
