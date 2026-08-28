import 'package:get_it/get_it.dart';

import 'core/database/database_helper.dart';
import 'features/menu/data/datasources/menu_local_datasource.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/menu/domain/repositories/menu_repository.dart';
import 'features/menu/domain/usecases/create_tag.dart';
import 'features/menu/domain/usecases/get_my_day_amount.dart';
import 'features/menu/domain/usecases/get_tag_menu_items.dart';
import 'features/menu/domain/usecases/get_task_amount.dart';
import 'features/menu/domain/usecases/update_tags_order.dart';
import 'features/menu/presentasion/bloc/menu_bloc.dart';
import 'features/tag/data/datasource/tag_local_data_source.dart';
import 'features/tag/data/repositories/tag_repository_impl.dart';
import 'features/tag/domain/repositories/tag_repository.dart';
import 'features/tag/domain/usecases/delete_tag.dart';
import 'features/tag/domain/usecases/get_tags.dart';
import 'features/tag/presentasion/cubit/tag_cubit.dart';
import 'features/task/data/datasources/task_local_data_source.dart';
import 'features/task/data/repositories/task_repository_impl.dart';
import 'features/task/domain/repositories/task_repository.dart';
import 'features/task/domain/usecases/delete_task.dart';
import 'features/task/domain/usecases/get_all_tasks.dart';
import 'features/task/domain/usecases/get_my_day.dart';
import 'features/task/domain/usecases/post_task.dart';
import 'features/task/domain/usecases/task_checked.dart';
import 'features/task/presentasion/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeServiceLocator() async {
  // Feature
  _initTaskFeature();
  _initTagFeature();
  _initMenuFeature();

  // DATABASE
  final database = await DatabaseHelper.instance.database;
  sl.registerSingleton(database);
}

void _initTaskFeature() {
  sl.registerFactory(
    () => TaskBloc(
      getMyDay: sl(),
      getAllTasks: sl(),
      postTask: sl(),
      deleteTask: sl(),
      taskChecked: sl(),
    ),
  );

  // Usecase
  sl.registerLazySingleton(() => GetMyDay(repository: sl()));
  sl.registerLazySingleton(() => GetAllTasks(repository: sl()));
  sl.registerLazySingleton(() => PostTask(repository: sl()));
  sl.registerLazySingleton(() => DeleteTask(repository: sl()));
  sl.registerLazySingleton(() => TaskChecked(repository: sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(database: sl()),
  );
}

void _initTagFeature() {
  sl.registerFactory(() => TagCubit(getTags: sl()));

  // Usecase
  sl.registerLazySingleton(() => GetTags(repository: sl()));
  sl.registerLazySingleton(() => DeleteTag(repository: sl()));

  // Repository
  sl.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<TagLocalDataSource>(
    () => TagLocalDataSourceImpl(database: sl()),
  );
}

void _initMenuFeature() {
  sl.registerFactory(
    () => MenuBloc(
      getTagMenuItems: sl(),
      getTaskAmount: sl(),
      getMyDayAmount: sl(),
      createTag: sl(),
      updateTagsOrder: sl(),
    ),
  );

  // Usecase
  sl.registerLazySingleton(() => GetTagMenuItems(sl()));
  sl.registerLazySingleton(() => GetTaskAmount(sl()));
  sl.registerLazySingleton(() => GetMyDayAmount(sl()));
  sl.registerLazySingleton(() => CreateTag(sl()));
  sl.registerLazySingleton(() => UpdateTagsOrder(sl()));

  // Repository
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(localDataSource: sl()),
  );

  // Data Source
  sl.registerLazySingleton<MenuLocalDatasource>(
    () => MenuLocalDatasourceImpl(database: sl()),
  );
}
