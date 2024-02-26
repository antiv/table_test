import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:flutter_table_example/nav_destinations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? secondaryBody;

  const AppScaffold({
    Key? key,
    required this.body,
    this.secondaryBody,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  @override
  Widget build(BuildContext context) {
    return AdaptiveLayout(
        bodyRatio: 0.75,
        internalAnimations: false,
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.small: SlotLayout.from(
              key: const Key('Body Small'),
              builder: (_) => secondaryBody != null ? secondaryBody! : body,
            ),
            Breakpoints.mediumAndUp: SlotLayout.from(
              key: const Key('Body Medium'),
              builder: (_) => body,
            )
          },
        ),
        secondaryBody: secondaryBody != null ? SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.small: SlotLayout.from(
              key: const Key('Body Small'),
              builder: null,
            ),
            Breakpoints.mediumAndUp: SlotLayout.from(
              key: const Key('Body Medium'),
              builder: secondaryBody != null
                  ? (_) => secondaryBody!
                  : AdaptiveScaffold.emptyBuilder,
            )
          },
        ) : null,
    );
  }
}

class AppScaffoldShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const AppScaffoldShell({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: SvgPicture.asset(
            'assets/images/logo.svg',
            semanticsLabel: 'Prangl Logo'
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          constraints: BoxConstraints(
              minHeight: 48,
              maxHeight: 48,
              minWidth: 48),
          margin: const EdgeInsets.only(right: 20),
          child: InkWell(
            highlightColor: Colors.transparent,
            onTap: () {},
            onLongPress: () => {},
            child: const Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                  child: Text('IA', style: TextStyle(color: Colors.white, fontSize: 22),)),
            ),
          ),
        )],
      ),
      body: AdaptiveLayout(
        internalAnimations: false,
        bodyRatio: 0.8,
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.medium: SlotLayout.from(
              key: const Key('Body Medium'),
              builder: (_) => AdaptiveScaffold.standardNavigationRail(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: onNavigationEvent,
                destinations: NavDestination.values
                    .map(
                      (e) => NavigationRailDestination(
                    icon: Icon(e.icon, color: const Color(0xFF335287),),
                    label: Text(e.label, style: const TextStyle(color: Color(0xFF335287)),),
                  ),
                ).toList(),
              ),
            ),
            Breakpoints.large: SlotLayout.from(
              key: const Key('Body Large'),
              builder: (_) {
                bool extended = false;
                return StatefulBuilder(builder: (context, setState) {
                    return AdaptiveScaffold.standardNavigationRail(
                    selectedIndex: navigationShell.currentIndex,
                    extended: extended,
                    onDestinationSelected: onNavigationEvent,
                    destinations: NavDestination.values
                        .map(
                          (e) => NavigationRailDestination(
                        icon: Icon(e.icon, color: const Color(0xFF335287),),
                        label: Text(e.label, style: const TextStyle(color: Color(0xFF335287), fontSize: 14),),
                      ),
                    ).toList(),
                    trailing: Expanded(
                      child: Column(
                        children: [
                          const Spacer(),
                          IconButton(
                            icon: extended
                                ? const Icon(Icons.keyboard_arrow_left, color: Color(0xFF335287),)
                                : const Icon(Icons.keyboard_arrow_right, color: Color(0xFF335287),),
                            onPressed: () => setState(() => extended = !extended),
                          ),
                        ],
                      ),
                    ),
                                  );
                  }
                );
              },
            ),
          },
        ),
        bottomNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.small: SlotLayout.from(
              key: const Key('Body Small'),
              builder: (_) => BottomNavigationBar(items: NavDestination.values
                  .map(
                    (e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.label,
                ),
              ).toList(),
                currentIndex: navigationShell.currentIndex,
                onTap: onNavigationEvent,
              ),
            ),
          },
        ),
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            Breakpoints.small: SlotLayout.from(
              key: const Key('Body Small'),
              builder: (_) => navigationShell,
            ),
            Breakpoints.mediumAndUp: SlotLayout.from(
              key: const Key('Body Medium'),
              builder: (_) => navigationShell,
            )
          },
        ),
      ),
    );
    // return AdaptiveScaffold(
    //   useDrawer: false,
    //   selectedIndex: navigationShell.currentIndex,
    //   onSelectedIndexChange: onNavigationEvent,
    //   // leadingExtendedNavRail: SvgPicture.asset(
    //   //     'assets/images/logo.svg',
    //   //     semanticsLabel: 'Prangl Logo'
    //   // ),
    //   appBar: AppBar(
    //     centerTitle: false,
    //     title: SvgPicture.asset(
    //         'assets/images/logo.svg',
    //         semanticsLabel: 'Prangl Logo'
    //     ),
    //   ),
    //   appBarBreakpoint: Breakpoints.smallAndUp,
    //   destinations: NavDestination.values
    //       .map(
    //         (e) => NavigationDestination(
    //           icon: Icon(e.icon),
    //           label: e.label,
    //         ),
    //       )
    //       .toList(),
    //   body: (_) => navigationShell,
    // );
  }

  Future<void> onNavigationEvent(int index) async {
    if (index == 2) {
      await launchUrl(
      Uri.parse('https://ask.prangl.com/docs/myprangl'),
      mode: LaunchMode.externalApplication);
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
