import 'package:flutter/material.dart';

// --- Constants (copied from constants.dart for a single-file example) ---
const Color kDarkScaffold = Color(0xFF1B1B1B);
const Color kDarkCard = Color(0xFF282828);
const Color kDarkSurface = Color(0xFF3B3B3B);
const Color kLightScaffold = Color(0xFFF9F9F9);
const Color kLightCard = Colors.white;
const Color kLightSurface = Color(0xFFF0F0F0);
// --- End Constants ---

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sidebar Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor:
        _isDarkMode ? kDarkScaffold : kLightScaffold,
        cardColor: _isDarkMode ? kDarkCard : kLightCard,
        canvasColor: _isDarkMode ? kDarkCard : kLightCard, // For NavRail/Drawer
        dividerColor: _isDarkMode
            ? kDarkSurface.withOpacity(0.5)
            : kLightSurface.withOpacity(0.8),
        colorScheme: _isDarkMode
            ? const ColorScheme.dark(
          primary: Color(0xFF3B82F6), // Blue
          secondary: Color(0xFF3B82F6),
          surface: kDarkSurface, // Used for NavRail bg
        )
            : const ColorScheme.light(
          primary: Color(0xFF3B82F6), // Blue
          secondary: Color(0xFF3B82F6),
          surface: kLightCard, // Used for NavRail bg
        ),
      ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

// 2. --- Home Page ---
// This holds the layout: our Sidebar (NavigationRail) + the main content
class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomePage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isExpanded = false;

  final List<String> _pageTitles = [
    "Dashboard",
    "Posts",
    "Media",
    "Pages",
    "Comments",
    "Appearance",
    "Plugins",
    "Users",
    "Settings",
    "Tools",
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // --- Mobile Layout ---
        if (constraints.maxWidth < 720) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_pageTitles[_selectedIndex]),
            ),
            drawer: MyDrawer(
              isDarkMode: widget.isDarkMode,
              toggleTheme: widget.toggleTheme,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            body: Center(
              child: Text(
                'Content for "${_pageTitles[_selectedIndex]}"',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          );
        }

        // --- Desktop / Tablet Layout ---
        return Scaffold(
          body: Row(
            children: [
              MyNavigationDrawer(
                isDarkMode: widget.isDarkMode,
                toggleTheme: widget.toggleTheme,
                isExpanded: _isExpanded,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                onToggleExpanded: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: Center(
                  child: Text(
                    'Content for "${_pageTitles[_selectedIndex]}"',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// 3. --- Navigation Component ---
// This is the main Sidebar widget
class MyNavigationDrawer extends StatelessWidget {
  final bool isDarkMode;
  final bool isExpanded;
  final int selectedIndex;
  final VoidCallback toggleTheme;
  final VoidCallback onToggleExpanded;
  final ValueChanged<int> onDestinationSelected;

  const MyNavigationDrawer({
    Key? key,
    required this.isDarkMode,
    required this.isExpanded,
    required this.selectedIndex,
    required this.toggleTheme,
    required this.onToggleExpanded,
    required this.onDestinationSelected,
  }) : super(key: key);

  // --- List of navigation items ---
  static final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.article_rounded, 'label': 'Posts', 'isActive': true},
    {'icon': Icons.perm_media_rounded, 'label': 'Media'},
    {'icon': Icons.pages_rounded, 'label': 'Pages'},
    {
      'icon': Icons.comment_rounded,
      'label': 'Comments',
      'showBadge': true
    },
    {'icon': Icons.palette_rounded, 'label': 'Appearance'},
    {'icon': Icons.extension_rounded, 'label': 'Plugins'},
    {'icon': Icons.people_rounded, 'label': 'Users'},
    {'icon': Icons.settings_rounded, 'label': 'Settings'},
    {'icon': Icons.build_rounded, 'label': 'Tools'},
  ];

  @override
  Widget build(BuildContext context) {
    // --- Define styles ---
    final Color activeColor = isDarkMode
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFFDDEBFE); // Light blue
    final Color activeTextColor = isDarkMode ? Colors.white : Colors.black;
    final Color inactiveTextColor =
    isDarkMode ? Colors.grey[300]! : Colors.grey[700]!;

    return NavigationRail(
      minWidth: 80, // w-20 from Tailwind (80px)
      minExtendedWidth: 256, // w-64 from Tailwind (256px)
      backgroundColor: Theme.of(context).canvasColor,
      extended: isExpanded,
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      // --- Label settings ---
      labelType: isExpanded
          ? NavigationRailLabelType.none
          : NavigationRailLabelType.selected,

      // --- Use built-in styling ---
      useIndicator: true,
      indicatorColor: activeColor,
      selectedIconTheme: IconThemeData(color: activeTextColor),
      unselectedIconTheme: IconThemeData(color: inactiveTextColor),
      selectedLabelTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: activeTextColor,
      ),
      unselectedLabelTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: inactiveTextColor,
      ),
      // --- End built-in styling ---

      // --- Header: Logo + Toggle Button ---
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        // width: double.infinity, // <-- REMOVED: This was causing the RenderFlex overflow
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // <-- CHANGED
          children: [
            // Group Logo and Text together in their own Row
            Row(
              children: [
                // Logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.blur_on, color: Colors.white, size: 30),
                  ),
                ),
                // App Name (animates in/out)
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axis: Axis.horizontal,
                        child: child,
                      ),
                    );
                  },
                  child: isExpanded
                      ? Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "ProjectUI",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
            // Toggle Button
            // const Spacer(), // <-- REMOVED
            IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_double_arrow_left_rounded
                    : Icons.keyboard_double_arrow_right_rounded,
                color: Colors.grey,
              ),
              onPressed: onToggleExpanded,
            ),
          ],
        ),
      ),

      // --- Navigation Items ---
      destinations: _navItems.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, dynamic> item = entry.value;

        return _buildNavDestination(
          icon: item['icon'] as IconData,
          label: item['label'] as String,
          showBadge: item['showBadge'] ?? false,
          badgeCount: "1",
          isExpanded: isExpanded,
        );
      }).toList(),

      // --- Bottom Section: Toggles + Logout ---
      trailing: Column(
        children: [
          const Divider(height: 1),
          _BottomNavTools(
            isDarkMode: isDarkMode,
            isExpanded: isExpanded,
            toggleTheme: toggleTheme,
          ),
          _BottomNavTools(
            icon: Icons.logout_rounded,
            label: "Logout",
            isDarkMode: isDarkMode,
            isExpanded: isExpanded,
            onTap: () {
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  // --- Helper to build custom destinations ---
  // This is now much simpler and uses NavigationRailDestination as intended.
  NavigationRailDestination _buildNavDestination({
    required IconData icon,
    required String label,
    bool showBadge = false,
    String badgeCount = "0",
    bool isExpanded = true,
  }) {
    Widget iconWidget = Icon(icon); // Color is handled by theme

    // Add badge if needed
    if (showBadge) {
      iconWidget = Badge(
        label: Text(badgeCount),
        // When collapsed, show a dot. When expanded, show the count.
        isLabelVisible: isExpanded,
        child: iconWidget,
      );
    }

    return NavigationRailDestination(
      // The main icon
      icon: Tooltip(
        message: label,
        child: iconWidget,
      ),
      // Provide a separate selectedIcon if you want it to look different
      // If not, the `selectedIconTheme` will handle it.
      selectedIcon: Tooltip(
        message: label,
        child: showBadge
            ? Badge(
          label: Text(badgeCount),
          isLabelVisible: isExpanded,
          child: Icon(icon), // Icon without explicit color
        )
            : Icon(icon),
      ),
      // We just provide the Text widget for the label.
      label: Text(label),
      // Add padding to align text
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}

// 4. --- Mobile Drawer ---
// This is the slide-out menu for small screens
class MyDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const MyDrawer({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the nav items from the static list
    final navItems = MyNavigationDrawer._navItems;

    return Drawer(
      child: Column(
        children: [
          // Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.blur_on,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Clummo",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          // Nav Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: navItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                bool isSelected = selectedIndex == index;

                return ListTile(
                  leading: Icon(
                    item['icon'] as IconData,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                  title: Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: (item['showBadge'] ?? false)
                      ? const Badge(label: Text("1"))
                      : null,
                  selected: isSelected,
                  selectedTileColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  onTap: () => onDestinationSelected(index),
                );
              }).toList(),
            ),
          ),
          // Bottom Tools
          const Divider(height: 1),
          _BottomNavTools(
            isDarkMode: isDarkMode,
            isExpanded: true, // Always expanded in the drawer
            toggleTheme: toggleTheme,
          ),
          _BottomNavTools(
            icon: Icons.logout_rounded,
            label: "Logout",
            isDarkMode: isDarkMode,
            isExpanded: true,
            onTap: () {
              // Handle logout
            },
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      ),
    );
  }
}

// 5. --- Reusable Bottom Tools ---
// This is the "Light Mode" / "Logout" widget
class _BottomNavTools extends StatelessWidget {
  final bool isDarkMode;
  final bool isExpanded;
  final VoidCallback? toggleTheme;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? label;

  const _BottomNavTools({
    Key? key,
    required this.isDarkMode,
    required this.isExpanded,
    this.toggleTheme,
    this.onTap,
    this.icon,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine if this is the theme toggle or a regular button
    final bool isThemeToggle = (toggleTheme != null);
    final String currentLabel =
        label ?? (isDarkMode ? "Light Mode" : "Dark Mode");
    final IconData currentIcon = icon ??
        (isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded);

    // --- Collapsed View (Icon only) ---
    if (!isExpanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Tooltip(
          message: currentLabel,
          child: IconButton(
            icon: Icon(currentIcon, color: Colors.grey, size: 24),
            onPressed: onTap ?? toggleTheme,
          ),
        ),
      );
    }

    // --- Expanded View (Icon + Text + Switch/Button) ---
    return InkWell(
      onTap: onTap ?? toggleTheme,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Icon(currentIcon, color: Colors.grey, size: 24),
            const SizedBox(width: 16),
            Text(
              currentLabel,
              style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            if (isThemeToggle)
              Switch(
                value: isDarkMode,
                onChanged: (value) => toggleTheme!(),
              )
            else
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

