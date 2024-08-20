import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_auth_provider.dart';
import '../providers/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: themeProvider.themeData.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                  _buildForgotPasswordCard(themeProvider),
                  const SizedBox(height: 16),
                  _buildBackToLoginButton(themeProvider),
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
      child: Icon(Icons.lock_reset, size: 80, color: themeProvider.themeData.primaryColor),
    ).animate()
        .fadeIn(duration: 600.ms)
        .scale(delay: 300.ms);
  }

  Widget _buildForgotPasswordCard(ThemeProvider themeProvider) {
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
              Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: themeProvider.themeData.primaryColor,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),
              const SizedBox(height: 16),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: themeProvider.themeData.textTheme.bodyMedium?.color,
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 500.ms),
              const SizedBox(height: 24),
              _buildEmailField(themeProvider),
              const SizedBox(height: 24),
              _buildResetButton(themeProvider),
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
    ).animate().fadeIn(delay: 500.ms, duration: 500.ms).moveX();
  }

  Widget _buildResetButton(ThemeProvider themeProvider) {
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
        onPressed: _isLoading ? null : _handleResetPassword,
        child: _isLoading
            ? CircularProgressIndicator(color: themeProvider.themeData.scaffoldBackgroundColor)
            : const Text('Reset Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    ).animate().fadeIn(delay: 600.ms, duration: 500.ms).moveY();
  }

  Widget _buildBackToLoginButton(ThemeProvider themeProvider) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        'Back to Login',
        style: TextStyle(color: themeProvider.themeData.primaryColor),
      ),
    ).animate().fadeIn(delay: 700.ms, duration: 500.ms);
  }

  Future<void> _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final appAuthProvider = Provider.of<AppAuthProvider>(context, listen: false);
        await appAuthProvider.resetPassword(_emailController.text.trim());
        _showSuccessDialog();
      } catch (e) {
        _showErrorDialog('Password Reset Error', 'Failed to send password reset email. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Password Reset Email Sent', style: TextStyle(color: themeProvider.themeData.primaryColor)),
        content: Text('Please check your email for instructions to reset your password.'),
        backgroundColor: themeProvider.themeData.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Return to login screen
            },
            child: Text('OK', style: TextStyle(color: themeProvider.themeData.primaryColor)),
          )
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: TextStyle(color: themeProvider.themeData.primaryColor)),
        content: Text(message),
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