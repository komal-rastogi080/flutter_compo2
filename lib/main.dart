import 'package:flutter/material.dart';
import 'constants.dart';

// --- Nav Items Data ---

const List<Map<String, dynamic>> _navItems = [
  {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
  {'icon': Icons.file_copy_outlined, 'label': 'Posts'},
  {'icon': Icons.image_outlined, 'label': 'Media'},
  {'icon': Icons.pages_outlined, 'label': 'Pages'},
  {'icon': Icons.comment_outlined, 'label': 'Comments', 'showBadge': true},
  {'icon': Icons.palette_outlined, 'label': 'Appearance'},
  {'icon': Icons.extension_outlined, 'label': 'Plugins'},
  {'icon': Icons.group_outlined, 'label': 'Users'},
  {'icon': Icons.settings_outlined, 'label': 'Settings'},
  {'icon': Icons.build_outlined, 'label': 'Tools'},
];

void main() {
  runApp(const MyApp());
}

// This manages the overall theme (light/dark)
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
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
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFf9fafb), // A very light grey
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF111827), // A deep blue-grey
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        isDarkMode: _isDarkMode,
        toggleTheme: _toggleTheme,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback toggleTheme;

  const HomePage({
    Key? key,
    required this.isDarkMode,
    required this.toggleTheme,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isExpanded = true;
  int _selectedIndex = 0;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  // Helper widget for the main content
  Widget _buildMainContent() {
    return Center(
      child: Text(
        '${_navItems[_selectedIndex]['label']}',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: widget.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder to decide which layout to show
    return LayoutBuilder(
      builder: (context, constraints) {
        const int desktopBreakpoint = 720;

        // --- MOBILE LAYOUT ---
        if (constraints.maxWidth < desktopBreakpoint) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_navItems[_selectedIndex]['label'] as String),
              backgroundColor:
              widget.isDarkMode ? kDarkBg : kLightBg,
              foregroundColor:
              widget.isDarkMode ? Colors.white : Colors.black,
            ),
            drawer: MyDrawer(
              isDarkMode: widget.isDarkMode,
              onToggleDarkMode: widget.toggleTheme,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            body: _buildMainContent(),
          );
        }
        // --- DESKTOP LAYOUT ---
        else {
          return Scaffold(
            body: Row(
              children: [
                // --- HERE IS THE COMPONENT ---
                MyNavigationDrawer(
                  isExpanded: _isExpanded,
                  isDarkMode: widget.isDarkMode,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  onToggleExpanded: _toggleExpanded,
                  onToggleDarkMode: widget.toggleTheme,
                ),
                // --- END OF COMPONENT ---

                // Vertical separator
                const VerticalDivider(thickness: 1, width: 1),

                // Main content area
                Expanded(
                  child: _buildMainContent(),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

// 3. --- The Reusable Sidebar Component ---
// This is the widget built from your design.
class MyNavigationDrawer extends StatelessWidget {
  final bool isExpanded;
  final bool isDarkMode;
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final VoidCallback onToggleExpanded;
  final VoidCallback onToggleDarkMode;

  const MyNavigationDrawer({
    Key? key,
    required this.isExpanded,
    required this.isDarkMode,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onToggleExpanded,
    required this.onToggleDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color navBgColor = isDarkMode ? kDarkBg : kLightBg;
    final Color activeColor =
    isDarkMode ? kActiveColorDark : kActiveColorLight;
    final Color activeTextColor =
    isDarkMode ? kActiveTextColorDark : kActiveTextColorLight;
    final Color inactiveTextColor = isDarkMode ? Colors.grey[300]! : Colors.grey[700]!;

    return NavigationRail(
      minWidth: 80, // w-20 from Tailwind (80px)
      minExtendedWidth: 256, // w-64 from Tailwind (256px)
      extended: isExpanded,
      backgroundColor: navBgColor,
      onDestinationSelected: onDestinationSelected,
      selectedIndex: selectedIndex,
      labelType: NavigationRailLabelType.none,

      // --- Header: Logo + Toggle Button ---
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Logo
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "PUI",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // App Name (animates in/out)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) {
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
                  ? const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  "ProjectUI",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
            // Toggle Button
            const Spacer(),
            IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                size: 28,
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
          index: index,
          icon: item['icon'] as IconData,
          label: item['label'] as String,
          showBadge: item['showBadge'] ?? false,
          badgeCount: "1",
          isSelected: selectedIndex == index,
          isExpanded: isExpanded,
          activeColor: activeColor,
          activeTextColor: activeTextColor,
          inactiveTextColor: inactiveTextColor,
        );
      }).toList(),

      // --- Bottom Section: Toggles + Logout ---
      trailing: _BottomNavTools(
        isDarkMode: isDarkMode,
        onToggleDarkMode: onToggleDarkMode,
        isExpanded: isExpanded,
      ),
    );
  }

  // --- Helper to build custom destinations ---
  // This allows us to have custom backgrounds and badges
  NavigationRailDestination _buildNavDestination({
    required int index,
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color activeColor,
    required Color activeTextColor,
    required Color inactiveTextColor,
    bool showBadge = false,
    String badgeCount = "0",
    bool isExpanded = true,
  }) {
    final Color iconColor = isSelected ? activeTextColor : inactiveTextColor;
    final Color textColor = isSelected ? activeTextColor : inactiveTextColor;

    Widget iconWidget = Icon(icon, color: iconColor);

    // Add badge if needed
    if (showBadge) {
      iconWidget = Badge(
        label: isExpanded ? Text(badgeCount) : null,
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
      // We build a custom label to control its style and padding
      label: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isSelected
            ? Container(
          // This is the active highlight container
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor), // Re-draw icon for layout
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              if (showBadge) ...[
                const Spacer(),
                Badge(
                  label: Text(badgeCount),
                  backgroundColor: Colors.blue[600],
                  textColor: Colors.white,
                ),
              ]
            ],
          ),
        )
            : Container(
          // Inactive state
          width: double.infinity,
          padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 4. --- Mobile Drawer ---
class MyDrawer extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const MyDrawer({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
    isDarkMode ? kActiveColorDark : kActiveColorLight;
    final Color activeTextColor =
    isDarkMode ? kActiveTextColorDark : kActiveTextColorLight;

    return Drawer(
      backgroundColor: isDarkMode ? kDarkBg : kLightBg,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: isDarkMode ? kDarkBg : kLightBg,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Clummo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // --- Nav Items ---
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: _navItems.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> item = entry.value;
                bool isSelected = selectedIndex == index;

                return ListTile(
                  leading: Icon(item['icon'] as IconData),
                  title: Text(item['label'] as String),
                  selected: isSelected,
                  onTap: () => onDestinationSelected(index),
                  selectedTileColor: activeColor,
                  selectedColor: activeTextColor,
                  trailing: (item['showBadge'] ?? false)
                      ? Badge(
                    label: const Text("1"),
                    backgroundColor: Colors.blue[600],
                    textColor: Colors.white,
                  )
                      : null,
                );
              }).toList(),
            ),
          ),
          // --- Bottom Tools ---
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _BottomNavTools(
              isDarkMode: isDarkMode,
              onToggleDarkMode: onToggleDarkMode,
              isExpanded: true, // Always expanded in the drawer
            ),
          ),
        ],
      ),
    );
  }
}

// 5. --- Common Bottom Tools ---
// Widget for Dark Mode toggle and Logout
class _BottomNavTools extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;
  final bool isExpanded;

  const _BottomNavTools({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
    required this.isExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bgColor = isDarkMode ? kLogoutBgDark : kLogoutBgLight;

    return Column(
      children: [
        // --- Dark Mode Toggle ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(isDarkMode ? Icons.brightness_7 : Icons.brightness_4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: isExpanded
                    ? Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      isDarkMode ? "Light Mode" : "Dark Mode",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              if (isExpanded)
                Switch(
                  value: isDarkMode,
                  onChanged: (value) => onToggleDarkMode(),
                )
              else
              // When collapsed, the whole row is a button
                Expanded(
                  child: InkWell(
                    onTap: onToggleDarkMode,
                    child: const SizedBox(
                      height: 40,
                    ),
                  ),
                )
            ],
          ),
        ),
        const SizedBox(height: 10),

        // --- Logout Button ---
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: () {
              // Add your logout logic here
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.logout),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
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
                        ? const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

