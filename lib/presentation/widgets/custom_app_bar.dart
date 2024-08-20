import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/search_screen.dart'; // Import trang tìm kiếm

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSearchPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onSearchPressed,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      height: 75,
      decoration: BoxDecoration(
        color: themeProvider.themeData.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: themeProvider.themeData.primaryColor.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: AppBar(
          title: _isSearching
              ? TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // Loại bỏ viền
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: themeProvider.themeData.primaryColor.withOpacity(0.1),
              hintStyle: TextStyle(color: themeProvider.themeData.hintColor),
            ),
            style: TextStyle(
                color:
                themeProvider.themeData.textTheme.bodyMedium?.color),
            autofocus: true,
            onSubmitted: (query) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(query: query),
                ),
              );
            },
          )
              : Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: themeProvider.themeData.primaryColor
                      .withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.devices,
                  color: themeProvider.themeData.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Flexible(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: themeProvider
                        .themeData.textTheme.headlineLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search,
                  color: themeProvider.themeData.primaryColor),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                  }
                });
                if (_isSearching) {
                  widget.onSearchPressed();
                } else {
                  // Nếu không ở chế độ tìm kiếm, chuyển đến trang tìm kiếm khi nhấn vào biểu tượng tìm kiếm
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(query: ''),
                    ),
                  );
                }
              },
            ),
            if (!_isSearching)
              IconButton(
                icon: Icon(Icons.notifications_none,
                    color: themeProvider.themeData.primaryColor),
                onPressed: () {
                  // Xử lý thông báo ở đây
                },
              ),
            IconButton(
              icon: Icon(
                themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: themeProvider.themeData.primaryColor,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }
}
