import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutorial_app/router/app_router.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildMenuItem(
              context,
              title: 'Counter using Cubit',
              description: 'Learn how to use Cubit for state management.',
              routeName: Routes.counterCubit,
            ),
            _buildMenuItem(
              context,
              title: 'Counter using Riverpod',
              description: 'Learn how to use Riverpod for state management.',
              routeName: Routes.counterRiverpod,
            ),
            _buildMenuItem(
              context,
              title: 'Weather App',
              description: 'A simple app to display the weather forecast.',
              routeName: Routes.weather,
            ),
            _buildMenuItem(
              context,
              title: 'Google Maps Flutter',
              description:
                  'Tutorial  Google Maps API using google_maps_flutter.',
              routeName: Routes.tutorialGoogleMaps,
            ),
            _buildMenuItem(
              context,
              title: 'Tutorial Animation',
              description: 'Tutorial Animation background.',
              routeName: Routes.tutorialAnimation,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String description,
    required String routeName,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: () {
          context.push(routeName); // Use GoRouter for navigation
        },
        title: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
