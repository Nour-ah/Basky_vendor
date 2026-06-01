import 'package:equatable/equatable.dart';
import '../../domain/entities/reports_summary_entity.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final ReportsSummaryEntity summary;
  final String selectedRange;

  const ReportsLoaded({required this.summary, required this.selectedRange});

  ReportsLoaded copyWith({ReportsSummaryEntity? summary, String? selectedRange}) {
    return ReportsLoaded(
      summary: summary ?? this.summary,
      selectedRange: selectedRange ?? this.selectedRange,
    );
  }

  @override
  List<Object?> get props => [summary, selectedRange];
}

class ReportsError extends ReportsState {
  final String message;
  final bool isNetworkError;

  const ReportsError(this.message, {this.isNetworkError = false});

  @override
  List<Object?> get props => [message, isNetworkError];
}
