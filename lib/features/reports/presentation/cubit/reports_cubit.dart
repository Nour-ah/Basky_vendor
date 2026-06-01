import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_reports_summary_usecase.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetReportsSummaryUseCase getReportsSummaryUseCase;

  ReportsCubit({required this.getReportsSummaryUseCase}) : super(ReportsInitial());

  Future<void> fetchReports({String range = 'last_30_days'}) async {
    if (isClosed) return;
    emit(ReportsLoading());

    final result = await getReportsSummaryUseCase(GetReportsSummaryParams(range: range));
    if (isClosed) return;

    result.fold(
      (failure) => emit(ReportsError(
        failure.message,
        isNetworkError: failure is NetworkFailure,
      )),
      (summary) => emit(ReportsLoaded(summary: summary, selectedRange: range)),
    );
  }
}
