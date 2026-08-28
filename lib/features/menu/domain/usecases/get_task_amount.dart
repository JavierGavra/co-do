import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/menu_repository.dart';

class GetTaskAmount implements UseCase<int, NoParams> {
  final MenuRepository _repository;

  const GetTaskAmount(this._repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.getTaskAmount();
  }
}
