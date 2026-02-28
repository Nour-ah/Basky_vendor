class SessionModel {
  final DateTime date;
  final String dayName;
  final String time;
  final bool isToday;
  final bool isPast;

  SessionModel({
    required this.date,
    required this.dayName,
    required this.time,
    required this.isToday,
    required this.isPast,
  });
}
