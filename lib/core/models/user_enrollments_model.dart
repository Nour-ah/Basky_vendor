import 'course_subscription_model.dart';

class UserEnrollments {
  final String userId;
  final List<CourseSubscription> enrolledCourses;

  UserEnrollments({required this.userId, required this.enrolledCourses});

  // Get all enrolled courses
  List<CourseSubscription> getEnrolledCourses() {
    return enrolledCourses;
  }

  // Get subscribed sheikh IDs for a specific course
  List<String> getSubscribedSheikhsForCourse(String courseId) {
    final courseSubscription = enrolledCourses.firstWhere(
      (course) => course.courseId == courseId,
      orElse: () => CourseSubscription(
        courseId: '',
        subscribedSheikhIds: [],
        enrollmentDate: DateTime.now(),
        progress: 0,
      ),
    );
    return courseSubscription.subscribedSheikhIds;
  }

  // Get a specific course subscription
  CourseSubscription? getCourseSubscription(String courseId) {
    try {
      return enrolledCourses.firstWhere(
        (course) => course.courseId == courseId,
      );
    } catch (e) {
      return null;
    }
  }

  // Check if user is enrolled in a course
  bool isEnrolledInCourse(String courseId) {
    return enrolledCourses.any((course) => course.courseId == courseId);
  }

  // Get total number of enrolled courses
  int get totalEnrolledCourses => enrolledCourses.length;

  // Get average progress across all courses
  double get averageProgress {
    if (enrolledCourses.isEmpty) return 0.0;
    final totalProgress = enrolledCourses.fold(
      0.0,
      (sum, course) => sum + course.progress,
    );
    return totalProgress / enrolledCourses.length;
  }

  // Get courses sorted by enrollment date (newest first)
  List<CourseSubscription> get coursesSortedByDate {
    final sorted = List<CourseSubscription>.from(enrolledCourses);
    sorted.sort((a, b) => b.enrollmentDate.compareTo(a.enrollmentDate));
    return sorted;
  }

  // Get course IDs only
  List<String> get enrolledCourseIds {
    return enrolledCourses.map((course) => course.courseId).toList();
  }
}
