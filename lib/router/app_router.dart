import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tutorial_app/features/counter/counter.dart';
import 'package:tutorial_app/features/tutorial_animation/presentation/view/tutorial_animation_page.dart';
import 'package:tutorial_app/features/weather/presentation/view/forecast_details_page.dart';
import 'package:tutorial_app/features/weather/weather.dart';
import 'package:tutorial_app/features/main_menu/view/main_menu_page.dart';

import '../features/tutorial_google_maps/presentation/view/map_sample_page.dart';
import '../features/weather/presentation/widgets/map_picker.dart'; // Main Menu page

class Routes {
  static const counterCubit = '/counter/cubit';
  static const counterRiverpod = '/counter/riverpod';
  static const weather = '/weather';
  static const weatherSearch = '/weather/search';
  static const forecastDetails = '/forecast/details';
  static const tutorialGoogleMaps = '/tutorial-google-maps';
  static const tutorialAnimation = '/tutorial-animation';
}

// Define routes
final GoRouter appRouter = GoRouter(
  initialLocation: '/home', // Set the initial route
  routes: [
    // Main Menu Route
    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const MainMenuPage(); // Your main menu widget
      },
    ),
    // Counter using Cubit Route
    GoRoute(
      path: '/counter/cubit',
      builder: (context, state) {
        return const CounterPageCubit(); // Cubit-based CounterPage
      },
    ),
    // Counter using Riverpod Route
    GoRoute(
      path: '/counter/riverpod',
      builder: (context, state) {
        return const CounterPageRiverpod(); // Riverpod-based CounterPage
      },
    ),
    // Weather App Route
    GoRoute(
      path: '/weather',
      builder: (context, state) {
        return const WeatherPage(); // Weather tutorial page
      },
    ),
    // Forecast Details App Route
    GoRoute(
      path: '/forecast/details',
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;
        final forecast = data['forecast'] as Map<String, dynamic>;
        final forecastData = data['forecastData'] as Map<String, dynamic>;
        final currentLocation = data['currentLocation'] as String;
        return ForecastDetailsPage(
          forecast: forecast,
          forecastData: forecastData,
          currentLocation: currentLocation,
        ); // Weather tutorial page
      },
    ),
    // Search Weather Map Picker
    GoRoute(
      path: '/weather/search',
      builder: (context, state) {
        final data = state.extra;
        if (data is! LatLng) {
          throw Exception(
              "Invalid data passed to /weather/search: Expected LatLng.");
        }
        return MapPicker(
          initialLocation: data,
        ); // Weather tutorial page
      },
    ),
    // Tutorial Google Maps Route
    GoRoute(
      path: '/tutorial-google-maps',
      builder: (context, state) {
        return const MapSamplePage(); // Weather tutorial page
      },
    ),
    // Tutorial Animation Route
    GoRoute(
      path: '/tutorial-animation',
      builder: (context, state) {
        return TutorialAnimationPage(); // Weather tutorial page
      },
    ),
  ],
);
