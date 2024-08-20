class AppConstants {
  static const String appName = 'Device Management App';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String devicesCollection = 'devices';
  static const String ordersCollection = 'orders';

  // Roles
  static const String adminRole = 'admin';
  static const String userRole = 'user';

  // Error messages
  static const String loginErrorMessage = 'Failed to sign in. Please check your credentials and try again.';
  static const String registerErrorMessage = 'Failed to create an account. Please try again.';
  static const String genericErrorMessage = 'An error occurred. Please try again later.';
}