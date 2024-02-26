import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:rxdart/rxdart.dart';

class TimeBookingTableState {
  static final selectedRows = BehaviorSubject<List<PlutoRow?>>.seeded([]);
}