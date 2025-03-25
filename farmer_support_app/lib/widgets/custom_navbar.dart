import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomNavBar({super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox( // Replaced Container with SizedBox
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "Home", 0),
            _buildNavItem(Icons.eco, "Plant Doctor", 1),
            const SizedBox(width: 40), // Space for Floating Button
            _buildNavItem(Icons.article, "Weather & News", 3),
            _buildNavItem(Icons.settings, "Settings", 4),
            // _buildNavItem(Icons.article, "News & Schemes", 5),
            // _buildNavItem(Icons.menu_book, "Crop Guide", 6),

          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () => onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: selectedIndex == index ? Colors.teal : Colors.grey),
          Text(label, style: TextStyle(fontSize: 12, color: selectedIndex == index ? Colors.teal : Colors.grey)),
        ],
      ),
    );
  }
}
