import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomNavBar extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  const CustomNavBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: themeProvider.themeData.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeData.primaryColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(context, 0, Icons.trending_up, 'Trending'),
              SizedBox(width: 24),
              _buildNavBarItem(context, 1, Icons.new_releases, 'New'),
              SizedBox(width: 24),
              _buildNavBarItem(context, 2, Icons.category, 'Categories'),
              SizedBox(width: 24),
              _buildNavBarItem(context, 3, Icons.star, 'Featured'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, int index, IconData icon, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? themeProvider.themeData.primaryColor : themeProvider.themeData.unselectedWidgetColor,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? themeProvider.themeData.primaryColor : themeProvider.themeData.unselectedWidgetColor,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}