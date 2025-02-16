import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_app/core/utils/helpers.dart';

class ForecastDetailsPage extends StatelessWidget {
  final Map<String, dynamic> forecast;
  final Map<String, dynamic> forecastData;
  final String currentLocation;

  const ForecastDetailsPage(
      {Key? key,
      required this.forecast,
      required this.forecastData,
      required this.currentLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
        (forecast['dt'] as int) * 1000,
        isUtc: true);

    // Weather Data (already provided)
    final main = forecast['main'];
    final weather = forecast['weather'][0]; // Assuming the first weather object
    final temperature = main['temp'] as double;
    final iconCode = weather['icon']; // Icon code from API
    final description = weather['description']; // Weather description
    final wind = forecast['wind'];
    final visibility = forecast['visibility'] as int; // Visibility in meters
    final sys = forecast['sys'];
    final city = forecastData['city'];
    debugPrint(forecastData.toString());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${currentLocation}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              '${DateFormat('EEEE, MMM d • hh:mm a').format(forecastTime)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _getBackgroundGradientColors(description.toString()),
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          // Weather icon
                          Image.network(
                            'https://openweathermap.org/img/wn/$iconCode@2x.png',
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            capitalize(description
                                .toString()), // Capitalize description
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          AnimatedDefaultTextStyle(
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: temperature < 0
                                  ? Colors.blueAccent // Freezing
                                  : temperature <= 10
                                      ? Colors.lightBlue // Cold
                                      : temperature <= 20
                                          ? Colors.lightGreen // Cool
                                          : temperature <= 30
                                              ? Colors.orange // Warm
                                              : temperature <= 35
                                                  ? Colors.deepOrange // Hot
                                                  : Colors.red, // Extreme Heat
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 500),
                            child: Text('${temperature.toStringAsFixed(1)}°C'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Feels Like: ${main['feels_like']}°C',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Grouped Weather Details
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildWeatherSection(
                              'Atmosphere',
                              [
                                _buildWeatherRowWithIcon(Icons.water_drop,
                                    'Humidity', '${main['humidity']}%'),
                                _buildWeatherRowWithIcon(Icons.compress,
                                    'Pressure', '${main['pressure']} hPa'),
                                _buildWeatherRowWithIcon(Icons.visibility,
                                    'Visibility', '${visibility / 1000} km'),
                              ],
                            ),
                            const Divider(),
                            _buildWeatherSection(
                              'Temperature',
                              [
                                _buildWeatherRowWithIcon(Icons.thermostat,
                                    'Min Temp', '${main['temp_min']}°C'),
                                _buildWeatherRowWithIcon(Icons.thermostat,
                                    'Max Temp', '${main['temp_max']}°C'),
                              ],
                            ),
                            const Divider(),
                            _buildWeatherSection(
                              'Wind',
                              [
                                _buildWeatherRowWithIcon(Icons.air,
                                    'Wind Speed', '${wind['speed']} m/s'),
                                _buildWeatherRowWithIcon(Icons.navigation,
                                    'Direction', '${wind['deg']}°'),
                                _buildWeatherRowWithIcon(Icons.air, 'Gust',
                                    '${wind['gust'] ?? 'N/A'}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherRowWithIcon(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildWeatherSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  List<Color> _getBackgroundGradientColors(String weatherDescription) {
    // Customize the gradient based on the weather description
    if (weatherDescription == 'clear sky') {
      return [Colors.blue.shade700, Colors.blue.shade300];
    } else if (weatherDescription?.contains('clouds') ?? false) {
      return [Colors.grey.shade500, Colors.grey.shade300];
    } else if (weatherDescription == 'shower rain' ||
        weatherDescription == 'rain') {
      return [Colors.blueGrey.shade700, Colors.blueGrey.shade400];
    } else if (weatherDescription == 'thunderstorm') {
      return [Colors.black, Colors.grey.shade800];
    } else if (weatherDescription == 'snow') {
      return [Colors.white, Colors.lightBlue.shade100];
    } else if (weatherDescription == 'mist') {
      return [Colors.grey.shade500, Colors.grey.shade400];
    } else {
      // Default gradient for other weather conditions
      return [Colors.blue.shade600, Colors.blue.shade400];
    }
  }
}
