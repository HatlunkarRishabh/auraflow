// lib/screens/main_shell.dart
import 'package:auraflow/screens/goals/goal_list_screen.dart';
import 'package:auraflow/screens/settings/settings_screen.dart';
import 'package:auraflow/screens/stickynotes/sticky_board_screen.dart';
import 'package:auraflow/screens/goals/goals_master_detail_screen.dart';
import 'package:auraflow/screens/widgets/quick_add_dialog.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// The main shell of the application which adapts its navigation structure
/// based on the screen size (mobile vs. desktop/tablet).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  List<Widget> _getWidgetOptions(BuildContext context) {
    // Sizing information is available via the 'context'
    final deviceType = getDeviceType(MediaQuery.of(context).size);
    final isDesktop = deviceType == DeviceScreenType.desktop || deviceType == DeviceScreenType.tablet;
    return <Widget>[
      isDesktop ? const GoalsMasterDetailScreen() : const GoalListScreen(),
      const StickyBoardScreen(),
      const SettingsScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {

    final widgetOptions = _getWidgetOptions(context);

    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => _buildMobileLayout(widgetOptions),
      desktop: (BuildContext context) => _buildDesktopLayout(widgetOptions),
      tablet: (BuildContext context) => _buildDesktopLayout(widgetOptions),
    );
  }


  /// Builds the UI for mobile devices using a BottomNavigationBar.
  Widget _buildMobileLayout(List<Widget> widgetOptions) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      // The mobile layout gets its own FAB for adding items.
      floatingActionButton: _selectedIndex < 2 // Only show FAB for Goals and Stickies
          ? FloatingActionButton(
              heroTag: 'mobile-fab',
              onPressed: () => showQuickAddDialog(context, _selectedIndex),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_outlined),
            activeIcon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            activeIcon: Icon(Icons.sticky_note_2),
            label: 'Stickies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  /// Builds the UI for wide screens (desktop/tablet) using a NavigationRail.
  Widget _buildDesktopLayout(List<Widget> widgetOptions) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            // The leading FAB is the primary action for desktop.
            leading: FloatingActionButton(
              elevation: 0,
              onPressed: () => showQuickAddDialog(context, _selectedIndex),
              child: const Icon(Icons.add),
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.flag_outlined),
                selectedIcon: Icon(Icons.flag),
                label: Text('Goals'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.sticky_note_2_outlined),
                selectedIcon: Icon(Icons.sticky_note_2),
                label: Text('Stickies'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
