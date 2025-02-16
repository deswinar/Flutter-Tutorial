import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:tutorial_app/injections/service_locator.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  // Add cross-flavor configuration here
  if (kReleaseMode) {
    // For production
    await dotenv.load(fileName: ".env.production");
  } else if (kProfileMode) {
    // For staging
    await dotenv.load(fileName: ".env.staging");
  } else {
    // For development
    await dotenv.load(fileName: ".env.development");
  }
  setupServiceLocator();

  runApp(await builder());
}
