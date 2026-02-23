import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/login_screen.dart';
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
        return const MaterialApp(
          home: LoginScreen(),
        );
      },
    );
  }

  group('LoginScreen', () {
    testWidgets('renders login title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Login'), findsWidgets);
    });

    testWidgets('renders login subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Sign in to your account'), findsOneWidget);
    });

    testWidgets('renders username label and field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('USERNAME / EMAIL'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Enter your username'), findsOneWidget);
    });

    testWidgets('renders password label and field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('PASSWORD'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Enter your password'), findsOneWidget);
    });

    testWidgets('password field is obscured by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      final textField = tester.widgetList<TextField>(find.byType(TextField)).last;
      expect(textField.obscureText, isTrue);
    });

    testWidgets('toggling password visibility works', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Initially obscured
      var textField = tester.widgetList<TextField>(find.byType(TextField)).last;
      expect(textField.obscureText, isTrue);

      // Scroll to and tap visibility toggle
      final iconFinder = find.byIcon(Icons.visibility_off_outlined);
      await tester.ensureVisible(iconFinder);
      await tester.pump();
      await tester.tap(iconFinder);
      await tester.pump();

      // Now visible
      textField = tester.widgetList<TextField>(find.byType(TextField)).last;
      expect(textField.obscureText, isFalse);
    });

    testWidgets('renders forgot password link', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Lupa Password?'), findsOneWidget);
    });

    testWidgets('renders LOGIN button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.widgetWithText(ElevatedButton, 'LOGIN'), findsOneWidget);
    });

    testWidgets('renders header with logo', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders app title in header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('MyHalaqoh'), findsOneWidget);
    });

    testWidgets('renders subtitle in header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text('Halaqoh Management System'), findsAtLeast(1));
    });
  });
}
