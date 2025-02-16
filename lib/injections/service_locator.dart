import 'package:get_it/get_it.dart';
import 'package:tutorial_app/features/weather/presentation/cubit/weather_cubit.dart';

import '../features/weather/data/services/weather_service.dart';

final sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerLazySingleton<WeatherService>(() => WeatherService());
  sl.registerLazySingleton<WeatherCubit>(() => WeatherCubit(sl()));
}
