import 'dart:math';

import 'package:flutter/material.dart';

Widget buildWeatherAnimation(
    AnimationController _controller, String selectedWeather) {
  // final _controller = controller;
  switch (selectedWeather.toLowerCase()) {
    case 'thunderstorm with light rain':
      return ThunderstormAnimation(controller: _controller);
    case 'thunderstorm with rain':
      return ThunderstormAnimation(controller: _controller);
    case 'thunderstorm with heavy rain':
      return ThunderstormAnimation(controller: _controller);
    case 'light thunderstorm':
      return ThunderstormAnimation(controller: _controller);
    case 'thunderstorm':
      return ThunderstormAnimation(controller: _controller);
    case 'heavy thunderstorm':
      return ThunderstormAnimation(controller: _controller);
    case 'ragged thunderstorm':
      return ThunderstormAnimation(controller: _controller);
    case 'thunderstorm with light drizzle':
      return ThunderstormAnimation(controller: _controller);
    case 'thunderstorm with drizzle':
      return ThunderstormAnimation(controller: _controller);
    case 'thunderstorm with heavy drizzle':
      return ThunderstormAnimation(controller: _controller);
    case 'light intensity drizzle':
      return DrizzleAnimation(controller: _controller, intensity: 5);
    case 'drizzle':
      return DrizzleAnimation(controller: _controller, intensity: 10);
    case 'heavy intensity drizzle':
      return DrizzleAnimation(controller: _controller, intensity: 20);
    case 'light intensity drizzle rain':
      return DrizzleAnimation(controller: _controller, intensity: 5);
    case 'drizzle rain':
      return DrizzleAnimation(
        controller: _controller,
        intensity: 10,
      );
    case 'heavy intensity drizzle rain':
      return DrizzleAnimation(controller: _controller, intensity: 20);
    case 'shower rain and drizzle':
      return RainAnimation(controller: _controller, intensity: 15);
    case 'heavy shower rain and drizzle':
      return RainAnimation(controller: _controller, intensity: 25);
    case 'shower drizzle':
      return DrizzleAnimation(
        controller: _controller,
        intensity: 5,
      );
    case 'light rain':
      return RainAnimation(controller: _controller, intensity: 5);
    case 'moderate rain':
      return RainAnimation(controller: _controller, intensity: 15);
    case 'heavy intensity rain':
      return RainAnimation(controller: _controller, intensity: 25);
    case 'very heavy rain':
      return RainAnimation(controller: _controller, intensity: 35);
    case 'extreme rain':
      return RainAnimation(controller: _controller, intensity: 50);
    case 'freezing rain':
      return FreezingRainAnimation(controller: _controller);
    case 'light intensity shower rain':
      return RainAnimation(controller: _controller, intensity: 10);
    case 'shower rain':
      return RainAnimation(controller: _controller, intensity: 20);
    case 'heavy intensity shower rain':
      return RainAnimation(controller: _controller, intensity: 30);
    case 'ragged shower rain':
      return RainAnimation(controller: _controller, intensity: 20);
    case 'light snow':
      return SnowAnimation(controller: _controller, intensity: 5);
    case 'snow':
      return SnowAnimation(controller: _controller, intensity: 15);
    case 'heavy snow':
      return SnowAnimation(controller: _controller, intensity: 25);
    case 'sleet':
      return SleetAnimation(controller: _controller);
    case 'light shower sleet':
      return SleetAnimation(controller: _controller, light: true);
    case 'shower sleet':
      return SleetAnimation(controller: _controller);
    case 'light rain and snow':
      return MixedPrecipitationAnimation(controller: _controller);
    case 'rain and snow':
      return MixedPrecipitationAnimation(controller: _controller);
    case 'light shower snow':
      return SnowAnimation(controller: _controller, intensity: 5);
    case 'shower snow':
      return SnowAnimation(controller: _controller, intensity: 15);
    case 'heavy shower snow':
      return SnowAnimation(controller: _controller, intensity: 25);
    case 'mist':
      return MistAnimation(controller: _controller);
    case 'smoke':
      return SmokeAnimation(controller: _controller);
    case 'haze':
      return HazeAnimation(controller: _controller);
    case 'sand/dust whirls':
      return SandDustAnimation(controller: _controller);
    case 'fog':
      return FogAnimation(controller: _controller);
    case 'sand':
      return SandAnimation(controller: _controller);
    case 'dust':
      return DustAnimation(controller: _controller);
    case 'volcanic ash':
      return VolcanicAshAnimation(controller: _controller);
    case 'squalls':
      return SquallAnimation(controller: _controller);
    case 'tornado':
      return TornadoAnimation(controller: _controller);
    case 'clear sky':
      return Container(color: Colors.blue);
    case 'few clouds':
      return CloudAnimation(controller: _controller, cloudCount: 5);
    case 'scattered clouds':
      return CloudAnimation(controller: _controller, cloudCount: 15);
    case 'broken clouds':
      return CloudAnimation(
          controller: _controller, cloudCount: 10, broken: true);
    case 'overcast clouds':
      return CloudAnimation(controller: _controller, cloudCount: 20);
    default:
      return Container(color: Colors.blue); // Default for Clear Sky
  }
}

class CloudAnimation extends StatelessWidget {
  final AnimationController controller;
  final int cloudCount;
  final bool broken;

  CloudAnimation(
      {required this.controller,
      required this.cloudCount,
      this.broken = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CloudPainter(controller.value, cloudCount, broken),
          child: Container(),
        );
      },
    );
  }
}

class CloudPainter extends CustomPainter {
  final double progress;
  final int cloudCount;
  final bool broken;

  CloudPainter(this.progress, this.cloudCount, this.broken);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.8);
    final random = Random();

    for (int i = 0; i < cloudCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height / 2;
      final width = random.nextDouble() * 150 + 100;
      final height = random.nextDouble() * 30 + 20;

      if (broken && random.nextBool()) {
        // Draw clouds with gaps (broken clouds)
        canvas.drawRect(
            Rect.fromLTWH(x + progress * 100, y, width, height), paint);
      } else {
        // Normal clouds
        canvas.drawOval(
            Rect.fromLTWH(x + progress * 100, y, width, height), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RainAnimation extends StatelessWidget {
  final AnimationController controller;
  final int intensity;

  RainAnimation({required this.controller, required this.intensity});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RainPainter(controller.value, intensity),
          child: Container(),
        );
      },
    );
  }
}

class RainPainter extends CustomPainter {
  final double progress;
  final int intensity;

  RainPainter(this.progress, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blueAccent;
    final random = Random();

    for (int i = 0; i < intensity; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y + 10), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ThunderstormAnimation extends StatelessWidget {
  final AnimationController controller;

  ThunderstormAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ThunderstormPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class ThunderstormPainter extends CustomPainter {
  final double progress;

  ThunderstormPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.yellow.withOpacity(0.8);

    // Lightning effect
    if (progress > 0.8) {
      final random = Random();
      final x1 = random.nextDouble() * size.width;
      final x2 = random.nextDouble() * size.width;
      canvas.drawLine(Offset(x1, 0), Offset(x2, size.height), paint);
    }

    // Rain effect
    final rainPaint = Paint()..color = Colors.blueAccent;
    final rainIntensity = 20;
    for (int i = 0; i < rainIntensity; i++) {
      final random = Random();
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y + 10), rainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SnowAnimation extends StatelessWidget {
  final AnimationController controller;
  final int intensity;

  SnowAnimation({required this.controller, required this.intensity});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SnowPainter(controller.value, intensity),
          child: Container(),
        );
      },
    );
  }
}

class SnowPainter extends CustomPainter {
  final double progress;
  final int intensity;

  SnowPainter(this.progress, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final random = Random();

    for (int i = 0; i < intensity; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MistAnimation extends StatelessWidget {
  final AnimationController controller;

  MistAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MistPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class MistPainter extends CustomPainter {
  final double progress;

  MistPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.3);
    final random = Random();

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), 15, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrizzleAnimation extends StatelessWidget {
  final AnimationController controller;
  final int intensity;

  DrizzleAnimation({required this.controller, required this.intensity});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DrizzlePainter(controller.value, intensity),
          child: Container(),
        );
      },
    );
  }
}

class DrizzlePainter extends CustomPainter {
  final double progress;
  final int intensity;

  DrizzlePainter(this.progress, this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.lightBlueAccent.withOpacity(0.7);
    final random = Random();

    for (int i = 0; i < intensity; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y + 5), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FreezingRainAnimation extends StatelessWidget {
  final AnimationController controller;

  FreezingRainAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FreezingRainPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class FreezingRainPainter extends CustomPainter {
  final double progress;

  FreezingRainPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rainPaint = Paint()..color = Colors.blueAccent;
    final icePaint = Paint()..color = Colors.white.withOpacity(0.9);
    final random = Random();

    // Rain effect
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y + 10), rainPaint);
    }

    // Ice chunks
    for (int i = 0; i < 10; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), 3, icePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SleetAnimation extends StatelessWidget {
  final AnimationController controller;
  final bool light;

  SleetAnimation({required this.controller, this.light = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SleetPainter(controller.value, light),
          child: Container(),
        );
      },
    );
  }
}

class SleetPainter extends CustomPainter {
  final double progress;
  final bool light;

  SleetPainter(this.progress, this.light);

  @override
  void paint(Canvas canvas, Size size) {
    final rainPaint = Paint()..color = Colors.blueAccent;
    final sleetPaint = Paint()..color = Colors.white;
    final random = Random();

    final intensity = light ? 10 : 20;

    // Rain effect
    for (int i = 0; i < intensity; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y + 10), rainPaint);
    }

    // Sleet effect
    for (int i = 0; i < intensity / 2; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), 2, sleetPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SmokeAnimation extends StatelessWidget {
  final AnimationController controller;

  SmokeAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SmokePainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class SmokePainter extends CustomPainter {
  final double progress;

  SmokePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.5);
    final random = Random();

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() - progress) * size.height % size.height;
      final radius = random.nextDouble() * 20 + 10; // Random smoke puff size
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HazeAnimation extends StatelessWidget {
  final AnimationController controller;

  HazeAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: HazePainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class HazePainter extends CustomPainter {
  final double progress;

  HazePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.amber.withOpacity(0.2);

    for (double y = 0; y < size.height; y += 20) {
      final opacity = 0.2 + (0.8 * (1 - (y / size.height)));
      paint.color = Colors.amber.withOpacity(opacity);
      canvas.drawRect(
          Rect.fromLTWH(0, y + progress * 10, size.width, 20), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SandDustAnimation extends StatelessWidget {
  final AnimationController controller;

  SandDustAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SandDustPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class SandDustPainter extends CustomPainter {
  final double progress;

  SandDustPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.brown.withOpacity(0.3);
    final random = Random();

    for (int i = 0; i < 40; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      final radius = random.nextDouble() * 5 + 2; // Random particle size
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FogAnimation extends StatelessWidget {
  final AnimationController controller;

  FogAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: FogPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class FogPainter extends CustomPainter {
  final double progress;

  FogPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.3);

    for (double y = 0; y < size.height; y += 30) {
      final opacity = 0.3 + (0.4 * (1 - (y / size.height)));
      paint.color = Colors.grey.withOpacity(opacity);
      canvas.drawRect(
          Rect.fromLTWH(0, y + progress * 10, size.width, 30), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class MixedPrecipitationAnimation extends StatelessWidget {
  final AnimationController controller;

  MixedPrecipitationAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: MixedPrecipitationPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class MixedPrecipitationPainter extends CustomPainter {
  final double progress;

  MixedPrecipitationPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rainPaint = Paint()..color = Colors.blueAccent;
    final snowPaint = Paint()..color = Colors.white;
    final random = Random();

    for (int i = 0; i < 20; i++) {
      // Rain effect
      final rainX = random.nextDouble() * size.width;
      final rainY =
          (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(
          Offset(rainX, rainY), Offset(rainX, rainY + 10), rainPaint);

      // Snow effect
      final snowX = random.nextDouble() * size.width;
      final snowY =
          (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawCircle(Offset(snowX, snowY), 3, snowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SandAnimation extends StatelessWidget {
  final AnimationController controller;

  SandAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SandPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class SandPainter extends CustomPainter {
  final double progress;

  SandPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.brown.withOpacity(0.5);
    final random = Random();

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DustAnimation extends StatelessWidget {
  final AnimationController controller;

  DustAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DustPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class DustPainter extends CustomPainter {
  final double progress;

  DustPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(0.5);
    final random = Random();

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawCircle(Offset(x, y), 1 + random.nextDouble() * 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class VolcanicAshAnimation extends StatelessWidget {
  final AnimationController controller;

  VolcanicAshAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: VolcanicAshPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class VolcanicAshPainter extends CustomPainter {
  final double progress;

  VolcanicAshPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);
    final random = Random();

    for (int i = 0; i < 60; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() - progress) * size.height % size.height;
      final radius = random.nextDouble() * 3 + 1; // Ash particle size
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SquallAnimation extends StatelessWidget {
  final AnimationController controller;

  SquallAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SquallPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class SquallPainter extends CustomPainter {
  final double progress;

  SquallPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final rainPaint = Paint()..color = Colors.blue.withOpacity(0.7);
    final windPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 2;
    final random = Random();

    // Draw rain
    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() + progress) * size.height % size.height;
      canvas.drawLine(
          Offset(x, y), Offset(x - 10, y + 15), rainPaint); // Slanted rain
    }

    // Draw wind streaks
    for (int i = 0; i < 10; i++) {
      final y = random.nextDouble() * size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width * 0.8 + progress * size.width % size.width, y),
        windPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TornadoAnimation extends StatelessWidget {
  final AnimationController controller;

  TornadoAnimation({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: TornadoPainter(controller.value),
          child: Container(),
        );
      },
    );
  }
}

class TornadoPainter extends CustomPainter {
  final double progress;

  TornadoPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final vortexPaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final debrisPaint = Paint()..color = Colors.brown.withOpacity(0.7);
    final random = Random();

    // Draw vortex
    for (double i = 0; i < 1; i += 0.1) {
      final widthFactor = size.width * 0.1 + i * size.width * 0.4;
      final heightFactor = size.height * (1 - i);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, heightFactor),
          width: widthFactor,
          height: size.height * 0.05,
        ),
        vortexPaint,
      );
    }

    // Draw flying debris
    for (int i = 0; i < 30; i++) {
      final angle = random.nextDouble() * 2 * pi;
      final radius = (random.nextDouble() * size.width * 0.4) +
          progress * size.width % size.width;
      final x = size.width / 2 + radius * cos(angle);
      final y = size.height / 2 + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 3, debrisPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
