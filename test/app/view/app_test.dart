import 'package:flutter_test/flutter_test.dart';
import 'package:tutorial_app/app/app.dart';
import 'package:tutorial_app/features/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPageCubit', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPageCubit), findsOneWidget);
    });
    testWidgets('renders CounterPageRiverpod', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPageRiverpod), findsOneWidget);
    });
  });
}
