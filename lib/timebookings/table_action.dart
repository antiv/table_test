import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TableActions extends StatefulWidget {
  const TableActions({super.key});

  @override
  State<TableActions> createState() => _TableActionsState();
}

class _TableActionsState extends State<TableActions> {
  DateTimeRange? _dateRange;
  TextEditingController _dateRangeController = TextEditingController();

  String rangeToString(DateTimeRange? range) {
    if (range == null) return '';
    /// Return startDay - EndDay Month or startDay Month - EndDay Month if start and end are in different months
    if (range.start.month == range.end.month) {
      return '${DateFormat('dd').format(range.start)} - ${DateFormat('dd.MMM').format(range.end)}';
    }
    return '${DateFormat('dd.MMM').format(range.start)} - ${DateFormat('dd.MMM').format(range.end)}';
  }

  @override
  initState() {
    /// set initial date range to last 7 days
    _dateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    _dateRangeController.text = rangeToString(_dateRange);
    super.initState();
  }

  @override
  void dispose() {
    _dateRangeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, top: 10, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// date range picker
          SizedBox(
            width: 300,
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Date range',
                suffixIcon: IconButton(
                  onPressed: () async {
                    /// show date range picker
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                      initialDateRange: _dateRange,
                      builder: (context, child) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 450.0,
                                maxHeight: 800.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Theme(data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: Color(0xFF335287),
                                    onPrimary: Color(0xFFF6C812),
                                    // onSurface: Colors.blueAccent,
                                  ),
                                  datePickerTheme: Theme.of(context).datePickerTheme.copyWith(
                                    // rangePickerBackgroundColor: context.werTheme.paperColor,
                                    rangeSelectionBackgroundColor: const Color(0xFF335287), //context.werTheme.primaryColor,
                                  ),
                                ),child: child ?? const SizedBox(),),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (picked != null && picked != _dateRange) {
                      setState(() {
                        _dateRange = picked;
                        _dateRangeController.text = rangeToString(_dateRange);
                      });
                    }
                  },
                  icon: const Icon(Icons.date_range_outlined, color: Color(0xFF335287),
                  ),
                ),
              ),
              controller: _dateRangeController,
              // initialValue: rangeToString(_dateRange),
            ),
          ),
          const Spacer(),
          /// Save view button
          TextButton(onPressed: () {}, child: const Row(
            children: [
              Icon(Icons.save),
              SizedBox(width: 8),
              Text('Save view'),
            ],
          ),),
          TextButton(onPressed: () {}, child: const Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 8),
              Text('Add'),
            ],
          ),),
          TextButton(onPressed: () {}, child: const Row(
            children: [
              Icon(Icons.download),
              SizedBox(width: 8),
              Text('Download'),
            ],
          ),),
        ],
      ),
    );
  }
}
