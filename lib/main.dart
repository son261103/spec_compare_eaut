import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'di/service_locator.dart';
import 'presentation/providers/app_auth_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/register_screen.dart';
import 'presentation/screens/admin_dashboard_screen.dart';
import 'presentation/screens/home_dashboard_screen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp();
    setupServiceLocator();

    runApp(const MyApp());
  } catch (e) {
    print('Error during initialization: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AppAuthProvider>()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Your App',
            theme: themeProvider.themeData,
            initialRoute: '/login',
            routes: {
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/admin_dashboard': (context) => const AdminDashboardScreen(),
              '/home_dashboard': (context) => const HomeDashboardScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}