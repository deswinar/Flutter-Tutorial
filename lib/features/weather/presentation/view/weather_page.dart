import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_app/core/utils/helpers.dart';
import 'package:tutorial_app/features/weather/presentation/widgets/map_picker.dart';
import 'package:tutorial_app/features/weather/presentation/widgets/weather_animations.dart';
import 'package:tutorial_app/injections/service_locator.dart';
import 'package:tutorial_app/router/app_router.dart';

import '../../data/services/weather_service.dart';
import '../cubit/weather_cubit.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeatherView();
  }
}

class WeatherView extends StatefulWidget {
  const WeatherView({super.key});

  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView>
    with SingleTickerProviderStateMixin {
  String currentLocation = 'Loading...'; // Default text while loading city
  LatLng currentLatLon =
      LatLng(51.5098, -0.1180); // Default text while loading city
  final List<String> cityList = [
    'New York',
    'London',
    'Tokyo',
    'Paris',
    'Sydney',
    'Mumbai',
    'Cairo',
    'Jakarta',
    'Bangkok',
    'Seoul',
    'Riyadh',
  ]; // Example cities

  String currentDateTime =
      DateFormat('EEEE, MMM d • hh:mm a').format(DateTime.now().toUtc());
  int? timezoneOffset; // Store the timezone offset for the selected city
  String? weatherDescription; // New variable for weather description

  @override
  void initState() {
    super.initState();
    _initializeCity();
    _updateDateTime();
  }

  // Fetch initial city and weather details
  Future<void> _initializeCity() async {
    try {
      // Fetch weather data for a default city
      await _fetchWeather(currentLatLon.latitude, currentLatLon.longitude);
      await _handleLocationPicked(currentLatLon);
    } catch (e) {
      // Fallback to London in case of any error
      setState(() {
        currentLocation = 'London';
      });
    }
  }

  // Fetch weather data from the WeatherCubit
  Future<void> _fetchWeather(double lat, double lon) async {
    await context.read<WeatherCubit>().fetchWeatherAndForecast(lat, lon);
    final state = context.read<WeatherCubit>().state;

    // Extract city and country details from the API response
    if (state.weatherData != null) {
      final weatherData = state.weatherData!;
      setState(() {
        timezoneOffset =
            weatherData['timezone'] as int?; // Timezone offset (seconds)
        weatherDescription = weatherData['weather'][0]['description']
            as String; // Weather description
      });
      _updateDateTime(); // Update time based on the new city's timezone
    }
  }

  void _updateDateTime() {
    if (timezoneOffset == null) return; // Wait for the timezone to be fetched

    final now = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset!));
    setState(() {
      currentDateTime = DateFormat('EEEE, MMM d • hh:mm a').format(now);
    });
    // setState(() {});
    Future.delayed(
        const Duration(minutes: 1), _updateDateTime); // Update every minute
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            // _showMapPicker(context);
            await context
                .push(Routes.weatherSearch, extra: currentLatLon)
                .then((selectedLocation) {
              currentLatLon = selectedLocation as LatLng;
              _handleLocationPicked(selectedLocation as LatLng);
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentLocation,
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
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                ],
              ),
              Text(
                currentDateTime,
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
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity, // Ensure the container takes full width
        height: double.infinity, // Ensure the container takes full height
        child: Stack(
          children: [
            WeatherAnimations(
              weatherCondition: weatherDescription ?? 'clear sky',
              currentDateTime: currentDateTime,
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    BlocBuilder<WeatherCubit, WeatherState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const CircularProgressIndicator();
                        } else if (state.errorMessage != null) {
                          return Text('Error: ${state.errorMessage}');
                        } else if (state.weatherData != null) {
                          final weatherData = state.weatherData!;
                          final forecastData = state.forecastData!;
                          final airPollutionData = state.airPollutionData!;
                          return _buildWeatherDetails(
                              weatherData, forecastData, airPollutionData);
                        } else {
                          return const Text('No data available');
                        }
                      },
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

  Widget _buildWeatherDetails(
      Map<String, dynamic> weatherData,
      Map<String, dynamic> forecastData,
      Map<String, dynamic> airPollutionData) {
    // Weather Data (already provided)
    final main = weatherData['main'];
    final weather =
        weatherData['weather'][0]; // Assuming the first weather object
    final temperature = main['temp'] as double;
    final iconCode = weather['icon']; // Icon code from API
    final description = weather['description']; // Weather description
    final wind = weatherData['wind'];
    final visibility = weatherData['visibility'] as int; // Visibility in meters
    final sys = weatherData['sys'];
    final sunrise = DateTime.fromMillisecondsSinceEpoch(
        (sys['sunrise'] as int) * 1000,
        isUtc: true);
    final sunset = DateTime.fromMillisecondsSinceEpoch(
        (sys['sunset'] as int) * 1000,
        isUtc: true);

    // Forecast Data
    final forecastCity = forecastData['city'];
    final forecastList = forecastData['list'] as List;

    // Air Pollution Data
    final airPollution = airPollutionData['list'][0];
    final aqi = airPollution['main']['aqi'];
    final components = airPollution['components'];

    // Determine the AQI status
    String aqiStatus = '';
    Color aqiColor = Colors.green;
    if (aqi == 1) {
      aqiStatus = 'Good';
      aqiColor = Colors.green;
    } else if (aqi == 2) {
      aqiStatus = 'Fair';
      aqiColor = Colors.yellow;
    } else if (aqi == 3) {
      aqiStatus = 'Moderate';
      aqiColor = Colors.orange;
    } else if (aqi == 4) {
      aqiStatus = 'Poor';
      aqiColor = Colors.red;
    } else if (aqi == 5) {
      aqiStatus = 'Very Poor';
      aqiColor = Colors.purple;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  capitalize(description.toString()), // Capitalize description
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
            color: Colors.white.withOpacity(0.8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildWeatherSection(
                    'Atmosphere',
                    [
                      _buildRowWithIcon(
                          Icons.water_drop, 'Humidity', '${main['humidity']}%'),
                      _buildRowWithIcon(Icons.compress, 'Pressure',
                          '${main['pressure']} hPa'),
                      _buildRowWithIcon(Icons.visibility, 'Visibility',
                          '${visibility / 1000} km'),
                    ],
                  ),
                  const Divider(),
                  _buildWeatherSection(
                    'Temperature',
                    [
                      _buildRowWithIcon(Icons.thermostat, 'Min Temp',
                          '${main['temp_min']}°C'),
                      _buildRowWithIcon(Icons.thermostat, 'Max Temp',
                          '${main['temp_max']}°C'),
                    ],
                  ),
                  const Divider(),
                  _buildWeatherSection(
                    'Wind',
                    [
                      _buildRowWithIcon(
                          Icons.air, 'Wind Speed', '${wind['speed']} m/s'),
                      _buildRowWithIcon(
                          Icons.navigation, 'Direction', '${wind['deg']}°'),
                      _buildRowWithIcon(
                          Icons.air, 'Gust', '${wind['gust'] ?? 'N/A'}'),
                    ],
                  ),
                  const Divider(),
                  _buildWeatherSection(
                    'Sun Cycle',
                    [
                      _buildRowWithIcon(Icons.wb_sunny_outlined, 'Sunrise',
                          DateFormat('hh:mm a').format(sunrise.toLocal())),
                      _buildRowWithIcon(
                          Icons.nightlight_round_outlined,
                          'Sunset',
                          DateFormat('hh:mm a').format(sunset.toLocal())),
                    ],
                  ),
                  const Divider(),
                  _buildWeatherSection(
                    'Location',
                    [
                      _buildRowWithIcon(Icons.location_on, 'Coordinates',
                          'Lat: ${weatherData['coord']['lat']}, Lon: ${weatherData['coord']['lon']}'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Forecast Section - Horizontal Scroll
          const SizedBox(height: 24),
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Text(
                    '5 Day Forecast',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  // Forecast List
                  SizedBox(
                    height: 230, // Increased height to accommodate larger cards
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: forecastList.length,
                      itemBuilder: (context, index) {
                        final forecast = forecastList[index];
                        final DateTime forecastTime =
                            DateTime.fromMillisecondsSinceEpoch(
                                (forecast['dt'] as int) * 1000,
                                isUtc: true);
                        final weatherDesc =
                            forecast['weather'][0]['description'] as String;
                        final forecastTemp = forecast['main']['temp'] as double;

                        return GestureDetector(
                          onTap: () {
                            context.push(Routes.forecastDetails, extra: {
                              'forecast': forecast,
                              'forecastData': forecastData,
                              'currentLocation': currentLocation,
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Container(
                              width: 160, // Fixed width for each card
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      DateFormat('MMM d • hh:mm a')
                                          .format(forecastTime),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Image.network(
                                      'https://openweathermap.org/img/wn/${forecast['weather'][0]['icon']}@2x.png',
                                      width: 60,
                                      height: 60,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      weatherDesc,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${forecastTemp.toStringAsFixed(1)}°C',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // AQI Section with Highlight
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.air, color: aqiColor, size: 40),
                      SizedBox(width: 10),
                      Text(
                        'AQI ${aqi}: $aqiStatus',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: aqiColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildWeatherSection(
                    'Particulate Matter (PM)',
                    [
                      _buildRowWithIcon(Icons.bubble_chart, 'PM2.5',
                          components['pm2_5'].toString()),
                      _buildRowWithIcon(Icons.cloud_circle, 'PM10',
                          components['pm10'].toString()),
                    ],
                  ),
                  const Divider(),
                  _buildWeatherSection(
                    'Gaseous Pollutants',
                    [
                      _buildRowWithIcon(Icons.local_fire_department, 'CO',
                          components['co'].toString()),
                      _buildRowWithIcon(
                          Icons.flash_on, 'NO2', components['no2'].toString()),
                      _buildRowWithIcon(
                          Icons.cloud, 'O3', components['o3'].toString()),
                      _buildRowWithIcon(
                          Icons.water, 'SO2', components['so2'].toString()),
                      _buildRowWithIcon(Icons.airline_seat_recline_normal,
                          'NH3', components['nh3'].toString()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithIcon(IconData icon, String label, String value) {
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

  Widget buildComponentRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          SizedBox(width: 10),
          Text(
            '$label: ${value.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showCitySelectionSheet(BuildContext context) {
    String query = '';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredCities = cityList
                .where(
                    (city) => city.toLowerCase().contains(query.toLowerCase()))
                .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search City',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        query = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCities.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          filteredCities[index],
                          style: TextStyle(
                            fontWeight: filteredCities[index] == currentLocation
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () async {
                          final selectedCity = filteredCities[index];
                          Navigator.pop(context);
                          // await _fetchWeather(selectedCity);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMapPicker(BuildContext context) async {
    final LatLng? selectedLocation = await showModalBottomSheet<LatLng>(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const MapPicker(
            initialLocation:
                LatLng(51.5098, -0.1180)); // Example coordinates (London));
      },
    );
    debugPrint(selectedLocation.toString());

    if (selectedLocation != null) {
      _handleLocationPicked(selectedLocation);
    }
  }

  Future<void> _handleLocationPicked(LatLng selectedLocation) async {
    final geolocation = await sl<WeatherService>().getCityFromCoordinates(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );

    if (geolocation != null) {
      // Extract address fields
      final address = geolocation['address'] as Map<String, dynamic>?;
      if (address != null) {
        // Build location string based on field availability
        String locationName;

        if (address.containsKey('suburb') && address.containsKey('city')) {
          locationName = '${address['suburb']}, ${address['city']}';
        } else if (address.containsKey('city')) {
          locationName = address['city'].toString();
        } else if (address.containsKey('country')) {
          locationName = address['country'].toString();
        } else {
          locationName =
              geolocation['display_name'].toString() ?? 'Unknown Location';
        }

        setState(() {
          currentLocation = locationName;
        });

        await _fetchWeather(
            selectedLocation.latitude, selectedLocation.longitude);
      } else {
        // Handle missing address gracefully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch location details.')),
        );
      }
    } else {
      // Handle case when reverse geocoding fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch city name. Try again.')),
      );
    }
  }
}
