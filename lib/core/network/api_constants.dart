/// API Configuration Constants
class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'https://shike.developteam.site';
  static const String apiVersion = '/api';

  // Authentication Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // User Endpoints
  static const String userProfile = '/user';
  static const String updatePassword = '/users/me/password';
  static const String deleteAccount = '/users/me';

  // Courses Endpoints
  static const String courses = '/courses';
  static const String featuredCourses = '/courses/featured';

  static String courseDetails(String courseId) => '/courses/$courseId';

  static String courseEnroll(String courseId) => '/courses/$courseId/enroll';

  static String courseLessons(String courseId) => '/courses/$courseId/lessons';

  static String courseProgress(String courseId) =>
      '/courses/$courseId/progress';

  static String courseSheikhs(String courseId) => '/courses/$courseId/sheikhs';

  // Sheikh Endpoints
  static const String sheikhs = '/sheikhs';

  static String sheikhProfile(String sheikhId) => '/sheikhs/$sheikhId';

  static String sheikhCourses(String sheikhId) => '/sheikhs/$sheikhId/courses';

  static String sheikhReviews(String sheikhId) => '/reviews/teachers/$sheikhId';

  // Bookings Endpoints
  static const String bookings = '/bookings';
  static const String myBookings = '/bookings/my-bookings';

  static String bookingReview(String bookingId) =>
      '/reviews/bookings/$bookingId';

  // Video Progress Endpoints
  static String startVideo(String videoId) => '/videos/$videoId/start';

  static String completeVideo(String videoId) => '/videos/$videoId/complete';

  // Notifications Endpoints
  static const String notifications = '/notifications';
  static const String markAllNotificationsRead = '/notifications/read-all';

  static String markNotificationRead(String notifId) =>
      '/notifications/$notifId/read';

  // V1 Endpoints
  static const String v1QuranSheikhs = '/v1/quran-sheikhs';

  static String v1SheikhProfile(String id) => '/v1/quran-sheikhs/$id';
  static const String v1Bookings = '/v1/bookings';

  static String v1SheikhReviews(String id) => '/v1/quran-sheikhs/$id/reviews';
  static const String v1StudentSessions = '/v1/student/sessions';

  static String v1SessionReport(String id) => '/v1/student/sessions/$id/report';
  static const String v1StudentCourses = '/v1/student/courses';

  static String v1CourseDetails(String id) => '/v1/student/courses/$id';

  // V1 Course Sheikh Endpoints (NEW)
  static String v1CourseSheikhDetails(String courseId, String sheikhId) =>
      '/v1/courses/$courseId/sheikhs/$sheikhId';

  static String v1CourseSheikhLessons(String courseId, String sheikhId) =>
      '/v1/courses/$courseId/sheikhs/$sheikhId/lessons';

  static const String v1StudentReports = '/v1/student/reports';

  // Enrollments Endpoints
  static String enrollmentStatus(String courseId) =>
      '/enrollments/$courseId/status';
  static const String myCourses = '/enrollments/my-courses';

  static String enrollmentProgress(String courseId) =>
      '/enrollments/$courseId/progress';

  static String enrollInCourse(String courseId) =>
      '/v1/enrollments/$courseId/enroll';

  static String startLesson(String lessonId) =>
      '/v1/enrollments/lessons/$lessonId/start';

  static String completeLesson(String lessonId) =>
      '/v1/enrollments/lessons/$lessonId/complete';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
}
