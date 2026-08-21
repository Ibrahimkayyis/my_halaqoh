import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/screens/login_screen.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    LocaleSettings.setLocaleRawSync('en');
    mockAuthCubit = MockAuthCubit();
    when(() => mockAuthCubit.state).thenReturn(const AuthState.initial());
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget createTestWidget() {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          home: BlocProvider<AuthCubit>.value(
            value: mockAuthCubit,
            child: const LoginScreen(),
          ),
        );
      },
    );
  }

  group('LoginScreen', () {
    testWidgets('renders login title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text(t.auth.loginTitle), findsWidgets);
    });

    testWidgets('renders login subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text(t.auth.loginSubtitle), findsOneWidget);
    });

    testWidgets('renders username label and field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text(t.auth.usernameLabel), findsOneWidget);
      expect(find.widgetWithText(TextField, t.auth.usernameHint), findsOneWidget);
    });

    testWidgets('renders password label and field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text(t.auth.passwordLabel), findsOneWidget);
      expect(find.widgetWithText(TextField, t.auth.passwordHint), findsOneWidget);
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
      expect(find.text(t.auth.forgotPassword), findsOneWidget);
    });

    testWidgets('renders LOGIN button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.widgetWithText(PrimaryButton, t.auth.loginButton), findsOneWidget);
    });

    testWidgets('renders header with logo', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders app title in header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text(t.app.title), findsOneWidget);
    });

    testWidgets('renders subtitle in header', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();
      expect(find.text(t.splash.subtitle), findsAtLeast(1));
    });
  });
}
