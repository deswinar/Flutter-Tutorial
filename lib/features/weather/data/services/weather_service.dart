import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherService {
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String _forecastUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  final String _airPollutionUrl =
      'http://api.openweathermap.org/data/2.5/air_pollution';
  final String _coordinatesFromCityUrl = 'https://geocode.maps.co/search';
  // final String _cityFromCoordinatesUrl =
  //     'http://api.openweathermap.org/geo/1.0/reverse';
  final String _cityFromCoordinatesUrl = 'https://geocode.maps.co/reverse';
  final Dio _dio = Dio();

  // Fetch current weather data for a city
  Future<Map<String, dynamic>> getWeather(String city) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception('Unexpected error occurred while fetching weather data.');
  }

// Fetch current weather data for a location by latitude and longitude
  Future<Map<String, dynamic>> getWeatherByLatLon(
      double lat, double lon) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception('Unexpected error occurred while fetching weather data.');
  }

// Fetch 5-day/3-hour forecast for a specific city
  Future<Map<String, dynamic>> getFiveDayForecast(String city) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _forecastUrl,
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception('Unexpected error occurred while fetching forecast data.');
  }

// Fetch 5-day/3-hour forecast for a location by latitude and longitude
  Future<Map<String, dynamic>> getFiveDayForecastByLatLon(
      double lat, double lon) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _forecastUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
          'units': 'metric',
        },
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load forecast data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception('Unexpected error occurred while fetching forecast data.');
  }

  // Fetch Air Pollution using latitude and longitude
  Future<Map<String, dynamic>> getAirPollutionByLatLon(
      double lat, double lon) async {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _airPollutionUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'appid': apiKey,
        },
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to load air pollution data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception(
        'Unexpected error occurred while fetching air pollution data.');
  }

  // Fetch current weather data for a city
  Future<List<dynamic>> getCoordinatesFromCity(String city) async {
    final apiKey = dotenv.env['GEOCODE_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _coordinatesFromCityUrl,
        queryParameters: {
          'q': city,
          'api_key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        final dataList = response.data as List<dynamic>;
        return dataList;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception('Unexpected error occurred while fetching weather data.');
  }

  // Fetch current weather data for a city
  Future<Map<String, dynamic>> getCityFromCoordinates(
      double lat, double lon) async {
    final apiKey = dotenv.env['GEOCODE_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is not configured in .env');
    }

    try {
      final response = await _dio.get(
        _cityFromCoordinatesUrl,
        queryParameters: {
          'lat': lat,
          'lon': lon,
          'api_key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        debugPrint(response.data.toString());

        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _handleDioError(e);
    }
    throw Exception('Unexpected error occurred while fetching weather data.');
  }

  // Handling Dio-specific errors
  void _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      throw Exception(
          'Connection timeout. Please check your internet connection.');
    } else if (error.type == DioExceptionType.receiveTimeout) {
      throw Exception('Server response timeout.');
    } else if (error.type == DioExceptionType.badResponse) {
      throw Exception(
          'Failed to load weather data: ${error.response?.statusCode}');
    } else {
      throw Exception('Failed to load weather data: ${error.message}');
    }
  }
}
