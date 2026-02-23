import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/splash_screen.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';

void main() {
  setUp(() {
    LocaleSettings.setLocaleRawSync('en');
  });

  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          home: const SplashScreen(
            splashDuration: Duration(days: 1),
          ),
        );
      },
    );
  }

  group('SplashScreen', () {
    testWidgets('renders app title "MyHalaqoh"', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('MyHalaqoh'), findsOneWidget);
    });

    testWidgets('renders subtitle "Halaqoh Management System"', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Halaqoh Management System'), findsOneWidget);
    });

    testWidgets('renders version text "v1.0.0"', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('v1.0.0'), findsOneWidget);
    });

    testWidgets('renders logo image', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('has white background', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });
  });
}
