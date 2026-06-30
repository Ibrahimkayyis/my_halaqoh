import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/colors.gen.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_cubit.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_state.dart';

/// A custom [AppBar] shown whenever a super admin is in impersonation mode.
///
/// Uses amber/yellow background to visually signal that the UI is operating
/// under an impersonated identity. Shows the role name + entity name,
/// and a leading "Keluar" button that returns to [SuperAdminPickerRoute].
class ImpersonationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Creates an [ImpersonationAppBar] for the given [title] (page name).
  const ImpersonationAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  /// The name of the current page (e.g. `'Absensi'`, `'Hafalan'`).
  final String title;

  /// Optional additional action buttons.
  final List<Widget>? actions;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImpersonationCubit, ImpersonationState>(
      builder: (context, state) {
        final label = state.maybeWhen(
          active: (ctx) {
            final roleLabel = switch (ctx.targetRole) {
              'admin' => 'Admin',
              'guru' => 'Guru',
              'santri' => 'Wali Santri',
              _ => ctx.targetRole,
            };
            final name = ctx.displayName;
            return name != null ? 'Mode $roleLabel: $name' : 'Mode $roleLabel';
          },
          orElse: () => 'Mode Impersonasi',
        );

        return AppBar(
          backgroundColor: ColorName.yellow,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            tooltip: 'Keluar dari mode impersonasi',
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              context.read<ImpersonationCubit>().exitImpersonation();
              context.router.replace(const SuperAdminPickerRoute());
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: actions,
        );
      },
    );
  }
}
