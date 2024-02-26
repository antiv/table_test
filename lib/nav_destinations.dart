import 'package:flutter/material.dart';

enum NavDestination {
  nav1(
    "Time Bookings",
    Icons.calendar_month,
  ),
  nav2(
    "Folders",
    Icons.folder_outlined,
  ),
  // nav3(
  //   "Tree",
  //   Icons.account_tree_outlined,
  // ),
  nav3(
    "Help & Support",
    Icons.question_mark_outlined,
  );

  final String label;
  final IconData icon;

  const NavDestination(
    this.label,
    this.icon,
  );
}
