ProjectUI: Flutter Responsive Navigation ComponentA production-ready, responsive navigation component for Flutter, brought to you by ProjectUI. This component automatically adapts to any screen size, providing a NavigationRail (sidebar) for desktop and web, and a standard Drawer (hamburger menu) for mobile.FeaturesFully Responsive: Automatically switches from NavigationRail to Drawer based on screen width.Expandable/Collapsible: The desktop sidebar can be expanded or collapsed by the user.Light/Dark Mode Ready: Includes a theme-aware design and a built-in toggle.Stateful & Interactive: Designed to be easily driven by your app's state.Modern UI: Clean design with notification badges and smooth AnimatedSwitcher transitions.DependenciesThis component is self-contained and only requires the standard Flutter material.dart library. No third-party packages are needed.How to UseCopy Component Code: From the provided main.dart file, copy the following widgets into your own project's widgets folder:MyNavigationDrawerMyDrawer_BottomNavTools (This is used by the components above)Create Your Main Page: In your app's main page (e.g., home_page.dart), make it a StatefulWidget. You will need to manage the selectedIndex and isExpanded states.Implement the Layout: Use a LayoutBuilder in your build method to show the correct navigation for the screen size.Example ImplementationHere is a template for how to use the components in your app's main scaffold:import 'package:flutter/material.dart';
// Import the widgets you copied...
// import 'package:your_app/widgets/my_navigation_drawer.dart';
// import 'package:your_app/widgets/my_drawer.dart';

class YourAppShell extends StatefulWidget {
const YourAppShell({Key? key}) : super(key: key);

@override
_YourAppShellState createState() => _YourAppShellState();
}

class _YourAppShellState extends State<YourAppShell> {
int _selectedIndex = 0;
bool _isExpanded = true;
bool _isDarkMode = true; // Manage your theme state

// Your list of pages to show
final List<Widget> _pages = [
Center(child: Text("Dashboard Page")),
Center(child: Text("Posts Page")),
// ... add all your pages here
];

void _toggleTheme() {
setState(() {
_isDarkMode = !_isDarkMode;
});
}

@override
Widget build(BuildContext context) {
return LayoutBuilder(
builder: (context, constraints) {
// --- Mobile Layout ---
if (constraints.maxWidth < 720) {
return Scaffold(
appBar: AppBar(
title: Text("ProjectUI App"), // Your app's title
),
drawer: MyDrawer(
isDarkMode: _isDarkMode,
toggleTheme: _toggleTheme,
selectedIndex: _selectedIndex,
onDestinationSelected: (index) {
setState(() {
_selectedIndex = index;
});
Navigator.pop(context); // Close the drawer
},
),
body: _pages[_selectedIndex], // Your selected page content
);
}

        // --- Desktop / Tablet Layout ---
        return Scaffold(
          body: Row(
            children: [
              MyNavigationDrawer(
                isDarkMode: _isDarkMode,
                toggleTheme: _toggleTheme,
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
                child: _pages[_selectedIndex], // Your selected page content
              ),
            ],
          ),
        );
      },
    );
}
}

CustomizationTo customize the navigation links, open your MyNavigationDrawer file and edit the _navItems static list. You can change the icons, labels, and add/remove items.Made by Komal and PUI team