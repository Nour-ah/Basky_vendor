import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/reports_summary_entity.dart';
import '../repositories/reports_repository.dart';

class GetReportsSummaryParams extends Equatable {
  final String range;

  const GetReportsSummaryParams({this.range = 'last_30_days'});

  @override
  List<Object?> get props => [range];
}

class GetReportsSummaryUseCase implements UseCase<ReportsSummaryEntity, GetReportsSummaryParams> {
  final ReportsRepository repository;

  GetReportsSummaryUseCase(this.repository);

  @override
  Future<Either<Failure, ReportsSummaryEntity>> call(GetReportsSummaryParams params) {
    return repository.getSummary(range: params.range);
  }
}
