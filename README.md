# 🚀 ProjectUI: Flutter Responsive Navigation Component

A *production-ready, responsive navigation component for Flutter, built and designed by **ProjectUI*.  
It automatically adapts to any screen size — providing a *NavigationRail (sidebar)* for desktop and web, and a *Drawer (hamburger menu)* for mobile.  
Perfect for modern apps that need smooth, adaptive navigation and a clean UI design. ✨

---

## 🌟 Features

- 🧭 *Fully Responsive* — Automatically switches from NavigationRail (desktop/web) to Drawer (mobile) based on screen width.
- 📂 *Expandable/Collapsible* — The desktop sidebar can be easily expanded or collapsed by the user.
- 🌙 *Light/Dark Mode Ready* — Theme-aware design with a built-in toggle for seamless switching.
- ⚡ *Stateful & Interactive* — Built to integrate smoothly with your app’s state management.
- 💅 *Modern UI Design* — Clean look with smooth AnimatedSwitcher transitions and optional notification badges.
- 🧱 *No Dependencies* — 100% self-contained; only uses Flutter’s material.dart. No third-party packages required.

---

## ⚙ Dependencies

This component is self-contained and only requires:

```dart
import 'package:flutter/material.dart';
No external dependencies or packages are needed.

🧠 How to Use
1. Copy Component Code

From the provided main.dart file, copy these widgets into your app’s widgets folder:

MyNavigationDrawer

MyDrawer

BottomNavTools (utility used by the above components)

2. Create Your Main Page

In your app’s main screen (e.g., home_page.dart), make it a StatefulWidget.
You’ll need to manage the following states:

selectedIndex

isExpanded

isDarkMode

3. Implement the Layout

Use a LayoutBuilder in your build method to render the correct layout depending on screen width.

💻 Example Implementation
import 'package:flutter/material.dart';
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
    // Add your own pages here
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
            body: _pages[_selectedIndex],
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
                child: _pages[_selectedIndex],
              ),
            ],
          ),
        );
      },
    );
  }
}
🎨 Customization

To customize your navigation links, open my_navigation_drawer.dart and edit the _navItems list.
You can easily:

Change icons or labels

Add/remove navigation items

Adjust colors, elevation, and animations

🧩 Notes

💡 All key customization points (logo, colors, structure) are clearly marked with inline comments.

🎨 You can modify the logo area, defined by “logo logic starts” and “logo logic ends,” to use your brand’s identity.

🧭 Adjust paths and routes in the commented sections to match your app’s navigation flow.

🧑‍💻 Credits

Created with ❤ by Komal and the PUI Team
Redesigned, refined, and documented by ProjectUI ✨

If you found this helpful, give it a ⭐ on GitHub and help us make UI development smoother for everyone!