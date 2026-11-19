import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:simponi_ukmpk/app/app.dart';
import 'package:simponi_ukmpk/features/auth/providers/auth_provider.dart';

void main() {
  testWidgets('SIMPONI app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const SimponiApp(),
      ),
    );

    expect(find.byType(SimponiApp), findsOneWidget);
  });
}
