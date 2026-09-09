import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

void main() {
  setUpAll(() async {
    await LocaleSettings.setLocale(AppLocale.id);
  });

  Widget createTestWidget({required void Function(BuildContext) onTrigger}) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (innerContext) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () => onTrigger(innerContext),
                    child: const Text('Trigger SnackBar'),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  group('AppSnackBar', () {
    testWidgets('shows success snackbar with message and icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          onTrigger: (context) {
            AppSnackBar.showSuccess(
              context,
              message: 'Data berhasil disimpan',
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text('Data berhasil disimpan'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
      expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    });

    testWidgets('shows error snackbar with message and error icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          onTrigger: (context) {
            AppSnackBar.showError(
              context,
              message: 'Gagal menyimpan data',
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text('Gagal menyimpan data'), findsOneWidget);
      expect(find.byIcon(Icons.error_rounded), findsOneWidget);
    });

    testWidgets('shows title and message when title is provided', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          onTrigger: (context) {
            AppSnackBar.showSuccess(
              context,
              title: 'Berhasil',
              message: 'Absensi telah diperbarui',
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text('Berhasil'), findsOneWidget);
      expect(find.text('Absensi telah diperbarui'), findsOneWidget);
    });

    testWidgets('dismisses snackbar when close icon is tapped', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          onTrigger: (context) {
            AppSnackBar.showInfo(
              context,
              message: 'Informasi sistem',
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text('Informasi sistem'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Informasi sistem'), findsNothing);
    });

    testWidgets('renders action button and triggers callback', (tester) async {
      var actionTriggered = false;

      await tester.pumpWidget(
        createTestWidget(
          onTrigger: (context) {
            AppSnackBar.showWarning(
              context,
              message: 'Koneksi lambat',
              actionLabel: 'Coba Lagi',
              onAction: () {
                actionTriggered = true;
              },
            );
          },
        ),
      );

      await tester.tap(find.text('Trigger SnackBar'));
      await tester.pumpAndSettle();

      expect(find.text('Coba Lagi'), findsOneWidget);
      expect(find.byIcon(Icons.warning_rounded), findsOneWidget);

      await tester.tap(find.text('Coba Lagi'));
      await tester.pumpAndSettle();

      expect(actionTriggered, isTrue);
    });
  });
}
