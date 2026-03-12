import 'package:codo/core/database/database_helper.dart';
import 'package:codo/features/menu/presentasion/bloc/menu_bloc.dart';
import 'package:codo/features/tag/data/datasource/tag_local_data_source.dart';
import 'package:codo/features/tag/data/repositories/tag_repository_impl.dart';
import 'package:codo/features/tag/domain/repositories/tag_repository.dart';
import 'package:codo/features/tag/domain/usecases/delete_tag.dart';
import 'package:codo/features/tag/domain/usecases/get_tags.dart';
import 'package:codo/features/tag/domain/usecases/post_tag.dart';
import 'package:codo/features/tag/presentasion/cubit/tag_cubit.dart';
import 'package:codo/features/task/data/datasources/task_local_data_source.dart';
import 'package:codo/features/task/data/repositories/task_repository_impl.dart';
import 'package:codo/features/task/domain/repositories/task_repository.dart';
import 'package:codo/features/task/domain/usecases/delete_task.dart';
import 'package:codo/features/task/domain/usecases/get_all_tasks.dart';
import 'package:codo/features/task/domain/usecases/get_my_day.dart';
import 'package:codo/features/task/domain/usecases/get_my_day_amount.dart';
import 'package:codo/features/task/domain/usecases/get_task_amount.dart';
import 'package:codo/features/task/domain/usecases/post_task.dart';
import 'package:codo/features/task/domain/usecases/task_checked.dart';
import 'package:codo/features/task/presentasion/bloc/task_bloc.dart';
import 'package:get_it/get_it.dart';

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
  sl.registerLazySingleton(() => GetMyDayAmount(repository: sl()));
  sl.registerLazySingleton(() => GetTaskAmount(repository: sl()));
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
  sl.registerLazySingleton(() => PostTag(repository: sl()));
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
      getTags: sl(),
      getTaskAmount: sl(),
      getMyDayAmount: sl(),
      postTag: sl(),
    ),
  );
}
