import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_app/features/counter/counter.dart';
import 'package:tutorial_app/l10n/l10n.dart';

class CounterPageCubit extends StatelessWidget {
  const CounterPageCubit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterViewCubit(),
    );
  }
}

class CounterViewCubit extends StatelessWidget {
  const CounterViewCubit({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.counterAppBarTitle)),
      body: const Center(child: CounterText()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => context.read<CounterCubit>().increment(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: null,
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
