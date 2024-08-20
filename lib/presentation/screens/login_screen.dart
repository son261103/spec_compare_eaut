import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/app_auth_provider.dart';
import '../providers/theme_provider.dart';
import 'forgot_password_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appAuthProvider = Provider.of<AppAuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(themeProvider),
                  const SizedBox(height: 40),
                  _buildLoginCard(themeProvider),
                  const SizedBox(height: 16),
                  _buildRegisterButton(themeProvider),
                  const SizedBox(height: 16),
                  _buildForgotPasswordButton(themeProvider),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeProvider themeProvider) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: themeProvider.themeData.primaryColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.eco, size: 80, color: themeProvider.themeData.primaryColor),
    ).animate()
        .fadeIn(duration: 600.ms)
        .scale(delay: 300.ms);
  }

  Widget _buildLoginCard(ThemeProvider themeProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: themeProvider.themeData.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEmailField(themeProvider),
              const SizedBox(height: 16),
              _buildPasswordField(themeProvider),
              const SizedBox(height: 24),
              _buildLoginButton(themeProvider),
              const SizedBox(height: 16),
              _buildDivider(themeProvider),
              const SizedBox(height: 16),
              _buildSocialLoginButtons(themeProvider),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale();
  }

  Widget _buildEmailField(ThemeProvider themeProvider) {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: themeProvider.themeData.textTheme.bodyMedium?.color),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: themeProvider.themeData.primaryColor),
        prefixIcon: Icon(Icons.alternate_email, color: themeProvider.themeData.primaryColor),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeProvider.themeData.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeProvider.themeData.primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
    ).animate().fadeIn(delay: 300.ms, duration: 500.ms).moveX();
  }

  Widget _buildPasswordField(ThemeProvider themeProvider) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: themeProvider.themeData.textTheme.bodyMedium?.color),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: themeProvider.themeData.primaryColor),
        prefixIcon: Icon(Icons.lock_outline, color: themeProvider.themeData.primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: themeProvider.themeData.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeProvider.themeData.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeProvider.themeData.primaryColor, width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms).moveX();
  }

  Widget _buildLoginButton(ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: themeProvider.themeData.scaffoldBackgroundColor,
          backgroundColor: themeProvider.themeData.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isLoading ? null : _handleLogin,
        child: _isLoading
            ? CircularProgressIndicator(color: themeProvider.themeData.scaffoldBackgroundColor)
            : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 500.ms).moveY();
  }

  Widget _buildDivider(ThemeProvider themeProvider) {
    return Row(
      children: [
        Expanded(child: Divider(color: themeProvider.themeData.primaryColor)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR', style: TextStyle(color: themeProvider.themeData.primaryColor)),
        ),
        Expanded(child: Divider(color: themeProvider.themeData.primaryColor)),
      ],
    );
  }

  Widget _buildSocialLoginButtons(ThemeProvider themeProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSocialLoginButton(
          icon: FontAwesomeIcons.google,
          color: themeProvider.themeData.primaryColor,
          onPressed: _handleGoogleLogin,
        ),
        _buildSocialLoginButton(
          icon: FontAwesomeIcons.facebookF,
          color: themeProvider.themeData.primaryColor,
          onPressed: _handleFacebookLogin,
        ),
      ],
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms);
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.2),
        ),
        child: Center(
          child: FaIcon(icon, color: color),
        ),
      ),
    ).animate().scale(delay: 100.ms, duration: 300.ms);
  }

  Widget _buildRegisterButton(ThemeProvider themeProvider) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Text(
        'Don\'t have an account? Register',
        style: TextStyle(color: themeProvider.themeData.primaryColor),
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 500.ms);
  }

  Widget _buildForgotPasswordButton(ThemeProvider themeProvider) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
        );
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(color: themeProvider.themeData.primaryColor),
      ),
    ).animate().fadeIn(delay: 800.ms, duration: 500.ms);
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final appAuthProvider = Provider.of<AppAuthProvider>(context, listen: false);
        final user = await appAuthProvider.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (user != null) {
          await appAuthProvider.getUserRole(user.userId);
          final roleName = appAuthProvider.userRole;
          if (roleName == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin_dashboard');
          } else {
            Navigator.pushReplacementNamed(context, '/home_dashboard');
          }
        } else {
          _showErrorDialog('Login failed', 'Please check your credentials and try again.');
        }
      } on FirebaseAuthException catch (e) {
        _handleFirebaseAuthError(e);
      } catch (e) {
        _showErrorDialog('Unexpected Error', 'An unexpected error occurred. Please try again later.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found with this email. Please check your email or sign up.';
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password. Please try again or reset your password.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is badly formatted. Please enter a valid email.';
        break;
      case 'user-disabled':
        errorMessage = 'This account has been disabled. Please contact support.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many unsuccessful login attempts. Please try again later.';
        break;
      default:
        errorMessage = 'An error occurred. Please try again later.';
    }
    _showErrorDialog('Login Error', errorMessage);
  }

  Future<void> _handleGoogleLogin() async {
    await _handleSocialLogin(() => Provider.of<AppAuthProvider>(context, listen: false).signInWithGoogle());
  }

  Future<void> _handleFacebookLogin() async {
    await _handleSocialLogin(() => Provider.of<AppAuthProvider>(context, listen: false).signInWithFacebook());
  }

  Future<void> _handleSocialLogin(Future<dynamic> Function() loginMethod) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await loginMethod();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home_dashboard');
      } else {
        _showErrorDialog('Login Error', 'Social sign-in failed. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('Unexpected Error', 'An error occurred during social sign-in. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: themeProvider.themeData.primaryColor)),
        content: Text(message, style: TextStyle(color: themeProvider.themeData.textTheme.bodyMedium?.color)),
        backgroundColor: themeProvider.themeData.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK', style: TextStyle(color: themeProvider.themeData.primaryColor)),
          )
        ],
      ),
    );
  }
}