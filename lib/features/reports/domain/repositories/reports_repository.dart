import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/reports_summary_entity.dart';

abstract class ReportsRepository {
  Future<Either<Failure, ReportsSummaryEntity>> getSummary({required String range});
}
