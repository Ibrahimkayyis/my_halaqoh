import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/santri_list_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/guru_list_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/halaqoh_list_screen.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/screens/target_hafalan_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';

@RoutePage()
class DashboardWrapperScreen extends StatefulWidget {
  const DashboardWrapperScreen({super.key});

  @override
  State<DashboardWrapperScreen> createState() => _DashboardWrapperScreenState();
}

class _DashboardWrapperScreenState extends State<DashboardWrapperScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToTab(int index) {
    _controller.jumpTo(index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final pages = <Widget>[
      DashboardScreen(onNavigateToTab: _navigateToTab),
      const SantriListScreen(),
      const GuruListScreen(),
      const HalaqohListScreen(),
      const TargetHafalanScreen(),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          unauthenticated: () {
            context.router.replaceAll([const LoginRoute()]);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: colors.surface,
        showLabel: true,
        textOverflow: TextOverflow.visible,
        maxLine: 1,
        shadowElevation: 5,
        kBottomRadius: 20.0,
        notchColor: colors.primary,
        removeMargins: false,
        showShadow: true,
        durationInMilliSeconds: 300,
        itemLabelStyle: TextStyle(
          fontSize: 9.sp,
          fontFamily: 'Poppins',
          color: colors.textSecondary,
        ),
        elevation: 2,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: Icon(Icons.dashboard, color: colors.textSecondary),
            activeItem: Icon(Icons.dashboard, color: colors.textOnButton),
            itemLabel: t.nav.dashboard,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.groups, color: colors.textSecondary),
            activeItem: Icon(Icons.groups, color: colors.textOnButton),
            itemLabel: t.nav.santri,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.school, color: colors.textSecondary),
            activeItem: Icon(Icons.school, color: colors.textOnButton),
            itemLabel: t.nav.guru,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.auto_stories, color: colors.textSecondary),
            activeItem: Icon(Icons.auto_stories, color: colors.textOnButton),
            itemLabel: t.nav.halaqoh,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.track_changes,
              color: colors.textSecondary,
            ),
            activeItem: Icon(Icons.track_changes, color: colors.textOnButton),
            itemLabel: t.nav.target,
          ),
        ],
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        kIconSize: 24.0,
      ),
      ),
    );
  }
}
