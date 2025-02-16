import 'package:bloc/bloc.dart';
import 'package:tutorial_app/features/weather/data/services/weather_service.dart';

class WeatherState {
  final double? lat;
  final double? lon;
  final Map<String, dynamic>? weatherData;
  final Map<String, dynamic>? forecastData;
  final Map<String, dynamic>? airPollutionData;
  final String? errorMessage;
  final bool isLoading;

  WeatherState({
    this.lat,
    this.lon,
    this.weatherData,
    this.forecastData,
    this.airPollutionData,
    this.errorMessage,
    this.isLoading = false,
  });

  WeatherState copyWith({
    double? lat,
    double? lon,
    Map<String, dynamic>? weatherData,
    Map<String, dynamic>? forecastData,
    Map<String, dynamic>? airPollutionData,
    String? errorMessage,
    bool? isLoading,
  }) {
    return WeatherState(
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
      weatherData: weatherData ?? this.weatherData,
      forecastData: forecastData ?? this.forecastData,
      airPollutionData: airPollutionData ?? this.airPollutionData,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService;

  WeatherCubit(this._weatherService) : super(WeatherState());

  // Combined method to fetch both weather and forecast data
  Future<void> fetchWeatherAndForecast(double lat, double lon) async {
    emit(state.copyWith(isLoading: true));
    try {
      // Fetch current weather data
      final weatherData = await _weatherService.getWeatherByLatLon(lat, lon);

      // Fetch 5-day forecast data
      final forecastData =
          await _weatherService.getFiveDayForecastByLatLon(lat, lon);

      // Fetch Air Pollution data
      final airPollutionData =
          await _weatherService.getAirPollutionByLatLon(lat, lon);

      emit(state.copyWith(
        lat: lat,
        lon: lon,
        weatherData: weatherData,
        forecastData: forecastData,
        airPollutionData: airPollutionData,
        isLoading: false,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
      ));
    }
  }
}
