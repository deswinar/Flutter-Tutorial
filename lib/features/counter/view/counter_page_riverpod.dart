import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorial_app/features/counter/counter.dart';
import 'package:tutorial_app/l10n/l10n.dart';

class CounterPageRiverpod extends StatelessWidget {
  const CounterPageRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: CounterViewRiverpod());
  }
}

class CounterViewRiverpod extends ConsumerWidget {
  const CounterViewRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final count = ref.watch(counterProvider); // Watching the counter state

    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: Center(
        child: Text(
          '$count',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () =>
                ref.read(counterProvider.notifier).state++, // Increment counter
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: null,
            onPressed: () =>
                ref.read(counterProvider.notifier).state--, // Decrement counter
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
