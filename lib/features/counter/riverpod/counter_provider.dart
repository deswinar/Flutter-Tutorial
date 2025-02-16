import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a StateProvider to manage the counter state
final counterProvider = StateProvider<int>((ref) => 0); // Default value is 0

// You can also use `StateNotifierProvider` if you prefer a more complex logic.
// Example with StateNotifier
// class CounterNotifier extends StateNotifier<int> {
//   CounterNotifier() : super(0);

//   void increment() => state++;
//   void decrement() => state--;
// }
// final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) => CounterNotifier());
