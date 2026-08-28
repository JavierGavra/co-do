import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/menu_repository.dart';

class CreateTag implements UseCase<void, CreateTagParams> {
  final MenuRepository _repository;

  const CreateTag(this._repository);

  @override
  Future<Either<Failure, void>> call(CreateTagParams params) {
    return _repository.createTag(params.title, params.backgroundHex);
  }
}

class CreateTagParams extends Equatable {
  final String title;
  final String backgroundHex;

  const CreateTagParams({required this.title, required this.backgroundHex});

  @override
  List<Object> get props => [title, backgroundHex];
}
