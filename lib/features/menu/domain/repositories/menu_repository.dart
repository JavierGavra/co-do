import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/tag_menu_item.dart';
import '../usecases/update_tags_order.dart';

abstract interface class MenuRepository {
  Future<Either<Failure, int>> getMyDayAmount();
  Future<Either<Failure, int>> getTaskAmount();
  Future<Either<Failure, List<TagMenuItem>>> getTagMenuItems();
  Future<Either<Failure, void>> createTag(String title, String backgroundHex);
  Future<Either<Failure, void>> updateTagsOrder(UpdateTagsOrderParams params);
}
