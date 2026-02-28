class SessionReport {
  final List<RecitationItem> newMemorization;
  final RecitationRating newMemorizationRating;
  final List<RecitationItem> recentReview;
  final RecitationRating recentReviewRating;
  final List<RecitationItem> distantReview;
  final RecitationRating distantReviewRating;
  final List<RecitationItem> upcomingMemorization;

  SessionReport({
    required this.newMemorization,
    required this.newMemorizationRating,
    required this.recentReview,
    required this.recentReviewRating,
    required this.distantReview,
    required this.distantReviewRating,
    required this.upcomingMemorization,
  });
}

class RecitationItem {
  final String surahName;
  final int? fromAyah;
  final int? toAyah;
  final bool isFullSurah;

  RecitationItem({
    required this.surahName,
    this.fromAyah,
    this.toAyah,
    this.isFullSurah = false,
  });
}

class RecitationRating {
  final int score;
  final String? note;

  RecitationRating({required this.score, this.note});
}
