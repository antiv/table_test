import 'package:flutter/material.dart';
import 'package:flutter_table_example/app_scaffold.dart';
import 'package:flutter_table_example/timebookings/table.dart';
import 'package:flutter_table_example/timebookings/table_one.dart';
import 'package:flutter_table_example/timebookings/table_tree.dart';
import 'package:go_router/go_router.dart';

import 'app_scaffold.dart';

final _nav1NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'nav1');
final _nav2NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'nav2');
final _nav3NavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'nav3');
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  // Navigator Tab Screens
  static const nav1 = "/nav1";
  static const nav2 = "/nav2";
  static const nav3 = "/nav3";

  // List screens
  static const nav1Details = "nav1Details";
  static const nav2Details = "nav2Details";
  static const nav3Details = "nav3Details";

  static final router = GoRouter(
    errorBuilder: (context, state) => Container(color: Colors.red),
    navigatorKey: _rootNavigatorKey,
    initialLocation: "/",
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: "/",
        redirect: (_, __) => AppRouter.nav1,
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppScaffoldShell(
            navigationShell: navigationShell,
          );
        },
        branches: <StatefulShellBranch>[
          // Nav1 branch
          StatefulShellBranch(
            initialLocation: AppRouter.nav1,
            navigatorKey: _nav1NavigatorKey,
            routes: [
              GoRoute(
                name: AppRouter.nav1,
                path: AppRouter.nav1,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: AppScaffold(
                    body: TimeBookingTable(
                      key: state.pageKey,
                      // listId: 1,
                    ),
                    // secondaryBody: const DetailsData(),
                  ),
                ),
                routes: [
                  GoRoute(
                    name: AppRouter.nav1Details,
                    path: ":id",
                    pageBuilder: (context, state) => NoTransitionPage(
                      child: AppScaffold(
                        body: TimeBookingTable(
                          key: state.pageKey,
                        ),
                        // secondaryBody: DetailsScreen(
                        //   id: state.pathParameters["id"],
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Nav2 branch
          StatefulShellBranch(
            initialLocation: AppRouter.nav2,
            navigatorKey: _nav2NavigatorKey,
            routes: [
              GoRoute(
                name: AppRouter.nav2,
                path: AppRouter.nav2,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AppScaffold(
                    body: TimeBookingTableTree(

                    ),
                  ),
                ),
                routes: [
                  GoRoute(
                    name: AppRouter.nav2Details,
                    path: ":id",
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: AppScaffold(
                        body: TimeBookingTable2(

                        ),
                        // secondaryBody: DetailsScreen(
                        //   id: state.pathParameters["id"],
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Nav3 branch
          StatefulShellBranch(
            initialLocation: AppRouter.nav3,
            navigatorKey: _nav3NavigatorKey,
            routes: [
              GoRoute(
                name: AppRouter.nav3,
                path: AppRouter.nav3,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AppScaffold(
                    body: TimeBookingTable2(),
                  ),
                ),
                routes: [
                  GoRoute(
                    name: AppRouter.nav3Details,
                    path: ":id",
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: AppScaffold(
                        body: TimeBookingTable2(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
