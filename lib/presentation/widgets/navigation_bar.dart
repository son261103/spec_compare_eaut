import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: themeProvider.themeData.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeData.primaryColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: themeProvider.themeData.primaryColor,
        unselectedItemColor: themeProvider.themeData.unselectedWidgetColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 10),
        elevation: 0,
        items: [
          _buildBottomNavItem(context, Icons.home_outlined, Icons.home, 'Home'),
          _buildBottomNavItem(context, Icons.compare_arrows_outlined, Icons.compare_arrows, 'Compare'),
          _buildBottomNavItem(context, Icons.shopping_cart_outlined, Icons.shopping_cart, 'Market'),
          _buildBottomNavItem(context, Icons.article_outlined, Icons.article, 'News'),
          _buildBottomNavItem(context, Icons.person_outline, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(BuildContext context, IconData icon, IconData activeIcon, String label) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return BottomNavigationBarItem(
      icon: Icon(icon, size: 22),
      activeIcon: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: themeProvider.themeData.primaryColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(activeIcon, size: 22),
      ),
      label: label,
    );
  }
}
