import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/tag_menu_item.dart';
import '../repositories/menu_repository.dart';

class GetTagMenuItems implements UseCase<List<TagMenuItem>, NoParams> {
  final MenuRepository _repository;

  const GetTagMenuItems(this._repository);

  @override
  Future<Either<Failure, List<TagMenuItem>>> call(NoParams params) {
    return _repository.getTagMenuItems();
  }
}
