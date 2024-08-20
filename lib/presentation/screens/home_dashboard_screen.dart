import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_auth_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/navigation_bar.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({Key? key}) : super(key: key);

  @override
  _HomeDashboardScreenState createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: CustomAppBar(
        title: ' ',
        onSearchPressed: () {
          // Handle search action
          print('Search pressed');
        },
      ),
      body: Container(
        color: themeProvider.themeData.scaffoldBackgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user?.username ?? 'Tech Enthusiast'}!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: themeProvider.themeData.primaryColor,
                  ),
                ).animate().fadeIn().slideX(),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _buildFeaturedProductsCard(context),
                      const SizedBox(height: 16),
                      _buildActionCard(
                        context,
                        'Compare Products',
                        Icons.compare_arrows,
                        themeProvider.themeData.primaryColor,
                            () {
                          // Navigate to compare products screen
                          print('Navigate to compare products');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActionCard(
                        context,
                        'Marketplace',
                        Icons.shopping_cart,
                        themeProvider.themeData.colorScheme.secondary,
                            () {
                          // Navigate to marketplace screen
                          print('Navigate to marketplace');
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildActionCard(
                        context,
                        'Tech News',
                        Icons.article,
                        themeProvider.themeData.primaryColor,
                            () {
                          // Navigate to tech news screen
                          print('Navigate to tech news');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation based on index
          print('Navigate to index: $index');
        },
      ),
    );
  }

  Widget _buildFeaturedProductsCard(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 4,
      color: themeProvider.themeData.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Products',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: themeProvider.themeData.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Replace with actual number of featured products
                itemBuilder: (context, index) {
                  return _buildFeaturedProductItem(context, index);
                },
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 600.ms);
  }

  Widget _buildFeaturedProductItem(BuildContext context, int index) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: themeProvider.themeData.colorScheme.secondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: Icon(Icons.phone_android, size: 48, color: themeProvider.themeData.primaryColor)),
          ),
          const SizedBox(height: 8),
          Text(
            'Product ${index + 1}',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: themeProvider.themeData.textTheme.titleSmall?.color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '\$${(index + 1) * 100}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: themeProvider.themeData.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      elevation: 4,
      color: themeProvider.themeData.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: themeProvider.themeData.textTheme.titleMedium?.color,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios, color: color.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    ).animate().scale(delay: 300.ms, duration: 600.ms);
  }
}