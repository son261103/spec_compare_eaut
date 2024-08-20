import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_auth_provider.dart';
import '../providers/theme_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AppAuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: themeProvider.themeData.primaryColor),
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
                  Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: themeProvider.themeData.primaryColor
                                .withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_add,
                              size: 60,
                              color: themeProvider.themeData.primaryColor))
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(delay: 300.ms),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 4,
                    color: themeProvider.themeData.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTextFormField(
                              controller: _usernameController,
                              label: 'Username',
                              icon: Icons.person,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                return null;
                              },
                            )
                                .animate()
                                .fadeIn(delay: 300.ms, duration: 500.ms)
                                .moveX(),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _emailController,
                              label: 'Email',
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            )
                                .animate()
                                .fadeIn(delay: 400.ms, duration: 500.ms)
                                .moveX(),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _passwordController,
                              label: 'Password',
                              icon: Icons.lock,
                              obscureText: _obscurePassword,
                              toggleObscure: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                            )
                                .animate()
                                .fadeIn(delay: 500.ms, duration: 500.ms)
                                .moveX(),
                            const SizedBox(height: 16),
                            _buildTextFormField(
                              controller: _confirmPasswordController,
                              label: 'Confirm Password',
                              icon: Icons.lock,
                              obscureText: _obscureConfirmPassword,
                              toggleObscure: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            )
                                .animate()
                                .fadeIn(delay: 600.ms, duration: 500.ms)
                                .moveX(),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: themeProvider
                                      .themeData.scaffoldBackgroundColor,
                                  backgroundColor:
                                      themeProvider.themeData.primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: _isLoading ? null : _handleRegister,
                                child: _isLoading
                                    ? CircularProgressIndicator(
                                        color: themeProvider
                                            .themeData.scaffoldBackgroundColor)
                                    : const Text('Register',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 700.ms, duration: 500.ms)
                                .moveY(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                    child: Divider(
                                        color: themeProvider
                                            .themeData.primaryColor)),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text('OR',
                                      style: TextStyle(
                                          color: themeProvider
                                              .themeData.primaryColor)),
                                ),
                                Expanded(
                                    child: Divider(
                                        color: themeProvider
                                            .themeData.primaryColor)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSocialLoginButton(
                                  icon: FontAwesomeIcons.google,
                                  color: themeProvider.themeData.primaryColor,
                                  onPressed: _handleGoogleSignUp,
                                ),
                                _buildSocialLoginButton(
                                  icon: FontAwesomeIcons.facebookF,
                                  color: themeProvider.themeData.primaryColor,
                                  onPressed: _handleFacebookSignUp,
                                ),
                              ],
                            ).animate().fadeIn(delay: 800.ms, duration: 500.ms),
                          ],
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 800.ms).scale(),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                          color: themeProvider.themeData.primaryColor),
                    ),
                  ).animate().fadeIn(delay: 900.ms, duration: 500.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    VoidCallback? toggleObscure,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style:
          TextStyle(color: themeProvider.themeData.textTheme.bodyMedium?.color),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: themeProvider.themeData.primaryColor),
        prefixIcon: Icon(icon, color: themeProvider.themeData.primaryColor),
        suffixIcon: toggleObscure != null
            ? IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility : Icons.visibility_off,
                  color: themeProvider.themeData.primaryColor,
                ),
                onPressed: toggleObscure,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeProvider.themeData.primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: themeProvider.themeData.primaryColor, width: 2),
        ),
      ),
      validator: validator,
    );
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

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final authProvider =
            Provider.of<AppAuthProvider>(context, listen: false);
        final user = await authProvider.signUp(
          _emailController.text.trim(),
          _passwordController.text,
          _usernameController.text.trim(),
        );
        if (user != null) {
          if (!authProvider.isEmailVerified) {
            await authProvider.sendEmailVerification();
            _showVerificationDialog();
          } else {
            Navigator.pushReplacementNamed(context, '/home_dashboard');
          }
        } else {
          _showErrorSnackBar('Registration failed. Please try again.');
        }
      } catch (e) {
        _showErrorSnackBar('Error: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      final user = await authProvider.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home_dashboard');
      } else {
        _showErrorSnackBar('Google sign-up failed. Please try again.');
      }
    } on PlatformException catch (e) {
      print('PlatformException details: ${e.details}');
      if (e.code == 'sign_in_failed') {
        _showErrorSnackBar(
            'Google sign-in failed. Please check your internet connection and try again.');
      } else {
        _showErrorSnackBar('Error: ${e.message}');
      }
    } catch (e) {
      print('Unexpected error: $e');
      _showErrorSnackBar(
          'An unexpected error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleFacebookSignUp() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      final user = await authProvider.signInWithFacebook();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home_dashboard');
      } else {
        _showErrorSnackBar('Facebook sign-up failed. Please try again.');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,
            style: TextStyle(
                color: themeProvider.themeData.scaffoldBackgroundColor)),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showVerificationDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: themeProvider.themeData.dialogBackgroundColor,
          title: Text('Verify Your Email',
              style: TextStyle(color: themeProvider.themeData.primaryColor)),
          content: Text(
            'A verification email has been sent to your email address. Please verify your email before logging in.',
            style: TextStyle(
                color: themeProvider.themeData.textTheme.bodyMedium?.color),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                  style:
                      TextStyle(color: themeProvider.themeData.primaryColor)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }
}
