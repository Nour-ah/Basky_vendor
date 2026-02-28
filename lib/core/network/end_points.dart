// ============================================================================
// API ENDPOINTS - SHEIKHY APP
// ============================================================================
// This file contains all API endpoints for the Sheikhy application.
// Update the baseUrl when backend is ready.
// ============================================================================

class EndPoints {
  // Base URL - Update this when backend is ready
  static const String baseUrl = 'https://api.sheikhy.com/api/';

  // TODO: Add Sheikhy-specific endpoints here as features are developed
  // Example:
  // static const String login = 'auth/login';
  // static const String profile = 'user/profile';

  /* ========================================================================
   * OLD sheikhy ENDPOINTS (COMMENTED OUT FOR REFERENCE)
   * ========================================================================
  static const String baseUrl = 'https://back.dr-law.site/api/';
  static const String login = 'auth/login';
  static const String logout = 'auth/logout';
  static const String profile = 'profile';
  static const String banners = 'web/banners';
  static const String courses = 'web/courses';
  static const String categories = 'web/categories';
  static const String categoryCourses =
      'mobile/student/categories/{id}/courses';
  static const String courseDetails = 'mobile/student/courses/{id}';
  static const String courseExams = 'mobile/student/exams/course/{id}';
  static const String examContent = 'mobile/student/exams/{id}';
  static const String submitExam = 'mobile/student/exams/{id}/submit';
  static const String featuredCourses =
      'mobile/student/courses/featured/all-years';
  static const String myCourses = 'mobile/student/my-courses';
  static const String landing = 'web/landing';
  static const String register = 'register';
  static const String uploadProfileImage = 'user/area/profile-image';
  static const String requestCar = '/reques -api/v1/car';
  static const String carRequests = '/wp/v2/car_request';
  static const String requestDriver = 'request-api/v1/driver';
  static const String notifications = '/notifications';
  static const String markAllNotificationsRead = '/notifications/read-all';
  static const String tickets = '/tickets';
  static const String rateCourse = '/mobile/student/ratings/course';
  static const String help = 'mobile/student/help';
  static const String cart = 'mobile/student/cart';
  static const String registerStudent = 'auth/register/student';
  static const String terms = 'mobile/student/terms';
  static const String privacyPolicy = 'mobile/student/privacy-policy';
  static const String helpSupport = 'mobile/student/help-support';
  static const String about = 'mobile/student/about';
  static const String videoProgress = 'mobile/student/video/progress';
  static const String videoFinish = 'mobile/student/video/finish';
  static const String deleteAccount = 'mobile/student/profile';
  static const String forgetPassword = 'auth/forget-password/student';
  static const String resetPassword = 'auth/reset-password/student';
  */
}

class ApiKey {
  static const String message = 'message';
  static const String token = 'token';
  static const String data = 'data';
}
