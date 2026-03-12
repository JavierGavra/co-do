import 'package:dartz/dartz.dart';

import 'package:codo/core/error/failures.dart';
import 'package:codo/core/usecase/usecase.dart';
import '../repositories/task_repository.dart';

class GetMyDayAmount implements UseCase<int, NoParams> {
  final TaskRepository repository;

  const GetMyDayAmount({required this.repository});

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.getMyDayAmmount();
  }
}
