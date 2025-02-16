import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_animation/weather_animation.dart';

class WeatherAnimations extends StatefulWidget {
  final String weatherCondition;
  final String currentDateTime;
  const WeatherAnimations(
      {super.key,
      required this.weatherCondition,
      required this.currentDateTime});

  @override
  State<WeatherAnimations> createState() => _WeatherAnimationsState();
}

class _WeatherAnimationsState extends State<WeatherAnimations> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        WrapperScene(
          colors: _getBackgroundColors(),
          children: _getWeatherWidgets(),
        ),
      ],
    );
  }

  List<Widget> _getWeatherWidgets() {
    switch (widget.weatherCondition.toLowerCase()) {
      case 'thunderstorm with light rain':
        return _thunderWithRainsAndClouds(rainsCount: 20, thunderDelay: 4000);
      case 'thunderstorm with rain':
        return _thunderWithRainsAndClouds(rainsCount: 30, thunderDelay: 4000);
      case 'thunderstorm with heavy rain':
        return _thunderWithRainsAndClouds(rainsCount: 40, thunderDelay: 4000);
      case 'light thunderstorm':
        return _thunderWithRainsAndClouds(withRain: false, thunderDelay: 5000);
      case 'thunderstorm':
        return _thunderWithRainsAndClouds(withRain: false, thunderDelay: 4000);
      case 'heavy thunderstorm':
        return _thunderWithRainsAndClouds(withRain: false, thunderDelay: 3000);
      case 'ragged thunderstorm':
        return _thunderWithRainsAndClouds(withRain: false, thunderDelay: 2000);
      case 'drizzle':
        return _rainWithClouds(rainsCount: 10);
      case 'light intensity drizzle':
        return _rainWithClouds(rainsCount: 15);
      case 'light rain':
        return _rainWithClouds(rainsCount: 20);
      case 'moderate rain':
        return _rainWithClouds(rainsCount: 30);
      case 'heavy intensity rain':
        return _rainWithClouds(rainsCount: 40);
      case 'snow':
        return _snowWithClouds(snowCount: 30);
      case 'light snow':
        return _snowWithClouds(snowCount: 20);
      case 'heavy snow':
        return _snowWithClouds(snowCount: 40);
      case 'fog':
        return [];
      case 'clear sky':
        return [
          const SunWidget(sunConfig: SunConfig()),
        ];
      case 'few clouds':
        return [
          const CloudWidget(
              cloudConfig:
                  CloudConfig(size: 0.3, color: Colors.white, x: 0.2, y: 0.3)),
        ];
      case 'scattered clouds':
        return [
          const CloudWidget(
              cloudConfig:
                  CloudConfig(size: 0.4, color: Colors.white, x: 0.2, y: 0.3)),
        ];
      case 'overcast clouds':
        return [
          const CloudWidget(
              cloudConfig:
                  CloudConfig(size: 0.5, color: Colors.grey, x: 0.3, y: 0.3)),
        ];
      default:
        return [const Text('Weather condition not found')];
    }
  }

  List<Color> _getBackgroundColors() {
    final hour = _getHourFromCurrentDateTime(widget.currentDateTime);

    // Use the same time-based conditions as above
    if (hour >= 5 && hour < 7) {
      return [Colors.deepPurple, Colors.orangeAccent];
    } else if (hour >= 7 && hour < 10) {
      return [Colors.lightBlue.shade300, Colors.yellowAccent];
    } else if (hour >= 10 && hour < 16) {
      return [Colors.blue, Colors.lightBlueAccent];
    } else if (hour >= 16 && hour < 18) {
      return [Colors.orange, Colors.deepOrangeAccent];
    } else if (hour >= 18 && hour < 20) {
      return [Colors.indigo, Colors.deepPurpleAccent];
    } else if (hour >= 20 || hour < 5) {
      return [Colors.black, Colors.blueGrey];
    } else {
      return [Colors.blue, Colors.white];
    }
  }

  int _getHourFromCurrentDateTime(String currentDateTime) {
    final timePart =
        currentDateTime.split('•').last.trim(); // Extract 'hh:mm a'
    final parsedTime = DateFormat('hh:mm a').parse(timePart); // Parse time part
    return parsedTime.hour;
  }

  List<Color> _getBackgroundColors1() {
    switch (widget.weatherCondition) {
      case 'thunderstorm with light rain':
      case 'thunderstorm with rain':
      case 'thunderstorm with heavy rain':
        return [Colors.black, Colors.blueGrey];
      case 'drizzle':
      case 'light intensity drizzle':
        return [Colors.lightBlue, Colors.white];
      case 'snow':
      case 'heavy snow':
        return [Colors.white, Colors.lightBlue];
      case 'fog':
        return [Colors.grey, Colors.white];
      case 'clear sky':
        return [Colors.blue, Colors.yellow];
      case 'few clouds':
      case 'scattered clouds':
      case 'overcast clouds':
        return [Colors.grey, Colors.white];
      default:
        return [Colors.blue, Colors.white];
    }
  }
}

List<Widget> _rainWithClouds({int rainsCount = 20, int cloudsCount = 2}) {
  return [
    RainWidget(
      rainConfig: RainConfig(
        count: rainsCount,
        lengthDrop: 13,
        color: const Color(0xff9e9e9e),
        areaXStart: 41,
        areaXEnd: 264,
        areaYStart: 208,
        areaYEnd: 620,
        fallCurve: const Cubic(0.55, 0.09, 0.68, 0.53),
        fadeCurve: const Cubic(0.95, 0.05, 0.80, 0.04),
      ),
    ),
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 200,
        color: Color(0xcdbdbdbd),
        x: 50,
        y: 30,
        slideX: 15,
        slideY: 4,
        slideDurMill: 4000,
      ),
    ),
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 150,
        color: Color(0xb5fafafa),
        x: 100,
        y: 60,
        slideX: 15,
        slideY: 4,
        slideDurMill: 4000,
      ),
    ),
    // Below is Dummy 0 size CloudWidget to prevent anomaly behaviour
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 0,
      ),
    ),
  ];
}

List<Widget> _thunderWithRainsAndClouds(
    {bool withRain = true,
    int rainsCount = 20,
    int thunderDelay = 4000,
    int cloudsCount = 2}) {
  return [
    if (withRain) ...[
      RainWidget(
        rainConfig: RainConfig(
          count: rainsCount,
          lengthDrop: 13,
          color: const Color(0xff9e9e9e),
          areaXStart: 41,
          areaXEnd: 264,
          areaYStart: 208,
          areaYEnd: 620,
          fallCurve: const Cubic(0.55, 0.09, 0.68, 0.53),
          fadeCurve: const Cubic(0.95, 0.05, 0.80, 0.04),
        ),
      ),
    ],
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 200,
        color: Color(0xad90a4ae),
        x: 50,
        y: 30,
        slideX: 15,
        slideY: 4,
        slideDurMill: 4000,
      ),
    ),
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 150,
        color: Color(0xb1607d8b),
        x: 100,
        y: 60,
        slideX: 15,
        slideY: 4,
        slideDurMill: 4000,
      ),
    ),
    ThunderWidget(thunderConfig: ThunderConfig(pauseEndMill: thunderDelay)),
    // Below is Dummy 0 size CloudWidget to prevent anomaly behaviour
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 0,
      ),
    ),
  ];
}

List<Widget> _snowWithClouds({int snowCount = 20}) {
  return [
    SnowWidget(
      snowConfig: SnowConfig(
        count: snowCount,
        size: 20,
        color: const Color(0xb3ffffff),
        icon: const IconData(57399, fontFamily: 'MaterialIcons'),
        areaXStart: 42,
        areaXEnd: 240,
        waveRangeMax: 70,
        waveCurve: const Cubic(0.45, 0.05, 0.55, 0.95),
        fadeCurve: const Cubic(0.60, 0.04, 0.98, 0.34),
      ),
    ),
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 200,
        color: Color(0xa8fafafa),
        x: 20,
        y: 3,
        slideX: 20,
        slideY: 0,
        slideDurMill: 4000,
      ),
    ),
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 150,
        color: Color(0xa8fafafa),
        x: 140,
        y: 97,
        slideX: 20,
        slideY: 4,
        slideDurMill: 4000,
      ),
    ),
    // Below is Dummy 0 size CloudWidget to prevent anomaly behaviour
    const CloudWidget(
      cloudConfig: CloudConfig(
        size: 0,
      ),
    ),
  ];
}
