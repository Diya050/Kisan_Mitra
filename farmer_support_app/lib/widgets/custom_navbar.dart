import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  CustomNavBarState createState() => CustomNavBarState();
}

class CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.eco, "Plant Doctor", 1),
            const SizedBox(width: 40),
            _buildNavItem(Icons.article, "News", 3),
            _buildNavItem(Icons.settings, "Settings", 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => widget.onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: widget.selectedIndex == index ? Colors.green : Colors.teal),
          Text(label, style: TextStyle(fontSize: 12, color: widget.selectedIndex == index ? Colors.green : Colors.teal)),
        ],
      ),
    );
  }
}
