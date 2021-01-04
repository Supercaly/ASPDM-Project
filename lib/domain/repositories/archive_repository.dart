import 'package:aspdm_project/core/either.dart';
import 'package:aspdm_project/core/failures.dart';
import 'package:aspdm_project/domain/entities/task.dart';

abstract class ArchiveRepository {
  Future<Either<Failure, List<Task>>> getArchivedTasks();
}