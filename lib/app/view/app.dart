import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_app/features/main_menu/view/main_menu_page.dart';
import 'package:tutorial_app/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:tutorial_app/injections/service_locator.dart';
import 'package:tutorial_app/l10n/l10n.dart';
import 'package:tutorial_app/router/app_router.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<WeatherCubit>(),
        )
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          useMaterial3: true,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: appRouter,
      ),
    );
  }
}
