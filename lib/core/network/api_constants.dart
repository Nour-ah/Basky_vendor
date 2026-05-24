/// API Configuration Constants - Spider Restaurant Vendor
class ApiConstants {
  ApiConstants._();

  // Base URLs - Spider Vendor API
  static const String baseUrl = 'https://spider.backendpro.site';
  static const String apiVersion = '/api';

  // Auth Endpoints
  static const String register = '/auth/vendor/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String verifyEmail = '/auth/verify-email';
  static const String verifyPhone = '/auth/verify-phone';
  static const String resendVerificationCode = '/auth/resend-verification-code';

  // Reset Password
  static const String resetPasswordSendCode = '/auth/reset-password/send-code';
  static const String resetPasswordVerifyCode = '/auth/reset-password/verify-code';
  static const String resetPasswordSetNew = '/auth/reset-password/set-new-password';

  // User & Profile
  static const String user = '/user';
  static const String profile = '/profile';
  static const String updatePassword = '/password';

  // Vendor Endpoints
  static const String vendorHome = '/vendor/home';
  static const String vendorBranches = '/vendor/branches';
  static const String toggleBranchStatus = '/vendor/branch/toggle-status';
  static const String vendorProducts = '/vendor/products';
  static const String vendorCategories = '/vendor/categories';
  static const String vendorVariants = '/vendor/variants';
  static const String vendorRatings = '/vendor/ratings';
  static const String vendorTimeSlots = '/vendor/time-slots';
  static const String vendorWallet = '/vendor/wallet';
  static const String vendorWithdrawals = '/vendor/wallet/withdrawals';
  static const String vendorReports = '/vendor/reports/summary';
  static const String vendorOrders = '/vendor/orders';
  static const String walletHistory = '/wallet/history';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
}
