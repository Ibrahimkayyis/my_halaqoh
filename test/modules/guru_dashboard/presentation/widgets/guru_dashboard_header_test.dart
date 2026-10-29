import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/guru_dashboard_header.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_cubit.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_state.dart';

class MockNotificationBadgeCubit extends Mock implements NotificationBadgeCubit {
  @override
  Future<void> close() async {}
}

class MockAuthCubit extends Mock implements AuthCubit {
  @override
  Future<void> close() async {}
}

void main() {
  late MockNotificationBadgeCubit mockNotificationBadgeCubit;
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockNotificationBadgeCubit = MockNotificationBadgeCubit();
    mockAuthCubit = MockAuthCubit();

    when(() => mockNotificationBadgeCubit.state).thenReturn(
      const NotificationBadgeState.loaded(items: [], unreadCount: 0),
    );
    when(() => mockNotificationBadgeCubit.stream).thenAnswer((_) => const Stream.empty());

    final sl = GetIt.instance;
    if (sl.isRegistered<NotificationBadgeCubit>()) {
      sl.unregister<NotificationBadgeCubit>();
    }
    sl.registerSingleton<NotificationBadgeCubit>(mockNotificationBadgeCubit);
  });

  tearDown(() {
    final sl = GetIt.instance;
    if (sl.isRegistered<NotificationBadgeCubit>()) {
      sl.unregister<NotificationBadgeCubit>();
    }
  });

  Widget buildTestWidget({required String name, Size screenSize = const Size(390, 844)}) {
    return MediaQuery(
      data: MediaQueryData(size: screenSize),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: BlocProvider<AuthCubit>.value(
                value: mockAuthCubit,
                child: GuruDashboardHeader(
                  name: name,
                  dateText: 'Kamis, 29 Oktober 2026',
                  halaqohName: 'Halaqoh Al-Fatih 2',
                  santriCount: 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders long teacher name without overflow and without ellipsis truncation', (tester) async {
    const longName = 'Ust. Dr. H. Muhammad Abdurrahman Al-Faruqi, Lc., M.A.';

    await tester.pumpWidget(buildTestWidget(name: longName));
    await tester.pump();

    // Verify no exception / overflow
    expect(tester.takeException(), isNull);

    // Verify the full name text widget exists and is rendered
    final nameFinder = find.text(longName.toUpperCase());
    expect(nameFinder, findsOneWidget);

    final textWidget = tester.widget<Text>(nameFinder);
    expect(textWidget.maxLines, isNull, reason: 'maxLines should be null to allow full multi-line rendering');
    expect(textWidget.softWrap, isTrue);

    // Verify it renders completely on small screen as well (e.g. 360 width)
    await tester.pumpWidget(buildTestWidget(name: longName, screenSize: const Size(360, 640)));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.text(longName.toUpperCase()), findsOneWidget);
  });

  testWidgets('renders standard short teacher name cleanly', (tester) async {
    const shortName = 'Ust. Mufti Al-Faruqi';

    await tester.pumpWidget(buildTestWidget(name: shortName));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text(shortName.toUpperCase()), findsOneWidget);
  });
}
