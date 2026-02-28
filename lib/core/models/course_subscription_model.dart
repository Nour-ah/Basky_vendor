class CourseSubscription {
  final String courseId;
  final List<String> subscribedSheikhIds;
  final DateTime enrollmentDate;
  final double progress; // من 0.0 إلى 1.0

  CourseSubscription({
    required this.courseId,
    required this.subscribedSheikhIds,
    required this.enrollmentDate,
    required this.progress,
  });

  // Helper method to check if user is subscribed to a specific sheikh
  bool isSubscribedToSheikh(String sheikhId) {
    return subscribedSheikhIds.contains(sheikhId);
  }

  // Get progress as percentage
  int get progressPercentage => (progress * 100).round();

  // Format enrollment date
  String get formattedEnrollmentDate {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${enrollmentDate.day} ${months[enrollmentDate.month - 1]} ${enrollmentDate.year}';
  }

  // Copy with method for immutability
  CourseSubscription copyWith({
    String? courseId,
    List<String>? subscribedSheikhIds,
    DateTime? enrollmentDate,
    double? progress,
  }) {
    return CourseSubscription(
      courseId: courseId ?? this.courseId,
      subscribedSheikhIds: subscribedSheikhIds ?? this.subscribedSheikhIds,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      progress: progress ?? this.progress,
    );
  }
}
